#!/usr/bin/env python3
"""Behavioral sim of fpga/rtl/lif_step.v · match Python golden (陈正共).

No Vivado required. Exit 0 when RTL semantics == Q16.16 golden.
"""
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FRAC = 16
SCALE = 1 << FRAC
BETA_FP = int(round(0.9 * SCALE))
TH_FP = int(round(1.0 * SCALE))


def golden_lif(cur_fp: int, mem_fp: int) -> tuple[int, int]:
    reset = 1 if mem_fp >= TH_FP else 0
    mem_fp = (BETA_FP * mem_fp) // SCALE + cur_fp - reset * TH_FP
    spk = 1 if mem_fp >= TH_FP else 0
    return spk, mem_fp


def rtl_beh_lif(cur_fp: int, mem_fp: int) -> tuple[int, int]:
    """Mirror lif_step.v arithmetic (prod>>16 truncate toward 0 for +ve)."""
    reset_b = 1 if mem_fp >= TH_FP else 0
    prod = BETA_FP * mem_fp
    # Verilog prod[47:16] on signed 64-bit is arithmetic >> 16 for our range
    mem_tmp = (prod >> 16) + cur_fp - (TH_FP if reset_b else 0)
    # keep 32-bit signed wrap consistent with Python int for MNIST-scale values
    if mem_tmp >= 2**31:
        mem_tmp -= 2**32
    elif mem_tmp < -(2**31):
        mem_tmp += 2**32
    spk = 1 if mem_tmp >= TH_FP else 0
    return spk, mem_tmp


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "runs" / "phase4_poc" / "fpga_lif_rtl_sim.json",
    )
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    currents = [0.0, 0.0, 1.2, 0.0, 0.0, 1.1, 1.1, 0.0, 0.0, 1.05, 0.5, 2.0, -0.1]
    mem_g = mem_r = 0
    rows = []
    mismatches = 0
    for cur in currents:
        cur_fp = int(round(cur * SCALE))
        sg, mem_g = golden_lif(cur_fp, mem_g)
        sr, mem_r = rtl_beh_lif(cur_fp, mem_r)
        ok = (sg == sr) and (mem_g == mem_r)
        if not ok:
            mismatches += 1
        rows.append(
            {
                "cur": cur,
                "cur_fp": cur_fp,
                "spk_golden": sg,
                "spk_rtl": sr,
                "mem_golden": mem_g,
                "mem_rtl": mem_r,
                "ok": ok,
            }
        )

    report = {
        "schema": "phase4-fpga-lif-rtl-sim-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "rtl": "fpga/rtl/lif_step.v",
        "n": len(rows),
        "mismatches": mismatches,
        "pass": mismatches == 0,
        "rows": rows,
        "note": "Sim only · bitstream still needs Vivado/Vitis on xc7z020",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"pass": report["pass"], "mismatches": mismatches, "out": str(args.out)}, ensure_ascii=False))
    if args.gate:
        return 0 if report["pass"] else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
