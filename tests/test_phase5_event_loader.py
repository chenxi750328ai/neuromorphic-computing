"""P5-1 event loader unit tests (no board)."""
from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from phase5_event_loader import mnist_to_rate_spikes  # noqa: E402


def test_rate_spikes_shape_and_bounds():
    imgs = np.full((4, 28, 28), 0.5, dtype=np.float32)
    spikes = mnist_to_rate_spikes(imgs, T=5, seed=1)
    assert spikes.shape == (4, 5, 28, 28)
    assert spikes.dtype == np.uint8
    assert set(np.unique(spikes)).issubset({0, 1})
    assert 0.0 < float(spikes.mean()) < 1.0


def test_blank_near_zero_rate():
    imgs = np.zeros((2, 28, 28), dtype=np.float32)
    spikes = mnist_to_rate_spikes(imgs, T=8, seed=0)
    assert float(spikes.mean()) == 0.0
