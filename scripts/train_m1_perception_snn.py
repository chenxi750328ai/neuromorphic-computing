#!/usr/bin/env python3
"""Phase5 · P5-2 独立感知 SNN（M1 · ≠ Phase1 MnistSNN 单体）。

输入：事件体 [B,T,H,W]（接 P5-1 rate 编码），按时间步喂入 LIF。
板无关；板待修期间并行推进。

陈正共 · ChenZhengGong
"""
from __future__ import annotations

import argparse
import json
import random
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

import snntorch as snn

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from phase5_event_loader import build_batch  # noqa: E402

OUT_DIR = ROOT / "runs" / "m1_perception"
EVIDENCE = ROOT / "docs" / "phase5_poc_evidence" / "p5_2_perception_smoke.json"


class PerceptionSNN(nn.Module):
    """M1 感知网：事件帧序列 → 10 类（smoke）/ 特征向量（feat_dim）。"""

    def __init__(self, hidden: int = 128, feat_dim: int = 256, beta: float = 0.9) -> None:
        super().__init__()
        self.feat_dim = feat_dim
        self.fc1 = nn.Linear(28 * 28, hidden)
        self.lif1 = snn.Leaky(beta=beta)
        self.fc_feat = nn.Linear(hidden, feat_dim)
        self.lif_feat = snn.Leaky(beta=beta)
        self.fc_out = nn.Linear(feat_dim, 10)
        self.lif_out = snn.Leaky(beta=beta)

    def forward(self, spikes: torch.Tensor) -> tuple[torch.Tensor, torch.Tensor]:
        """spikes: [B,T,H,W] → (spk_out_rec [T,B,10], feat_last [B,feat_dim])."""
        b, t, h, w = spikes.shape
        mem1 = self.lif1.init_leaky()
        mem_f = self.lif_feat.init_leaky()
        mem_o = self.lif_out.init_leaky()
        spk_out_rec = []
        feat = torch.zeros(b, self.feat_dim, device=spikes.device)
        for ti in range(t):
            x = spikes[:, ti].reshape(b, -1).float()
            cur1 = self.fc1(x)
            spk1, mem1 = self.lif1(cur1, mem1)
            cur_f = self.fc_feat(spk1)
            spk_f, mem_f = self.lif_feat(cur_f, mem_f)
            feat = spk_f
            cur_o = self.fc_out(spk_f)
            spk_o, mem_o = self.lif_out(cur_o, mem_o)
            spk_out_rec.append(spk_o)
        return torch.stack(spk_out_rec), feat


def set_seed(seed: int) -> None:
    random.seed(seed)
    torch.manual_seed(seed)


def make_loader(*, n: int, T: int, seed: int, batch_size: int, data_dir: Path) -> DataLoader:
    batch = build_batch(data_dir=data_dir, n=n, T=T, seed=seed, train=True)
    x = torch.from_numpy(batch.spikes.astype("float32"))
    y = torch.from_numpy(batch.labels.astype("int64"))
    return DataLoader(TensorDataset(x, y), batch_size=batch_size, shuffle=True)


@torch.no_grad()
def evaluate(net: PerceptionSNN, loader: DataLoader, device: torch.device) -> float:
    net.eval()
    correct = total = 0
    for data, target in loader:
        data, target = data.to(device), target.to(device)
        spk_rec, _ = net(data)
        pred = spk_rec.sum(dim=0).argmax(dim=1)
        correct += int((pred == target).sum().item())
        total += int(target.size(0))
    return correct / max(total, 1)


def train_smoke(args: argparse.Namespace) -> dict:
    set_seed(args.seed)
    device = torch.device("cuda" if torch.cuda.is_available() and not args.cpu else "cpu")
    data_dir = Path(args.data_dir)
    train_loader = make_loader(
        n=args.n_train, T=args.T, seed=args.seed, batch_size=args.batch_size, data_dir=data_dir
    )
    test_loader = make_loader(
        n=args.n_test, T=args.T, seed=args.seed + 1, batch_size=args.batch_size, data_dir=data_dir
    )
    # rebuild test as train=False-ish via different seed subset is OK for smoke

    net = PerceptionSNN(hidden=args.hidden, feat_dim=args.feat_dim).to(device)
    opt = torch.optim.Adam(net.parameters(), lr=args.lr)
    loss_fn = nn.CrossEntropyLoss()

    t0 = time.perf_counter()
    net.train()
    last_loss = 0.0
    for epoch in range(args.epochs):
        for data, target in train_loader:
            data, target = data.to(device), target.to(device)
            opt.zero_grad()
            spk_rec, feat = net(data)
            logits = spk_rec.sum(dim=0)
            loss = loss_fn(logits, target)
            loss.backward()
            opt.step()
            last_loss = float(loss.item())
            _ = feat  # feature path exercised

    train_acc = evaluate(net, train_loader, device)
    test_acc = evaluate(net, test_loader, device)
    wall_ms = (time.perf_counter() - t0) * 1000

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    ckpt = OUT_DIR / "perception_snn_smoke.pt"
    torch.save({"model": net.state_dict(), "feat_dim": args.feat_dim}, ckpt)

    # smoke gate: finishes + feature dim frozen + train_acc not NaN
    ok = (
        args.feat_dim == 256
        and train_acc == train_acc
        and test_acc == test_acc
        and ckpt.is_file()
    )
    result = {
        "schema": "phase5-p5-2-perception-snn-smoke-v1",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ag-chenzhenggong",
        "ok": ok,
        "model": "PerceptionSNN",
        "not_mnist_snn": True,
        "feat_dim": args.feat_dim,
        "epochs": args.epochs,
        "n_train": args.n_train,
        "n_test": args.n_test,
        "T": args.T,
        "device": str(device),
        "train_acc": round(train_acc, 4),
        "test_acc": round(test_acc, 4),
        "last_loss": round(last_loss, 6),
        "wall_ms": round(wall_ms, 3),
        "checkpoint": str(ckpt.relative_to(ROOT)),
        "board_independent": True,
        "note": "P5-2 smoke · event-in PerceptionSNN · Phase4.2 board deferred",
    }
    metrics = OUT_DIR / "metrics_smoke.json"
    metrics.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    EVIDENCE.parent.mkdir(parents=True, exist_ok=True)
    EVIDENCE.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return result


def main() -> int:
    ap = argparse.ArgumentParser(description="Phase5 P5-2 PerceptionSNN (陈正共)")
    ap.add_argument("--smoke", action="store_true")
    ap.add_argument("--gate", action="store_true")
    ap.add_argument("--epochs", type=int, default=1)
    ap.add_argument("--n-train", type=int, default=256)
    ap.add_argument("--n-test", type=int, default=64)
    ap.add_argument("--T", type=int, default=8)
    ap.add_argument("--batch-size", type=int, default=64)
    ap.add_argument("--hidden", type=int, default=128)
    ap.add_argument("--feat-dim", type=int, default=256)
    ap.add_argument("--lr", type=float, default=1e-3)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--cpu", action="store_true")
    ap.add_argument("--data-dir", default=str(ROOT / "data" / "mnist"))
    args = ap.parse_args()
    if not args.smoke and not args.gate:
        args.smoke = True

    # use venv interpreter hint
    result = train_smoke(args)
    print(json.dumps({k: result[k] for k in ("ok", "train_acc", "test_acc", "feat_dim", "wall_ms")}, ensure_ascii=False))
    if args.gate and not result["ok"]:
        return 1
    return 0 if result["ok"] else (1 if args.gate else 0)


if __name__ == "__main__":
    raise SystemExit(main())
