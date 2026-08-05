"""Phase4.2 F7 · fullnet_tick_scheduler Verilator 仿真骨架单测（离线 · 不依赖板）."""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path


def test_tick_scheduler_verilator_build_and_run() -> None:
    root = Path(__file__).resolve().parents[1]
    sim_dir = root / "fpga" / "sim"
    makefile = sim_dir / "Makefile.tick_scheduler"
    if not makefile.is_file():
        return
    proc = subprocess.run(
        ["make", "-f", "Makefile.tick_scheduler", "run"],
        cwd=sim_dir,
        capture_output=True,
        text=True,
        timeout=120,
    )
    assert proc.returncode == 0, f"verilator sim failed:\n{proc.stdout}\n{proc.stderr}"
    assert "TICK_SCHED_SIM ok" in proc.stdout


def test_tick_scheduler_rtl_exists() -> None:
    rtl = Path(__file__).resolve().parents[1] / "fpga" / "rtl" / "fullnet_tick_scheduler.v"
    assert rtl.is_file()
    text = rtl.read_text(encoding="utf-8")
    assert "fullnet_tick_scheduler" in text
    assert "ST_FC1" in text
    assert "TIMESTEPS" in text
