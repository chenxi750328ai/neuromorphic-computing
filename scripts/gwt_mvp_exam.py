#!/usr/bin/env python3
"""GWT-MVP exam gates GWT-1 / GWT-2 (Phase6 · 陈正共)."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from gwt.modules.m1_perception import M1Perception  # noqa: E402
from gwt.modules.m2_association import M2Association  # noqa: E402
from gwt.modules.m3_executive import M3Executive  # noqa: E402
from gwt.modules.m4_output import M4Output  # noqa: E402
from gwt_workspace import Workspace, run_global_tick  # noqa: E402


def _sample_input(seed: int = 42) -> np.ndarray:
    rng = np.random.default_rng(seed)
    return rng.standard_normal(28 * 28).astype(np.float32)


def run_stage1(*, gate: bool) -> dict:
    """GWT-1: M1 → workspace → M4 one tick."""
    ws = Workspace()
    m1 = M1Perception()
    m4 = M4Output()
    sensory = _sample_input()

    _, cand = m1.local_step(sensory, ws.snapshot())
    assert cand is not None
    logs = ws.merge([cand])
    snap = ws.snapshot()
    emit = m4.read_emit(snap)

    ok = ws.tick == 1 and len(logs) == 1 and logs[0].module_id == "M1" and emit.confidence >= 0.0
    result = {
        "stage": 1,
        "ok": ok,
        "tick": ws.tick,
        "writes": len(logs),
        "emit_class": emit.class_id,
        "emit_confidence": emit.confidence,
    }
    if gate and not ok:
        raise SystemExit(1)
    return result


def run_stage2(*, gate: bool, workspace_doc: Path | None, ticks: int = 8) -> dict:
    """GWT-2: M1–M4 compete · broadcast · T>=8."""
    if workspace_doc is not None and not workspace_doc.is_file():
        raise SystemExit(f"workspace doc missing: {workspace_doc}")

    ws = Workspace()
    modules = [M1Perception(), M2Association(), M3Executive(), M4Output()]
    m4 = M4Output()
    sensory = _sample_input(seed=7)
    log_dir = ROOT / "runs" / "gwt" / "mvp_stage2"

    all_logs = []
    for _ in range(ticks):
        _, logs = run_global_tick(modules, ws, sensory, log_dir=log_dir if gate else None)
        all_logs.extend(logs)

    snap = ws.snapshot()
    emit = m4.read_emit(snap)
    module_ids = {e.module_id for e in all_logs}

    ok = (
        ws.tick == ticks
        and 1 <= ws.active_count() <= ws.K
        and len(module_ids) >= 2
        and "M1" in module_ids
        and emit.confidence > 0.0
    )

    result = {
        "stage": 2,
        "ok": ok,
        "ticks": ticks,
        "workspace_tick": ws.tick,
        "active_slots": ws.active_count(),
        "modules_written": sorted(module_ids),
        "total_writes": len(all_logs),
        "emit_class": emit.class_id,
        "emit_confidence": emit.confidence,
        "workspace_doc": str(workspace_doc) if workspace_doc else None,
    }
    if gate and not ok:
        raise SystemExit(1)
    return result


def main() -> int:
    p = argparse.ArgumentParser(description="GWT MVP exam (陈正共)")
    p.add_argument("--stage", type=int, choices=[1, 2], required=True)
    p.add_argument("--gate", action="store_true", help="exit 1 on FAIL")
    p.add_argument("--workspace-doc", type=Path, default=None)
    p.add_argument("--ticks", type=int, default=8)
    p.add_argument("--json", action="store_true")
    args = p.parse_args()

    if args.stage == 1:
        result = run_stage1(gate=args.gate)
    else:
        doc = args.workspace_doc or ROOT / "docs" / "GWT_工作区协议_V0.md"
        result = run_stage2(gate=args.gate, workspace_doc=doc, ticks=args.ticks)

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        status = "PASS" if result["ok"] else "FAIL"
        print(f"GWT stage {result['stage']}: {status}")
        for k, v in result.items():
            if k not in ("stage", "ok"):
                print(f"  {k}: {v}")

    return 0 if result["ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
