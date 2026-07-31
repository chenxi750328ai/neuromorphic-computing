#!/usr/bin/env python3
"""Phase4.1 F4 双通 · 证据机读门禁（防假绿）— 陈正共.

只校验已落盘 JSON 是否满足双通判据与延迟披露字段；不重跑板上。
可选 --require-ci-note 检查 QA 记录存在。
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
A2 = ROOT / "docs" / "phase4_poc_evidence" / "fpga_ra_atlas_mlif_inchain_gate.json"
B1 = ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_runthrough_gate.json"
QA = ROOT / "docs" / "QA_验收记录_Phase4.1_FPGA双通.md"


def check_one(path: Path, verdict_key: str, expect_prefix: str) -> list[str]:
    errs: list[str] = []
    if not path.is_file():
        return [f"MISSING {path}"]
    d = json.loads(path.read_text(encoding="utf-8"))
    v = str(d.get("verdict") or "")
    if not v.startswith(expect_prefix) and expect_prefix not in v:
        # accept exact PASS_* 
        if not v.startswith("PASS"):
            errs.append(f"{path.name}: verdict not PASS ({v})")
    cmp_ = d.get("compare") or {}
    mr = float(cmp_.get("pred_match_rate") or 0)
    if mr < 0.98:
        errs.append(f"{path.name}: pred_match_rate {mr} < 0.98")
    body = d.get("atlas_client") or d.get("board") or {}
    n = int(body.get("n") or 0)
    if n < 20:
        errs.append(f"{path.name}: n={n} < 20")
    acc = float(body.get("acc_vs_label") or 0)
    if acc < 0.90:
        errs.append(f"{path.name}: acc_vs_label {acc} < 0.90")
    # latency disclosure: must have some avg_*_ms
    lat_keys = [k for k in body if k.startswith("avg_") and k.endswith("_ms")]
    if not lat_keys:
        errs.append(f"{path.name}: missing avg_*_ms latency disclosure")
    if not bool(d.get(verdict_key) or v.startswith("PASS")):
        errs.append(f"{path.name}: platform flag/verdict inconsistent")
    return errs


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()
    errs: list[str] = []
    errs += check_one(A2, "platform_runthrough_ra_atlas_fpga", "PASS_ra")
    errs += check_one(B1, "platform_runthrough_rb_tmd", "PASS_rb")
    if not QA.is_file():
        errs.append(f"MISSING QA record {QA}")
    else:
        text = QA.read_text(encoding="utf-8")
        for needle in ("远逊 G-LAT", "MMIO", "fpga_ra_atlas_mlif_inchain_gate.json", "fpga_rb_fullnet_runthrough_gate.json"):
            if needle not in text:
                errs.append(f"QA record missing disclosure/path: {needle}")
    if errs:
        print("FAIL")
        for e in errs:
            print(" -", e)
        return 1 if args.gate else 0
    print("PASS phase4_fpga_both_runthrough_evidence_gate")
    print(f"A2={A2}")
    print(f"B1={B1}")
    print(f"QA={QA}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
