#!/usr/bin/env python3
"""Phase4.1 · 对照探索规格 G-ACC/G-LAT/G-COMM 出判定报告（陈正共）。

对已有 bench JSON（如 distributed_bench_daemon_n100.json）按
docs/Phase4.1_探索规格与补数议程_V0.md §2 口径统计：
  暖机丢弃、离群（e2e>100ms）不计入百分位、G-COMM C3= p95/p50。

Atlas 不通时也可对历史结果做规格试算（E3 正式须现场重测 vs ORT）。
"""
from __future__ import annotations

import argparse
import json
import math
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]


def _pct(xs: list[float], p: float) -> float:
    if not xs:
        return float("nan")
    ys = sorted(xs)
    if len(ys) == 1:
        return ys[0]
    k = (p / 100.0) * (len(ys) - 1)
    lo = int(math.floor(k))
    hi = int(math.ceil(k))
    if lo == hi:
        return ys[lo]
    return ys[lo] * (hi - k) + ys[hi] * (k - lo)


def evaluate(
    rows: list[dict[str, Any]],
    *,
    warmup: int = 5,
    outlier_ms: float = 100.0,
    g_acc: float = 0.98,
    g_lat_p50: float = 5.0,
    g_lat_p95: float = 10.0,
    g_comm_ratio: float = 5.0,
    match_key: str = "pred_match",
) -> dict[str, Any]:
    n = len(rows)
    after_warm = rows[warmup:] if n > warmup else list(rows)
    outliers = [r for r in after_warm if float(r.get("t_e2e_ms", 0)) > outlier_ms]
    steady = [r for r in after_warm if float(r.get("t_e2e_ms", 0)) <= outlier_ms]
    e2e = [float(r["t_e2e_ms"]) for r in steady if "t_e2e_ms" in r]
    matches = [bool(r.get(match_key)) for r in after_warm if match_key in r]
    # ACC on after_warm (including outliers) — accuracy shouldn't hide fails
    acc = (sum(matches) / len(matches)) if matches else float("nan")
    p50 = _pct(e2e, 50)
    p95 = _pct(e2e, 95)
    ratio = (p95 / p50) if p50 and p50 > 0 else float("nan")
    outlier_rate = (len(outliers) / len(after_warm)) if after_warm else 0.0

    c1 = all(
        ("t_atlas_ms" in r)
        and (("t_xfer_out_ms" in r) or ("t_connect_ms" in r) or ("t_xfer_in_ms" in r))
        for r in steady
    ) if steady else False
    # C2: method flag from parent summary or row
    methods = {r.get("daemon") for r in rows}
    c2_daemon = True in methods or any(r.get("daemon") for r in rows)
    c2 = bool(c2_daemon)  # historical SSH would be false; caller can override
    c3 = (not math.isnan(ratio)) and ratio <= g_comm_ratio
    steady_ok = outlier_rate <= 0.05

    g_acc_ok = (not math.isnan(acc)) and acc >= g_acc
    g_lat_ok = (
        steady
        and (not math.isnan(p50))
        and (not math.isnan(p95))
        and p50 <= g_lat_p50
        and p95 <= g_lat_p95
        and steady_ok
    )
    g_comm_ok = c1 and c2 and c3 and steady_ok

    return {
        "schema": "phase4.1-spec-gate-v0",
        "n_total": n,
        "warmup": warmup,
        "outlier_ms": outlier_ms,
        "n_after_warmup": len(after_warm),
        "n_outliers": len(outliers),
        "outlier_rate": round(outlier_rate, 4),
        "n_steady": len(steady),
        "outlier_max_e2e_ms": max((float(r["t_e2e_ms"]) for r in outliers), default=None),
        "match_key": match_key,
        "G-ACC": {
            "value": None if math.isnan(acc) else round(acc, 4),
            "threshold": g_acc,
            "ok": g_acc_ok,
            "note": "match_key=ort_match 时为 vs ORT 金标准；否则为 vs 数据集标签",
        },
        "G-LAT": {
            "p50_ms": None if math.isnan(p50) else round(p50, 3),
            "p95_ms": None if math.isnan(p95) else round(p95, 3),
            "threshold_p50_ms": g_lat_p50,
            "threshold_p95_ms": g_lat_p95,
            "ok": g_lat_ok,
        },
        "G-COMM": {
            "C1_segments_present": c1,
            "C2_not_per_frame_ssh": c2,
            "C3_p95_over_p50": None if math.isnan(ratio) else round(ratio, 3),
            "C3_threshold": g_comm_ratio,
            "C3_ok": c3,
            "steady_outlier_rate_ok": steady_ok,
            "ok": g_comm_ok,
        },
        "overall_ok": bool(g_acc_ok and g_lat_ok and g_comm_ok),
    }


def main() -> int:
    ap = argparse.ArgumentParser(description="Phase4.1 spec gate report")
    ap.add_argument(
        "--bench",
        type=Path,
        default=ROOT / "runs" / "phase4_poc" / "distributed_bench_daemon_n100.json",
    )
    ap.add_argument("--warmup", type=int, default=5)
    ap.add_argument("--outlier-ms", type=float, default=100.0)
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "runs" / "phase4_poc" / "spec_gate_report_daemon_n100.json",
    )
    ap.add_argument("--gate", action="store_true", help="overall_ok 才 exit 0")
    args = ap.parse_args()

    doc = json.loads(args.bench.read_text(encoding="utf-8"))
    rows = doc.get("per_sample") or []
    if not rows:
        raise SystemExit(f"no per_sample in {args.bench}")

    # Prefer ORT match if present
    match_key = "ort_match" if any("ort_match" in r for r in rows) else "pred_match"
    report = evaluate(rows, warmup=args.warmup, outlier_ms=args.outlier_ms, match_key=match_key)
    report["source_bench"] = str(args.bench)
    report["source_summary"] = {
        k: doc.get("summary", {}).get(k)
        for k in ("p50_t_e2e_ms", "p95_t_e2e_ms", "avg_t_e2e_ms", "pred_match_rate", "mode")
    }
    report["generated_at"] = datetime.now(timezone.utc).astimezone().isoformat()
    report["agent"] = "ChenZhengGong"

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    print(f"wrote {args.out}", file=__import__("sys").stderr)

    if args.gate:
        return 0 if report["overall_ok"] else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
