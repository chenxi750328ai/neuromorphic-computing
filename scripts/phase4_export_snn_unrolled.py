#!/usr/bin/env python3
"""Phase4 · 展开 LIF 时间步导出真 SNN ONNX（绕过 snnTorch trace 限制）。"""
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
from train_mnist_snn import MnistSNN, loaders, evaluate  # noqa: E402


class MnistSNNUnrolled(nn.Module):
    """与 snnTorch Leaky(subtract reset) 推理行为对齐的展开图。"""

    def __init__(self, src: MnistSNN, timesteps: int, beta: float = 0.9, threshold: float = 1.0) -> None:
        super().__init__()
        self.timesteps = timesteps
        self.register_buffer("beta", torch.tensor(beta))
        self.register_buffer("threshold", torch.tensor(threshold))
        self.fc1 = src.fc1
        self.fc2 = src.fc2

    def lif_step(self, cur: torch.Tensor, mem: torch.Tensor) -> tuple[torch.Tensor, torch.Tensor]:
        reset = (mem >= self.threshold).to(cur.dtype)
        mem = self.beta * mem + cur - reset * self.threshold
        spk = (mem >= self.threshold).to(cur.dtype)
        return spk, mem

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = x.view(x.size(0), -1)
        mem1 = torch.zeros(x.size(0), self.fc1.out_features, device=x.device, dtype=x.dtype)
        mem2 = torch.zeros(x.size(0), self.fc2.out_features, device=x.device, dtype=x.dtype)
        spk_sum = torch.zeros(x.size(0), self.fc2.out_features, device=x.device, dtype=x.dtype)
        for _ in range(self.timesteps):
            spk1, mem1 = self.lif_step(self.fc1(x), mem1)
            spk2, mem2 = self.lif_step(self.fc2(spk1), mem2)
            spk_sum = spk_sum + spk2
        return spk_sum


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


@torch.no_grad()
def max_abs_diff(a: torch.Tensor, b: torch.Tensor) -> float:
    return (a - b).abs().max().item()


@torch.no_grad()
def evaluate_unrolled(net: MnistSNNUnrolled, loader, device: torch.device) -> tuple[float, int, int]:
    net.eval()
    correct = 0
    total = 0
    for data, target in loader:
        data, target = data.to(device), target.to(device)
        pred = net(data).argmax(dim=1)
        correct += (pred == target).sum().item()
        total += target.size(0)
    return correct / max(total, 1), correct, total


def main() -> int:
    p = argparse.ArgumentParser(description="Export unrolled MNIST SNN to ONNX")
    p.add_argument("--checkpoint", type=Path, required=True)
    p.add_argument("--out-dir", type=Path, default=ROOT / "runs" / "phase4_export")
    p.add_argument("--timesteps", type=int, default=25)
    p.add_argument("--opset", type=int, default=11)
    p.add_argument("--verify-samples", type=int, default=32)
    args = p.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=True)

    onnx_path = args.out_dir / "model_snn.onnx"
    manifest_path = args.out_dir / "snn_manifest.json"
    notes_path = args.out_dir / "snn_onboard_log.md"

    try:
        import onnx  # noqa: F401
        import onnxruntime as ort
    except ImportError as exc:
        manifest = {
            "ts": datetime.now(timezone.utc).isoformat(),
            "status": "failed",
            "error": f"missing package: {exc}",
        }
        manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"need onnx + onnxruntime: {exc}", file=sys.stderr)
        return 2

    device = torch.device("cpu")
    ref = MnistSNN().to(device).eval()
    ckpt = torch.load(args.checkpoint, map_location=device, weights_only=False)
    state = ckpt.get("model") or ckpt.get("state_dict") or ckpt
    ref.load_state_dict(state)

    model = MnistSNNUnrolled(ref, args.timesteps).eval()
    dummy = torch.randn(1, 1, 28, 28, device=device)

    with torch.no_grad():
        ref_out = ref(dummy, args.timesteps).sum(dim=0)
        exp_out = model(dummy)
        pt_diff = max_abs_diff(ref_out, exp_out)

    _, test_loader = loaders(ROOT / "data" / "mnist", batch_size=128)
    acc_ref, _, _ = evaluate(ref, test_loader, device, args.timesteps)
    acc_exp, _, _ = evaluate_unrolled(model, test_loader, device)

    torch.onnx.export(
        model,
        dummy,
        str(onnx_path),
        input_names=["input"],
        output_names=["spike_counts"],
        dynamic_axes={"input": {0: "batch"}, "spike_counts": {0: "batch"}},
        opset_version=args.opset,
    )

    sess = ort.InferenceSession(str(onnx_path), providers=["CPUExecutionProvider"])
    batch = next(iter(test_loader))[0][: args.verify_samples].to(device)
    ort_out = sess.run(None, {"input": batch.numpy()})[0]
    pt_batch = model(batch).numpy()
    ort_diff = float(abs(ort_out - pt_batch).max())
    ort_pred = ort_out.argmax(axis=1)
    pt_pred = pt_batch.argmax(axis=1)
    match = float((ort_pred == pt_pred).mean())

    manifest = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "checkpoint": str(args.checkpoint.resolve()),
        "path": "snn_unrolled",
        "timesteps": args.timesteps,
        "opset": args.opset,
        "status": "ok",
        "onnx": str(onnx_path),
        "sha256": sha256_file(onnx_path),
        "verify": {
            "pt_vs_ref_max_diff": pt_diff,
            "test_acc_ref": round(acc_ref, 6),
            "test_acc_unrolled": round(acc_exp, 6),
            "ort_vs_pt_max_diff": ort_diff,
            "ort_pred_match_rate": match,
        },
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    notes = notes_path.read_text(encoding="utf-8") if notes_path.is_file() else "# Phase4 · SNN 上板问题记录\n\n"
    notes += (
        f"\n## {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M')} UTC · 展开导出\n\n"
        f"- **问题**：snnTorch `Leaky` 含状态/自定义 autograd，无法 `torch.onnx.export` 直导\n"
        f"- **解法**：`MnistSNNUnrolled` 将 {args.timesteps} 步 LIF 展开为纯 Tensor 算子（subtract reset）\n"
        f"- **对齐**：单 batch max diff={pt_diff:.6f}；test acc ref={acc_ref:.4f} unrolled={acc_exp:.4f}\n"
        f"- **ORT**：max diff={ort_diff:.6f}；pred match={match:.2%}\n"
        f"- **产物**：`{onnx_path.name}` opset={args.opset}\n"
    )
    notes_path.write_text(notes, encoding="utf-8")

    print(f"exported: {onnx_path}")
    print(f"acc ref={acc_ref:.4f} unrolled={acc_exp:.4f} pt_diff={pt_diff:.6f} ort_diff={ort_diff:.6f}")
    return 0 if acc_exp >= 0.96 and match >= 0.99 else 1


if __name__ == "__main__":
    raise SystemExit(main())
