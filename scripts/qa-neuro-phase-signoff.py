#!/usr/bin/env python3
"""Phase 合并前 QA 验收签字检查（研究轨 · VP PASS）。"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QA_RECORD = ROOT / "docs" / "QA_验收记录_Phase1-3.md"


def _signoff_block(text: str) -> str:
    m = re.search(r"```signoff\s*(.*?)```", text, re.S)
    return m.group(1) if m else ""


def check_signoff() -> int:
    if not QA_RECORD.is_file():
        print(f"FAIL missing {QA_RECORD.relative_to(ROOT)}", file=sys.stderr)
        return 1
    block = _signoff_block(QA_RECORD.read_text(encoding="utf-8"))
    if not block:
        print("FAIL signoff block missing in QA record", file=sys.stderr)
        return 1
    if not re.search(r"^VP_QA:\s*PASS\s*$", block, re.M):
        print("FAIL VP_QA: PASS not set (await VP signoff)", file=sys.stderr)
        return 1
    if not re.search(r"^PRESIDENT:\s*APPROVED\s*$", block, re.M):
        print("WARN PRESIDENT: APPROVED not set (await president)", file=sys.stderr)
        return 2
    print("PASS VP and president signoff")
    return 0


def check_metrics() -> int:
    if not QA_RECORD.is_file():
        return 1
    text = QA_RECORD.read_text(encoding="utf-8")
    for phase, acc in [("Phase1", "96.97"), ("Phase2", "98.10")]:
        if acc not in text:
            print(f"WARN {phase} metric {acc}% not in QA record", file=sys.stderr)
            return 2
    print("PASS phase metrics referenced in QA record")
    return 0


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--check", action="store_true", help="VP QA PASS in signoff block")
    p.add_argument("--metrics", action="store_true", help="phase metrics archived")
    args = p.parse_args()
    if args.metrics:
        return check_metrics()
    return check_signoff()


if __name__ == "__main__":
    raise SystemExit(main())
