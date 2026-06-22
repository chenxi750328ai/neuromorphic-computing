#!/usr/bin/env python3
"""Phase4 path B · fixed-point LIF spike accumulation (reference for FPGA/HLS).

Aligns with MnistSNNUnrolled lif_step: subtract reset, beta leak, threshold 1.0.
"""
from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


@dataclass
class FixedPointLIF:
    """Q16.16 fixed-point LIF neuron."""

    beta: float = 0.9
    threshold: float = 1.0
    frac_bits: int = 16

    def __post_init__(self) -> None:
        self.scale = 1 << self.frac_bits
        self.beta_fp = int(round(self.beta * self.scale))
        self.th_fp = int(round(self.threshold * self.scale))

    def step(self, cur_fp: int, mem_fp: int) -> tuple[int, int]:
        """One LIF step. cur_fp/mem_fp are Q16.16 integers."""
        reset = 1 if mem_fp >= self.th_fp else 0
        mem_fp = (self.beta_fp * mem_fp) // self.scale + cur_fp - reset * self.th_fp
        spk = 1 if mem_fp >= self.th_fp else 0
        return spk, mem_fp

    def run(self, currents: list[float], mem0: float = 0.0) -> tuple[list[int], list[int], int]:
        mem_fp = int(round(mem0 * self.scale))
        spikes: list[int] = []
        mem_trace: list[int] = []
        total = 0
        for cur in currents:
            cur_fp = int(round(cur * self.scale))
            spk, mem_fp = self.step(cur_fp, mem_fp)
            spikes.append(spk)
            mem_trace.append(mem_fp)
            total += spk
        return spikes, mem_trace, total


def float_lif_step(cur: float, mem: float, beta: float = 0.9, threshold: float = 1.0) -> tuple[int, float]:
    reset = 1.0 if mem >= threshold else 0.0
    mem = beta * mem + cur - reset * threshold
    spk = 1 if mem >= threshold else 0
    return spk, mem


def float_run(currents: list[float], mem0: float = 0.0) -> tuple[list[int], int]:
    mem = mem0
    spikes: list[int] = []
    total = 0
    for cur in currents:
        spk, mem = float_lif_step(cur, mem)
        spikes.append(spk)
        total += spk
    return spikes, total


def main() -> int:
    p = argparse.ArgumentParser(description="Fixed-point LIF spike accumulation reference")
    p.add_argument("--out", type=Path, default=ROOT / "runs" / "phase4_poc" / "fpga_spike_accum.json")
    args = p.parse_args()

    test_cases = [
        {"name": "single_spike", "currents": [0.0, 1.2, 0.0, 0.0, 0.0]},
        {"name": "burst", "currents": [1.1, 1.1, 1.1, 0.0, 0.0, 1.1]},
        {"name": "subthreshold", "currents": [0.3, 0.3, 0.3, 0.3, 0.3]},
        {"name": "mnist_like", "currents": [0.0] * 5 + [1.05, 0.0, 1.1, 0.0, 0.0] * 4},
    ]

    lif = FixedPointLIF()
    results = []
    all_pass = True

    for tc in test_cases:
        f_spikes, f_total = float_run(tc["currents"])
        q_spikes, _, q_total = lif.run(tc["currents"])
        match = f_spikes == q_spikes and f_total == q_total
        all_pass = all_pass and match
        results.append(
            {
                "case": tc["name"],
                "timesteps": len(tc["currents"]),
                "float_spikes": f_spikes,
                "fixed_spikes": q_spikes,
                "float_total": f_total,
                "fixed_total": q_total,
                "match": match,
            }
        )

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "format": "Q16.16",
        "beta": lif.beta,
        "threshold": lif.threshold,
        "all_match": all_pass,
        "cases": results,
    }

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

    print(f"fixed_point_lif: all_match={all_pass}")
    for r in results:
        status = "PASS" if r["match"] else "FAIL"
        print(f"  {r['case']}: {status} total={r['fixed_total']}")
    print(f"wrote {args.out}")

    return 0 if all_pass else 1


if __name__ == "__main__":
    raise SystemExit(main())
