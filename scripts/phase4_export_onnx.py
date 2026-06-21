#!/usr/bin/env python3
"""Phase4 · 尝试将 MNIST SNN checkpoint 导出为 ONNX（陈正共）。"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

import torch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from train_mnist_snn import MnistSNN  # noqa: E402


class MnistSNNOnnx(torch.nn.Module):
    """固定 timesteps 展开，便于 ONNX trace。"""

    def __init__(self, net: MnistSNN, timesteps: int) -> None:
        super().__init__()
        self.net = net
        self.timesteps = timesteps

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        spk = self.net(x, self.timesteps)
        return spk.sum(dim=0)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    p = argparse.ArgumentParser(description="Export MNIST SNN to ONNX")
    p.add_argument("--checkpoint", type=Path, required=True)
    p.add_argument("--out-dir", type=Path, default=ROOT / "runs" / "phase4_export")
    p.add_argument("--timesteps", type=int, default=10)
    p.add_argument("--opset", type=int, default=17)
    args = p.parse_args()

    args.out_dir.mkdir(parents=True, exist_ok=True)
    onnx_path = args.out_dir / "model.onnx"
    notes_path = args.out_dir / "export_notes.md"
    manifest_path = args.out_dir / "export_manifest.json"

    device = torch.device("cpu")
    net = MnistSNN().to(device)
    ckpt = torch.load(args.checkpoint, map_location=device, weights_only=False)
    state = ckpt.get("model") or ckpt.get("state_dict") or ckpt
    net.load_state_dict(state)
    net.eval()
    wrapper = MnistSNNOnnx(net, args.timesteps).eval()

    dummy = torch.randn(1, 1, 28, 28, device=device)
    status = "ok"
    error = ""
    try:
        torch.onnx.export(
            wrapper,
            dummy,
            str(onnx_path),
            input_names=["input"],
            output_names=["logits"],
            dynamic_axes={"input": {0: "batch"}, "logits": {0: "batch"}},
            opset_version=args.opset,
        )
    except Exception as exc:  # snnTorch LIF 常无法直接导出
        status = "failed"
        error = str(exc)
        notes_path.write_text(
            f"# Phase4 ONNX 导出说明\n\n"
            f"- 时间：{datetime.now(timezone.utc).isoformat()}\n"
            f"- checkpoint：`{args.checkpoint}`\n"
            f"- 结果：**失败**（预期内：snnTorch LIF 算子 ONNX 覆盖有限）\n"
            f"- 错误：`{error}`\n\n"
            f"## 下一步\n"
            f"1. CPU 对照：保持 4090 eval-only 为 S1 PASS\n"
            f"2. Atlas：评估 OM 自定义算子或速率编码 ANN 近似路径（见 TR2 草案 §4）\n",
            encoding="utf-8",
        )

    manifest = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "checkpoint": str(args.checkpoint.resolve()),
        "timesteps": args.timesteps,
        "opset": args.opset,
        "status": status,
        "onnx": str(onnx_path) if onnx_path.is_file() else None,
        "sha256": sha256_file(onnx_path) if onnx_path.is_file() else None,
        "error": error or None,
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    if status == "ok":
        print(f"exported: {onnx_path}")
        return 0
    print(f"export failed (notes): {notes_path}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
