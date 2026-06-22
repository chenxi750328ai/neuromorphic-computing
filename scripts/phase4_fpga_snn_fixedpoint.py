#!/usr/bin/env python3
"""Phase4 path B · fixed-point unrolled MNIST SNN (FPGA reference model).

Q16.16 activations/weights; int64 accumulators. Compare vs float unrolled PyTorch.
"""
from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

import numpy as np
import torch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from phase4_export_snn_unrolled import MnistSNNUnrolled  # noqa: E402
from train_mnist_snn import MnistSNN, loaders  # noqa: E402

FRAC = 16
SCALE = 1 << FRAC
BETA_FP = int(round(0.9 * SCALE))
TH_FP = int(round(1.0 * SCALE))


def to_fp(arr: np.ndarray) -> np.ndarray:
    return np.round(arr.astype(np.float64) * SCALE).astype(np.int64)


def linear_fp(x_fp: np.ndarray, w_fp: np.ndarray, b_fp: np.ndarray) -> np.ndarray:
    """x: (in,), w: (out, in), b: (out,) -> (out,) Q16.16"""
    acc = w_fp.astype(np.int64) @ x_fp.astype(np.int64)
    return (acc >> FRAC) + b_fp


def lif_step_fp(cur_fp: np.ndarray, mem_fp: np.ndarray) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    reset = (mem_fp >= TH_FP).astype(np.int64)
    mem_fp = ((BETA_FP * mem_fp) >> FRAC) + cur_fp - reset * TH_FP
    spk_bit = (mem_fp >= TH_FP).astype(np.int64)
    spk_scaled = spk_bit * SCALE  # 1.0 in Q16.16 for downstream linear
    return spk_scaled, spk_bit, mem_fp


@dataclass
class FixedPointSNN:
    w1_fp: np.ndarray
    b1_fp: np.ndarray
    w2_fp: np.ndarray
    b2_fp: np.ndarray
    timesteps: int = 25

    @classmethod
    def from_checkpoint(cls, checkpoint: Path, timesteps: int = 25) -> FixedPointSNN:
        ref = MnistSNN().eval()
        ckpt = torch.load(checkpoint, map_location="cpu", weights_only=False)
        state = ckpt.get("model") or ckpt.get("state_dict") or ckpt
        ref.load_state_dict(state)
        return cls(
            w1_fp=to_fp(ref.fc1.weight.detach().numpy()),
            b1_fp=to_fp(ref.fc1.bias.detach().numpy()),
            w2_fp=to_fp(ref.fc2.weight.detach().numpy()),
            b2_fp=to_fp(ref.fc2.bias.detach().numpy()),
            timesteps=timesteps,
        )

    def forward(self, x_fp: np.ndarray) -> np.ndarray:
        """x_fp flattened (784,) -> spk_sum (10,) integer spike counts."""
        mem1 = np.zeros(self.w1_fp.shape[0], dtype=np.int64)
        mem2 = np.zeros(self.w2_fp.shape[0], dtype=np.int64)
        spk_sum = np.zeros(self.w2_fp.shape[0], dtype=np.int64)
        for _ in range(self.timesteps):
            cur1 = linear_fp(x_fp, self.w1_fp, self.b1_fp)
            spk1, _, mem1 = lif_step_fp(cur1, mem1)
            cur2 = linear_fp(spk1, self.w2_fp, self.b2_fp)
            _, spk2_bit, mem2 = lif_step_fp(cur2, mem2)
            spk_sum += spk2_bit
        return spk_sum


def load_float_model(checkpoint: Path, timesteps: int) -> MnistSNNUnrolled:
    ref = MnistSNN().eval()
    ckpt = torch.load(checkpoint, map_location="cpu", weights_only=False)
    state = ckpt.get("model") or ckpt.get("state_dict") or ckpt
    ref.load_state_dict(state)
    return MnistSNNUnrolled(ref, timesteps).eval()


def main() -> int:
    p = argparse.ArgumentParser(description="Fixed-point SNN inference reference")
    p.add_argument("--checkpoint", type=Path, default=ROOT / "runs" / "20260527T092534Z" / "checkpoint.pt")
    p.add_argument("--timesteps", type=int, default=25)
    p.add_argument("--samples", type=int, default=128)
    p.add_argument("--out", type=Path, default=ROOT / "runs" / "phase4_poc" / "fpga_fixedpoint_snn.json")
    args = p.parse_args()

    fp_net = FixedPointSNN.from_checkpoint(args.checkpoint, args.timesteps)
    float_net = load_float_model(args.checkpoint, args.timesteps)

    _, test_loader = loaders(ROOT / "data" / "mnist", batch_size=args.samples)
    batch, labels = next(iter(test_loader))
    batch = batch[: args.samples]

    pred_fp: list[int] = []
    pred_fl: list[int] = []
    count_mae: list[float] = []
    count_exact = 0

    with torch.no_grad():
        for i in range(batch.size(0)):
            x = batch[i : i + 1]
            fl_out = float_net(x).numpy()[0]
            x_fp = to_fp(x.numpy().reshape(-1))
            fp_out = fp_net.forward(x_fp).astype(np.float64)
            pred_fl.append(int(fl_out.argmax()))
            pred_fp.append(int(fp_out.argmax()))
            mae = float(np.mean(np.abs(fl_out - fp_out)))
            count_mae.append(mae)
            if np.array_equal(fl_out.astype(int), fp_out.astype(int)):
                count_exact += 1

    labels_np = labels.numpy()
    acc_float = float((np.array(pred_fl) == labels_np).mean())
    acc_fp = float((np.array(pred_fp) == labels_np).mean())
    agree = float((np.array(pred_fp) == np.array(pred_fl)).mean())

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "format": "Q16.16",
        "timesteps": args.timesteps,
        "samples": args.samples,
        "acc_float_unrolled": round(acc_float, 6),
        "acc_fixedpoint": round(acc_fp, 6),
        "pred_agreement_float_vs_fixed": round(agree, 6),
        "spike_count_exact_match_rate": round(count_exact / args.samples, 6),
        "spike_count_mae_mean": round(float(np.mean(count_mae)), 6),
        "pass_criteria": {
            "pred_agreement_ge": 0.95,
            "acc_fixedpoint_ge": 0.90,
        },
    }
    passed = agree >= 0.95 and acc_fp >= 0.90
    payload["pass"] = passed

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

    print(f"float_acc={acc_float:.4f} fixed_acc={acc_fp:.4f} agree={agree:.4f} exact_counts={count_exact}/{args.samples}")
    print(f"pass={passed} wrote {args.out}")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
