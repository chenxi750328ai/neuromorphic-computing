#!/usr/bin/env python3
"""小脑 tick 后：若有未消费 wake，向 stdout 打 AGENT_LOOP_TICK_NEURO（供 Cursor /loop 监听）。"""
from __future__ import annotations

import json
import sys
from pathlib import Path

WAKE = Path(__file__).resolve().parents[1] / ".neuro-brain-wake"
SENTINEL = "AGENT_LOOP_TICK_NEURO"


def main() -> int:
    if not WAKE.is_file():
        return 0
    try:
        wake = json.loads(WAKE.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return 1
    if wake.get("cursor", {}).get("consumed"):
        return 0
    instruction = (wake.get("instruction") or "").strip()
    if not instruction:
        return 0
    payload = json.dumps({"prompt": instruction}, ensure_ascii=False)
    print(f"{SENTINEL} {payload}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
