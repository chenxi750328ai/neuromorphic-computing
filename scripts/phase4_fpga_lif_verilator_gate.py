#!/usr/bin/env python3
"""F6 S0 · Verilator 开源仿真门禁（主信任根）— 陈正共.

不依赖 Vivado。缺 verilator 时 --gate 失败（CI 须安装）。
"""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RTL = ROOT / "fpga" / "rtl"
SIM = ROOT / "fpga" / "sim"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_lif_verilator_gate.json"


def run_one(module: str, rtl_files: list[Path], tb: Path, work: Path) -> dict:
    obj = work / module
    obj.mkdir(parents=True, exist_ok=True)
    # prod[63:0] 仅取 [47:16] 为设计意图；AXI wstrb 未用属简化从机
    warn = ["-Wno-DECLFILENAME", "-Wno-UNUSEDSIGNAL", "-Wno-UNUSEDPARAM"]
    cmd = [
        "verilator",
        "-Wall",
        *warn,
        "--cc",
        "--exe",
        "--build",
        "-j",
        "0",
        "-Mdir",
        str(obj),
        "--top-module",
        module,
        *[str(p) for p in rtl_files],
        str(tb),
        "-o",
        module + "_sim",
    ]
    r = subprocess.run(cmd, cwd=str(ROOT), capture_output=True, text=True)
    build_ok = r.returncode == 0
    exe = obj / (module + "_sim")
    run_out = ""
    run_code = -1
    if build_ok and exe.is_file():
        rr = subprocess.run([str(exe)], capture_output=True, text=True)
        run_code = rr.returncode
        run_out = ((rr.stdout or "") + (rr.stderr or "")).strip()
    return {
        "module": module,
        "build_ok": build_ok,
        "build_stderr_tail": (r.stderr or "")[-800:],
        "run_exit": run_code,
        "run_out": run_out[-500:],
        "pass": build_ok and run_code == 0 and "PASS" in run_out,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    if not shutil.which("verilator"):
        print("FAIL verilator not installed", file=sys.stderr)
        return 1 if args.gate else 2

    with tempfile.TemporaryDirectory(prefix="vl_lif_") as td:
        work = Path(td)
        results = [
            run_one(
                "lif_step",
                [RTL / "lif_step.v"],
                SIM / "tb_lif_step.cpp",
                work,
            ),
            run_one(
                "lif_step_axi_lite",
                [RTL / "lif_step.v", RTL / "lif_step_axi_lite.v"],
                SIM / "tb_lif_step_axi_lite.cpp",
                work,
            ),
        ]

    ok = all(x["pass"] for x in results)
    ver_line = None
    if shutil.which("verilator"):
        ver_line = subprocess.run(
            ["verilator", "--version"], capture_output=True, text=True
        ).stdout.splitlines()[0]
    report = {
        "schema": "phase4.1-fpga-lif-verilator-gate-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "policy": "F6 S0 open-source sim is trust root; Vivado not required",
        "verilator": ver_line,
        "results": results,
        "pass": ok,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("PASS" if ok else "FAIL", "phase4_fpga_lif_verilator_gate")
    for x in results:
        print(f"  {x['module']}: {'PASS' if x['pass'] else 'FAIL'} {x.get('run_out', '')[:120]}")
        if not x["pass"] and x.get("build_stderr_tail"):
            print(x["build_stderr_tail"][-400:])
    print(f"wrote {args.out}")
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
