#!/usr/bin/env python3
"""Phase4 兜底：速率编码 ANN 近似导出 ONNX（不依赖 snnTorch LIF）。"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

import torch
import torch.nn as nn

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from train_mnist_snn import MnistSNN  # noqa: E402


class RateAnnSurrogate(nn.Module):
    """用 SNN 全连接权重做 2 层 ReLU MLP 近似（PoC 导出路径 B）。"""

    def __init__(self, snn: MnistSNN) -> None:
        super().__init__()
        self.fc1 = nn.Linear(snn.fc1.in_features, snn.fc1.out_features)
        self.fc2 = nn.Linear(snn.fc2.in_features, snn.fc2.out_features)
        self.fc1.weight.data.copy_(snn.fc1.weight.data)
        self.fc1.bias.data.copy_(snn.fc1.bias.data)
        self.fc2.weight.data.copy_(snn.fc2.weight.data)
        self.fc2.bias.data.copy_(snn.fc2.bias.data)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = x.view(x.size(0), -1)
        x = torch.relu(self.fc1(x))
        return self.fc2(x)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--checkpoint", type=Path, required=True)
    p.add_argument("--out-dir", type=Path, default=ROOT / "runs" / "phase4_export")
    args = p.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    onnx_path = args.out_dir / "model_ann_surrogate.onnx"

    snn = MnistSNN()
    ckpt = torch.load(args.checkpoint, map_location="cpu", weights_only=False)
    state = ckpt.get("model") or ckpt.get("state_dict") or ckpt
    snn.load_state_dict(state)
    model = RateAnnSurrogate(snn).eval()

    try:
        import onnx  # noqa: F401
    except ImportError:
        manifest = {
            "ts": datetime.now(timezone.utc).isoformat(),
            "path": "ann_surrogate",
            "status": "failed",
            "error": "onnx not installed",
        }
        (args.out_dir / "surrogate_manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
        print("onnx not installed", file=sys.stderr)
        return 2

    dummy = torch.randn(1, 1, 28, 28)
    torch.onnx.export(
        model,
        dummy,
        str(onnx_path),
        input_names=["input"],
        output_names=["logits"],
        dynamic_axes={"input": {0: "batch"}, "logits": {0: "batch"}},
        opset_version=17,
    )
    manifest = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "checkpoint": str(args.checkpoint.resolve()),
        "path": "ann_surrogate",
        "status": "ok",
        "onnx": str(onnx_path),
        "sha256": sha256_file(onnx_path),
        "note": "非 bit-exact SNN；Atlas PoC 可用此 IR",
    }
    (args.out_dir / "surrogate_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"exported: {onnx_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
