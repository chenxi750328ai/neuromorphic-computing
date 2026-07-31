#!/usr/bin/env python3
"""F6 S2 · 迁移评估落盘门禁（陈正共）— 只验文档完备，不验买板。"""
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs" / "FPGA_S2_开源友好器件迁移评估_V0.md"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_s2_migration_eval_gate.json"
REQUIRED = [
    "开源友好器件",
    "ECP5",
    "PYNQ-Z2",
    "Vivado",
    "触发条件",
    "非目标",
]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    text = DOC.read_text(encoding="utf-8") if DOC.is_file() else ""
    missing = [k for k in REQUIRED if k not in text]
    ok = DOC.is_file() and not missing
    report = {
        "schema": "phase4.1-fpga-s2-migration-eval-gate-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "doc": str(DOC.relative_to(ROOT)) if DOC.is_file() else None,
        "missing_markers": missing,
        "pass": ok,
        "note": "评估门禁；PoC/采购须总裁硬主权触发",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("PASS" if ok else "FAIL", "phase4_fpga_s2_migration_eval_gate")
    if missing:
        print("  missing:", ", ".join(missing))
    print(f"wrote {args.out}")
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
