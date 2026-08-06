#!/usr/bin/env python3
"""GWT-0 机读门禁：协议默认值 ↔ gwt_workspace 常量对齐（仿真轨 · 不依板）。

GWT-0-a（PL/总裁签字）仍为人审；本脚本覆盖 GWT-0-b/c 可机检部分。
陈正共 · ChenZhengGong
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
sys.path.insert(0, str(SCRIPTS))

from gwt_workspace import DEFAULT_D, DEFAULT_K, DEFAULT_K_ACTIVE, PROTO_VERSION, Workspace  # noqa: E402

DOC = ROOT / "docs" / "GWT_工作区协议_V0.md"
OUT = ROOT / "runs" / "gwt" / "gwt0_protocol_gate.json"


def _doc_defaults(text: str) -> dict[str, int | None]:
    def grab(pat: str) -> int | None:
        m = re.search(pat, text)
        return int(m.group(1)) if m else None

    return {
        "K": grab(r"K\s*=\s*(\d+)"),
        "k_active": grab(r"k_active\s*=\s*(\d+)"),
        "D": grab(r"D\s*=\s*(\d+)"),
    }


def compete_write_smoke() -> dict:
    ws = Workspace()
    from gwt_workspace import WriteCandidate
    import numpy as np

    cands = [
        WriteCandidate("M1", np.ones(DEFAULT_D, dtype=np.float32), 0.9),
        WriteCandidate("M2", np.ones(DEFAULT_D, dtype=np.float32) * 0.5, 0.5),
        WriteCandidate("M3", np.ones(DEFAULT_D, dtype=np.float32) * 0.1, 0.1),
    ]
    # flood with > k_active
    for i in range(12):
        cands.append(WriteCandidate(f"X{i}", np.random.randn(DEFAULT_D).astype(np.float32), 0.01 * i))
    logs = ws.merge(cands)
    snap = ws.snapshot()
    ok = (
        ws.tick == 1
        and 1 <= ws.active_count() <= DEFAULT_K_ACTIVE
        and len(logs) <= DEFAULT_K_ACTIVE
        and snap.K == DEFAULT_K
        and snap.D == DEFAULT_D
    )
    return {"ok": ok, "tick": ws.tick, "active": ws.active_count(), "writes": len(logs)}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gate", action="store_true")
    ap.add_argument("--out", default=str(OUT))
    args = ap.parse_args()

    doc_text = DOC.read_text(encoding="utf-8") if DOC.is_file() else ""
    doc_def = _doc_defaults(doc_text)
    align = {
        "K": doc_def["K"] == DEFAULT_K,
        "k_active": doc_def["k_active"] == DEFAULT_K_ACTIVE,
        "D": doc_def["D"] == DEFAULT_D,
    }
    compete = compete_write_smoke()
    ok = DOC.is_file() and all(align.values()) and compete["ok"] and PROTO_VERSION == 0

    result = {
        "schema": "gwt0-protocol-gate-v1",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ag-chenzhenggong",
        "ok": ok,
        "doc": str(DOC.relative_to(ROOT)),
        "code_defaults": {"K": DEFAULT_K, "k_active": DEFAULT_K_ACTIVE, "D": DEFAULT_D, "version": PROTO_VERSION},
        "doc_defaults": doc_def,
        "align": align,
        "compete_write": compete,
        "human_pending": ["GWT-0-a PL+总裁批注「按 V0 开 GWT-1 仿真」"],
        "board_independent": True,
    }
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"ok": ok, "align": align, "compete": compete["ok"], "out": str(out)}, ensure_ascii=False))
    if args.gate and not ok:
        return 1
    return 0 if ok else (1 if args.gate else 0)


if __name__ == "__main__":
    raise SystemExit(main())
