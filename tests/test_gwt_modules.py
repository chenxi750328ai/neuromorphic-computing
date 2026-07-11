"""Tests for GWT module stubs."""
from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(SCRIPTS))

from gwt.modules.m1_perception import M1Perception  # noqa: E402
from gwt.modules.m2_association import M2Association  # noqa: E402
from gwt.modules.m3_executive import M3Executive  # noqa: E402
from gwt.modules.m4_output import M4Output  # noqa: E402
from gwt_workspace import Workspace, run_global_tick  # noqa: E402


def test_m1_produces_candidate():
    m1 = M1Perception(d=32)
    ws = Workspace(K=8, D=32, k_active=4)
    _, cand = m1.local_step(np.zeros(28 * 28, dtype=np.float32), ws.snapshot())
    assert cand is not None
    assert cand.module_id == "M1"


def test_stage1_pipeline():
    ws = Workspace(K=8, D=32, k_active=4)
    m1 = M1Perception(d=32)
    m4 = M4Output(d=32)
    _, cand = m1.local_step(np.ones(28 * 28, dtype=np.float32), ws.snapshot())
    ws.merge([cand])
    emit = m4.read_emit(ws.snapshot())
    assert emit.class_id >= 0


def test_global_tick_multi_module():
    ws = Workspace(K=16, D=32, k_active=8)
    modules = [M1Perception(d=32), M2Association(d=32), M3Executive(d=32), M4Output(d=32)]
    for _ in range(8):
        run_global_tick(modules, ws, np.random.randn(784).astype(np.float32))
    assert ws.tick == 8
    assert ws.active_count() >= 1
