#!/usr/bin/env python3
"""Generate Verilator TB golden vectors from FixedPointLIF (陈正共) — G3 金标独立。"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from phase4_fpga_lif_fixedpoint import FixedPointLIF

ROOT = Path(__file__).resolve().parents[1]
OUT_DEFAULT = ROOT / "fpga" / "sim" / "lif_step_golden_vectors.json"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    args = ap.parse_args()

    currents = [
        0.0,
        0.0,
        1.2,
        0.0,
        0.0,
        1.1,
        1.1,
        0.0,
        0.0,
        1.05,
        0.5,
        2.0,
        -0.1,
        8.0,
        -8.0,
        0.9,
        1.0,
        1.00001,
    ]
    lif = FixedPointLIF()
    vecs = []
    mem = 0
    for cur in currents:
        cur_fp = int(round(cur * lif.scale))
        spk, mem_next = lif.step(cur_fp, mem)
        vecs.append(
            {"cur_fp": cur_fp, "mem_in_fp": mem, "spk": spk, "mem_out_fp": mem_next}
        )
        mem = mem_next
    payload = {
        "schema": "lif-golden-vectors-v0",
        "golden": "scripts/phase4_fpga_lif_fixedpoint.py::FixedPointLIF",
        "frac_bits": lif.frac_bits,
        "beta_fp": lif.beta_fp,
        "th_fp": lif.th_fp,
        "vectors": vecs,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    # C header for TB
    h = args.out.with_suffix(".inc")
    lines = [
        f"// AUTO-GEN from FixedPointLIF — do not edit",
        f"static const int GOLDEN_N = {len(vecs)};",
        "static const int32_t GOLDEN_CUR[] = {",
        ", ".join(str(v["cur_fp"]) for v in vecs) + "};",
        "static const int32_t GOLDEN_MEM_IN[] = {",
        ", ".join(str(v["mem_in_fp"]) for v in vecs) + "};",
        "static const int32_t GOLDEN_SPK[] = {",
        ", ".join(str(v["spk"]) for v in vecs) + "};",
        "static const int32_t GOLDEN_MEM_OUT[] = {",
        ", ".join(str(v["mem_out_fp"]) for v in vecs) + "};",
        "",
    ]
    h.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {args.out} and {h} n={len(vecs)} golden=FixedPointLIF")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
