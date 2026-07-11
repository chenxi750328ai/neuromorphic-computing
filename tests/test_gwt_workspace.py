"""Tests for GWT workspace bus."""
from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(SCRIPTS))

from gwt_workspace import Workspace, WriteCandidate  # noqa: E402


def test_merge_respects_k_active():
    ws = Workspace(K=8, D=16, k_active=3)
    cands = [
        WriteCandidate("M1", np.ones(16, dtype=np.float32), score=1.0),
        WriteCandidate("M2", np.ones(16, dtype=np.float32) * 0.5, score=0.9),
        WriteCandidate("M3", np.ones(16, dtype=np.float32) * 0.3, score=0.8),
        WriteCandidate("M4", np.ones(16, dtype=np.float32) * 0.2, score=0.7),
    ]
    logs = ws.merge(cands)
    assert len(logs) == 3
    assert ws.active_count() == 3
    assert ws.tick == 1


def test_snapshot_is_copy():
    ws = Workspace(K=4, D=8, k_active=2)
    snap = ws.snapshot()
    snap.W[0, 0] = 999.0
    assert ws.W[0, 0] != 999.0


def test_broadcast_read_only():
    ws = Workspace(K=4, D=8, k_active=2)
    ws.merge([WriteCandidate("M1", np.arange(8, dtype=np.float32), 1.0)])
    snap = ws.snapshot()
    assert snap.active_count() == 1
    assert snap.tick == 1
