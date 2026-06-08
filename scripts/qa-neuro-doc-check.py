#!/usr/bin/env python3
"""检查类脑项目关键文档与 IPD 裁剪附件是否存在。"""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "docs/requirements_v1.md",
    "docs/TR1_评审材料清单.md",
    "docs/会议纪要_TR1总裁拍板_20260528.md",
    "docs/每日计划.md",
    "docs/项目看板.md",
    "docs/IPD-QA流程裁剪_待VP总裁批准.md",
    "CONTRIBUTING.md",
    "config/neuro-qa-gate-baseline.json",
]

RECOMMENDED = [
    "docs/phase2_snn_vs_ann.md",
    "docs/QA_验收记录_Phase1-3.md",
]


def main() -> int:
    missing = [p for p in REQUIRED if not (ROOT / p).is_file()]
    if missing:
        for p in missing:
            print(f"FAIL missing {p}", file=sys.stderr)
        return 1

    warn = [p for p in RECOMMENDED if not (ROOT / p).is_file()]
    for p in warn:
        print(f"WARN missing {p}", file=sys.stderr)

    print(f"PASS {len(REQUIRED)} required docs ok")
    return 2 if warn else 0


if __name__ == "__main__":
    raise SystemExit(main())
