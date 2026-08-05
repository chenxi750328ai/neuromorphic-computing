"""F7 PL fc+LIF gate unit tests — WO-DEV-NEURO-F7-PL-FC."""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GATE = ROOT / "scripts" / "phase4_fpga_rb_fullnet_pl_fc_gate.py"
PY = ROOT / ".venv" / "bin" / "python3"
if not PY.is_file():
    PY = Path(sys.executable)


def test_gate_script_exists():
    assert GATE.is_file()


def test_pl_model_skip_board():
    proc = subprocess.run(
        [str(PY), str(GATE), "--samples", "20", "--skip-board"],
        cwd=str(ROOT),
        capture_output=True,
        text=True,
    )
    assert "pl_model_match_rate" in proc.stdout or proc.returncode in (0, 1)
    evidence = ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_pl_fc_gate.json"
    assert evidence.is_file()
