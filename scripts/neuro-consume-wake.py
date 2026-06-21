#!/usr/bin/env python3
"""收工：标记 .neuro-brain-wake 已消费并归档。"""
from __future__ import annotations

import json
import os
from datetime import datetime, timezone
from pathlib import Path

NEURO = Path(os.environ.get("NEUROMORPHIC_ROOT", Path(__file__).resolve().parents[1])).resolve()
WAKE = NEURO / ".neuro-brain-wake"


def main() -> int:
    if not WAKE.is_file():
        print("no wake")
        return 0
    wake = json.loads(WAKE.read_text(encoding="utf-8"))
    wake.setdefault("cursor", {})
    wake["cursor"]["consumed"] = True
    wake["cursor"]["consumed_at"] = datetime.now(timezone.utc).astimezone().isoformat()
    wake["cursor"]["consumed_by"] = "neuro-consume-wake"
    done = NEURO / "data" / ".neuro-brain-wake.done.jsonl"
    done.parent.mkdir(parents=True, exist_ok=True)
    with done.open("a", encoding="utf-8") as f:
        f.write(json.dumps(wake, ensure_ascii=False) + "\n")
    WAKE.unlink()
    try:
        import importlib.util

        spec = importlib.util.spec_from_file_location(
            "neuro_dashboard_sync", NEURO / "scripts" / "neuro-dashboard-sync.py"
        )
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        mod.sync_dashboard({})
    except Exception:
        pass
    print("wake consumed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
