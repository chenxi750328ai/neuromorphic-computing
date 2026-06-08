"""冒烟：模型前向，不下载 MNIST。"""
from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

import torch

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"


def _load_module(name: str, filename: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / filename)
    mod = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(mod)
    return mod


class TestModelSmoke(unittest.TestCase):
    def test_snn_forward(self) -> None:
        mod = _load_module("train_mnist_snn", "train_mnist_snn.py")
        net = mod.MnistSNN(hidden=64)
        x = torch.randn(4, 1, 28, 28)
        out = net(x, timesteps=4)
        self.assertEqual(out.shape, (4, 4, 10))

    def test_ann_forward(self) -> None:
        mod = _load_module("train_mnist_ann", "train_mnist_ann.py")
        net = mod.MnistMLP(hidden=64)
        x = torch.randn(4, 1, 28, 28)
        out = net(x)
        self.assertEqual(out.shape, (4, 10))


if __name__ == "__main__":
    unittest.main()
