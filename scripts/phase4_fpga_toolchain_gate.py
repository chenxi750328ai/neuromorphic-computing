#!/usr/bin/env python3
"""Phase4 FPGA 开发链路门禁（陈正共）。

合格定义（总裁口径）：
  类脑算子经工具链综合 → 烧 PL → 板上跑出结果 + 规格 + 资源占用。
点灯 / 仅 ARM Python ≠ PASS。
"""
from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def _run(cmd: list[str], timeout: float = 60) -> tuple[int, str]:
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except Exception as e:
        return 99, str(e)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default=os.environ.get("PYNQ_HOST", "192.168.137.3"))
    ap.add_argument("--user", default=os.environ.get("PYNQ_USER", "xilinx"))
    ap.add_argument("--pass", dest="password", default=os.environ.get("PYNQ_PASS", "xilinx"))
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "runs" / "phase4_poc" / "fpga_toolchain_gate.json",
    )
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    checks: dict[str, dict] = {}

    # A · sources
    hls = ROOT / "fpga" / "hls" / "lif_step.cpp"
    rtl = ROOT / "fpga" / "rtl" / "lif_step.v"
    tcl = ROOT / "fpga" / "vivado" / "create_lif_overlay.tcl"
    checks["src_hls"] = {"ok": hls.is_file(), "path": str(hls)}
    checks["src_rtl"] = {"ok": rtl.is_file(), "path": str(rtl)}
    checks["vivado_tcl"] = {"ok": tcl.is_file(), "path": str(tcl)}

    # B · RTL sim vs golden
    sim_out = ROOT / "runs" / "phase4_poc" / "fpga_lif_rtl_sim.json"
    rc, _ = _run(["python3", str(ROOT / "scripts" / "fpga_lif_rtl_sim.py"), "--out", str(sim_out), "--gate"])
    checks["rtl_sim_vs_golden"] = {"ok": rc == 0, "exit": rc, "report": str(sim_out)}

    # C · host toolchain
    vivado = shutil.which("vivado") or ""
    vitis_hls = shutil.which("vitis_hls") or ""
    for env_key in ("XILINX_VIVADO", "XILINX_VITIS", "VIVADO_PATH"):
        cand = os.environ.get(env_key)
        if cand and Path(cand).exists() and not vivado:
            vivado = cand
    checks["vivado_cli"] = {
        "ok": bool(vivado),
        "path": vivado or None,
        "note": "缺则无法综合/出 LUT 报告与 bitstream",
    }
    checks["vitis_hls_cli"] = {"ok": bool(vitis_hls), "path": vitis_hls or None}

    # D · board PL access (sudo Overlay)
    ssh = [
        "sshpass",
        "-p",
        args.password,
        "ssh",
        "-o",
        "StrictHostKeyChecking=no",
        "-o",
        "ConnectTimeout=8",
        f"{args.user}@{args.host}",
    ]
    board_py = (
        "echo "
        + args.password
        + " | sudo -S /usr/local/share/pynq-venv/bin/python3 -c \""
        "import os; os.environ['XILINX_XRT']='/usr';"
        "from pynq.overlays.base import BaseOverlay;"
        "b=BaseOverlay('base.bit');"
        "print('PL_ACCESS_OK', len(b.ip_dict))\""
    )
    rc, out = _run(ssh + [board_py], timeout=90)
    checks["pynq_pl_sudo_overlay"] = {
        "ok": rc == 0 and "PL_ACCESS_OK" in out,
        "exit": rc,
        "snippet": out[-400:],
    }

    # E · neuromorphic bitstream present?
    bit = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit"
    hwh = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.hwh"
    util = ROOT / "fpga" / "bitstreams" / "lif_step_utilization.rpt"
    checks["neuromorphic_bitstream"] = {
        "ok": bit.is_file() and hwh.is_file(),
        "bit": str(bit) if bit.is_file() else None,
        "hwh": str(hwh) if hwh.is_file() else None,
    }
    checks["resource_report"] = {"ok": util.is_file(), "path": str(util) if util.is_file() else None}

    # Pass rules
    chain_sim_ok = all(checks[k]["ok"] for k in ("src_hls", "src_rtl", "rtl_sim_vs_golden", "pynq_pl_sudo_overlay"))
    chain_full_ok = chain_sim_ok and checks["vivado_cli"]["ok"] and checks["neuromorphic_bitstream"]["ok"] and checks[
        "resource_report"
    ]["ok"]

    report = {
        "schema": "phase4-fpga-toolchain-gate-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "definition": "类脑算子工具链综合→烧PL→规格+资源；点灯≠PASS",
        "checks": checks,
        "chain_board_and_sim_ok": chain_sim_ok,
        "chain_full_pl_ok": chain_full_ok,
        "blocker": None
        if chain_full_ok
        else (
            "本机未找到 vivado/vitis_hls；无法综合 lif_step → bitstream/资源报告"
            if not checks["vivado_cli"]["ok"]
            else "缺 fpga/bitstreams/lif_step_overlay.{bit,hwh} 或 utilization.rpt"
        ),
        "next": [
            "在装有 Vivado 的机器: cd fpga/hls && vitis_hls -f run_lif_step.tcl",
            "或: vivado -mode batch -source fpga/vivado/create_lif_overlay.tcl",
            "把 .bit/.hwh/utilization.rpt 拷到 fpga/bitstreams/",
            "再跑 scripts/phase4_fpga_pynq_lif_pl.py --gate",
        ],
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    if args.gate:
        return 0 if chain_full_ok else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
