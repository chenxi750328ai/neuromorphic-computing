#!/usr/bin/env python3
"""从 bench JSON 生成分段延迟分布统计。"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]


def stats(vals: list[float]) -> dict:
    a = np.asarray(vals, dtype=float)
    return {
        "n": len(a),
        "min": round(float(a.min()), 2),
        "p50": round(float(np.percentile(a, 50)), 2),
        "p95": round(float(np.percentile(a, 95)), 2),
        "max": round(float(a.max()), 2),
        "mean": round(float(a.mean()), 2),
        "std": round(float(a.std()), 2),
    }


def main() -> int:
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "runs/phase4_poc/distributed_bench_atlas.json"
    data = json.loads(path.read_text())
    rows = data.get("per_sample") or []
    keys = ["t_preprocess_ms", "t_xfer_in_ms", "t_atlas_ms", "t_xfer_out_ms", "t_ssh_ms", "t_e2e_ms"]
    out = {k: stats([r[k] for r in rows if k in r]) for k in keys if any(k in r for r in rows)}
    for k, v in out.items():
        if k == "t_e2e_ms" and v["mean"] > 0:
            comm = out.get("t_xfer_in_ms", {}).get("mean", 0) + out.get("t_xfer_out_ms", {}).get("mean", 0)
            v["comm_ratio_mean"] = round(comm / v["mean"], 4)
    print(json.dumps({"source": str(path), "mode": data.get("mode"), "distribution": out}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
