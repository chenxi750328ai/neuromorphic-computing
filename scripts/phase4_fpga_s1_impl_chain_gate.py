#!/usr/bin/env python3
"""F6 S1 · 实现链降依赖门禁（陈正共）.

- Yosys 对 lif_step 开源综合对照（generic cell 统计；非 xc7 LUT 等价）
- Vivado 钉版本指纹（本机已装路径；辅证后端）
- batch TCL 出 bit 脚本存在性（开发默认不依赖 GUI）
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RTL = ROOT / "fpga" / "rtl" / "lif_step.v"
TCL = ROOT / "fpga" / "vivado" / "create_lif_overlay.tcl"
UTIL = ROOT / "fpga" / "bitstreams" / "lif_step_utilization.rpt"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_s1_impl_chain_gate.json"
PINNED_VIVADO = "2023.2"
CANDIDATE_VIVADO = [
    Path("/tools/Xilinx/Vivado/2023.2"),
    Path("/opt/Xilinx/Vivado/2023.2"),
]


def parse_yosys_stat(log: str) -> dict:
    cells: dict[str, int] = {}
    total = None
    for line in log.splitlines():
        m = re.match(r"\s+Number of cells:\s+(\d+)", line)
        if m:
            total = int(m.group(1))
        m = re.match(r"\s+(\$_\w+)\s+(\d+)", line)
        if m:
            cells[m.group(1)] = int(m.group(2))
    return {"cells_total": total, "cells": cells}


def run_yosys() -> dict:
    if not shutil.which("yosys"):
        return {"ok": False, "error": "yosys not installed"}
    if not RTL.is_file():
        return {"ok": False, "error": f"missing {RTL}"}
    script = f"""
read_verilog {RTL}
hierarchy -check -top lif_step
proc; opt; fsm; opt; memory; opt
techmap; opt
stat
"""
    with tempfile.TemporaryDirectory(prefix="yosys_s1_") as td:
        logp = Path(td) / "stat.log"
        r = subprocess.run(
            ["yosys", "-q", "-p", script, "-l", str(logp)],
            capture_output=True,
            text=True,
        )
        log = logp.read_text(encoding="utf-8", errors="replace") if logp.is_file() else ""
    stats = parse_yosys_stat(log)
    ver = subprocess.run(["yosys", "-V"], capture_output=True, text=True).stdout.splitlines()
    return {
        "ok": r.returncode == 0 and stats.get("cells_total") is not None,
        "exit": r.returncode,
        "yosys_version": ver[0] if ver else None,
        "top": "lif_step",
        "note": "generic techmap cells — not xc7 LUT-equivalent; order-of-magnitude open-source synth only",
        **stats,
    }


def parse_vivado_util() -> dict | None:
    if not UTIL.is_file():
        return None
    text = UTIL.read_text(encoding="utf-8", errors="replace")
    out: dict = {"path": str(UTIL.relative_to(ROOT))}
    m = re.search(r"Slice LUTs\*\s*\|\s*(\d+)", text)
    if m:
        out["slice_luts"] = int(m.group(1))
    m = re.search(r"Slice Registers\s*\|\s*(\d+)", text)
    if m:
        out["slice_registers"] = int(m.group(1))
    return out


def vivado_pin() -> dict:
    """status: pinned | absent | unpinned — unpinned 必须红；absent 仅 CI 可过。"""
    root = None
    for p in CANDIDATE_VIVADO:
        if (p / "bin" / "vivado").is_file():
            root = p
            break
    env = os.environ.get("XILINX_VIVADO")
    if env and Path(env).is_dir():
        root = Path(env)
    if not root:
        which = shutil.which("vivado")
        return {
            "ok": True,
            "status": "absent",
            "pinned": PINNED_VIVADO,
            "found": None,
            "which": which,
            "note": "本机未找到 Vivado 安装；CI 不要求 Vivado",
        }
    vivado_bin = root / "bin" / "vivado"
    settings = root / "settings64.sh"
    fingerprints = {}
    for f in (vivado_bin, settings):
        if f.is_file():
            h = subprocess.run(["md5sum", str(f)], capture_output=True, text=True)
            fingerprints[str(f)] = (h.stdout or "").split()[0] if h.returncode == 0 else None
    ver_out = ""
    try:
        vr = subprocess.run([str(vivado_bin), "-version"], capture_output=True, text=True, timeout=60)
        ver_out = (vr.stdout or "") + (vr.stderr or "")
    except (subprocess.SubprocessError, OSError) as e:
        ver_out = str(e)
    version_ok = bool(vivado_bin.is_file()) and (
        PINNED_VIVADO in ver_out or root.name == PINNED_VIVADO
    )
    status = "pinned" if version_ok else "unpinned"
    return {
        "ok": version_ok,
        "status": status,
        "pinned": PINNED_VIVADO,
        "install_root": str(root),
        "version_head": "\n".join(ver_out.splitlines()[:5]),
        "fingerprints_md5": fingerprints,
        "policy": "辅证/出 bit 后端；不得替代 Verilator 主门",
        "license_note": "使用本机已授权安装；禁止把 license/密钥写入 Git",
        "note": None
        if version_ok
        else f"发现 Vivado 但非钉版本 {PINNED_VIVADO}；须对齐或清 XILINX_VIVADO",
    }


def batch_tcl() -> dict:
    text = TCL.read_text(encoding="utf-8") if TCL.is_file() else ""
    has_batch_hint = "vivado -mode batch" in text or "mode batch" in text.lower() or TCL.is_file()
    return {
        "ok": TCL.is_file() and "launch_runs" in text,
        "path": str(TCL.relative_to(ROOT)) if TCL.is_file() else None,
        "usage": "source <Vivado>/settings64.sh && cd fpga/vivado && vivado -mode batch -source create_lif_overlay.tcl",
        "gui_default_forbidden": True,
        "has_synth_util": "report_utilization" in text,
        "batch_documented": has_batch_hint,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    yosys = run_yosys()
    viv = vivado_pin()
    tcl = batch_tcl()
    util = parse_vivado_util()

    # S1: Yosys+TCL 必过；Vivado absent=CI 可过；pinned=过；unpinned=红
    viv_status = viv.get("status") or "absent"
    viv_gate_ok = viv_status in ("pinned", "absent")
    checks_ok = bool(yosys.get("ok") and tcl.get("ok") and viv_gate_ok)
    report = {
        "schema": "phase4.1-fpga-s1-impl-chain-gate-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "phase": "F6-S1",
        "yosys_synth": yosys,
        "vivado_pin": viv,
        "batch_tcl": tcl,
        "vivado_util_aux": util,
        "compare_note": (
            "Yosys generic cells vs Vivado Slice LUTs are not 1:1; "
            "S1 proves open-source synth path exists + Vivado remains pinned aux backend."
        ),
        "pass": checks_ok,
        "ci_vivado_optional": True,
        "vivado_status": viv_status,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("PASS" if checks_ok else "FAIL", "phase4_fpga_s1_impl_chain_gate")
    print(f"  yosys: {'ok' if yosys.get('ok') else 'FAIL'} cells={yosys.get('cells_total')}")
    print(f"  vivado_pin: {viv_status} root={viv.get('install_root')}")
    print(f"  batch_tcl: {'ok' if tcl.get('ok') else 'FAIL'}")
    if util:
        print(f"  vivado_util_aux: LUTs={util.get('slice_luts')} regs={util.get('slice_registers')}")
    print(f"wrote {args.out}")
    return 0 if (checks_ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
