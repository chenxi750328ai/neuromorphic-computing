#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MNIST SNN 仿真训练与评估（Phase 1 · 陈正共）。"""
from __future__ import annotations

import argparse
import json
import random
import time
from datetime import datetime, timezone
from pathlib import Path

import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

import snntorch as snn

ROOT = Path(__file__).resolve().parents[1]


class MnistSNN(nn.Module):
    def __init__(self, hidden: int = 256, beta: float = 0.9) -> None:
        super().__init__()
        self.fc1 = nn.Linear(28 * 28, hidden)
        self.lif1 = snn.Leaky(beta=beta)
        self.fc2 = nn.Linear(hidden, 10)
        self.lif2 = snn.Leaky(beta=beta)

    def forward(self, x: torch.Tensor, timesteps: int) -> torch.Tensor:
        x = x.view(x.size(0), -1)
        mem1 = self.lif1.init_leaky()
        mem2 = self.lif2.init_leaky()
        spk2_rec = []
        for _ in range(timesteps):
            cur1 = self.fc1(x)
            spk1, mem1 = self.lif1(cur1, mem1)
            cur2 = self.fc2(spk1)
            spk2, mem2 = self.lif2(cur2, mem2)
            spk2_rec.append(spk2)
        return torch.stack(spk2_rec)


def set_seed(seed: int) -> None:
    random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)


def loaders(data_dir: Path, batch_size: int) -> tuple[DataLoader, DataLoader]:
    tfm = transforms.Compose(
        [
            transforms.ToTensor(),
            transforms.Normalize((0.1307,), (0.3081,)),
        ]
    )
    train_ds = datasets.MNIST(str(data_dir), train=True, download=True, transform=tfm)
    test_ds = datasets.MNIST(str(data_dir), train=False, download=True, transform=tfm)
    train_loader = DataLoader(train_ds, batch_size=batch_size, shuffle=True, num_workers=0)
    test_loader = DataLoader(test_ds, batch_size=batch_size, shuffle=False, num_workers=0)
    return train_loader, test_loader


@torch.no_grad()
def evaluate(net: nn.Module, loader: DataLoader, device: torch.device, timesteps: int) -> tuple[float, int, int]:
    net.eval()
    correct = 0
    total = 0
    for data, target in loader:
        data, target = data.to(device), target.to(device)
        spk_rec = net(data, timesteps)
        pred = spk_rec.sum(dim=0).argmax(dim=1)
        correct += (pred == target).sum().item()
        total += target.size(0)
    return correct / max(total, 1), correct, total


def train_one_epoch(
    net: nn.Module,
    loader: DataLoader,
    device: torch.device,
    optimizer: torch.optim.Optimizer,
    criterion: nn.Module,
    timesteps: int,
) -> float:
    net.train()
    total_loss = 0.0
    n = 0
    for data, target in loader:
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        spk_rec = net(data, timesteps)
        # 对时间维脉冲计数做分类
        loss = criterion(spk_rec.sum(dim=0), target)
        loss.backward()
        optimizer.step()
        total_loss += loss.item() * target.size(0)
        n += target.size(0)
    return total_loss / max(n, 1)


def param_count(net: nn.Module) -> int:
    return sum(p.numel() for p in net.parameters() if p.requires_grad)


def main() -> int:
    p = argparse.ArgumentParser(description="MNIST SNN Phase1 (陈正共)")
    p.add_argument("--seed", type=int, default=42)
    p.add_argument("--epochs", type=int, default=10)
    p.add_argument("--batch-size", type=int, default=128)
    p.add_argument("--lr", type=float, default=1e-3)
    p.add_argument("--timesteps", type=int, default=25)
    p.add_argument("--hidden", type=int, default=256)
    p.add_argument("--device", default=None, help="cuda | cpu，默认自动")
    p.add_argument("--data-dir", type=Path, default=ROOT / "data" / "mnist")
    p.add_argument("--out-dir", type=Path, default=None, help="默认 runs/<timestamp>")
    p.add_argument("--eval-only", action="store_true", help="仅评估 checkpoint")
    p.add_argument("--checkpoint", type=Path, default=None)
    args = p.parse_args()

    set_seed(args.seed)
    device = torch.device(args.device or ("cuda" if torch.cuda.is_available() else "cpu"))

    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    out_dir = args.out_dir or (ROOT / "runs" / stamp)
    out_dir.mkdir(parents=True, exist_ok=True)

    train_loader, test_loader = loaders(args.data_dir, args.batch_size)
    net = MnistSNN(hidden=args.hidden).to(device)
    optimizer = torch.optim.Adam(net.parameters(), lr=args.lr)
    criterion = nn.CrossEntropyLoss()

    metrics: dict = {
        "project": "neuromorphic-computing",
        "owner": "陈正共",
        "task": "MNIST_SNN_sim",
        "seed": args.seed,
        "device": str(device),
        "params": param_count(net),
        "timesteps": args.timesteps,
        "epochs_planned": args.epochs,
        "history": [],
    }

    ckpt_path = out_dir / "checkpoint.pt"
    t0 = time.perf_counter()

    if args.eval_only:
        if not args.checkpoint or not args.checkpoint.is_file():
            print("eval-only 需要 --checkpoint", flush=True)
            return 2
        net.load_state_dict(torch.load(args.checkpoint, map_location=device, weights_only=True))
        acc, correct, total = evaluate(net, test_loader, device, args.timesteps)
        metrics["test_accuracy"] = acc
        metrics["test_correct"] = correct
        metrics["test_total"] = total
        metrics["elapsed_sec"] = round(time.perf_counter() - t0, 2)
        (out_dir / "metrics.json").write_text(json.dumps(metrics, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"test_acc={acc:.4f} ({correct}/{total}) -> {out_dir / 'metrics.json'}")
        return 0

    for epoch in range(1, args.epochs + 1):
        loss = train_one_epoch(net, train_loader, device, optimizer, criterion, args.timesteps)
        acc, correct, total = evaluate(net, test_loader, device, args.timesteps)
        row = {
            "epoch": epoch,
            "train_loss": round(loss, 6),
            "test_accuracy": round(acc, 6),
            "test_correct": correct,
            "test_total": total,
        }
        metrics["history"].append(row)
        print(f"epoch {epoch}/{args.epochs} loss={loss:.4f} test_acc={acc:.4f}", flush=True)
        torch.save(net.state_dict(), ckpt_path)

    metrics["test_accuracy"] = metrics["history"][-1]["test_accuracy"]
    metrics["test_correct"] = metrics["history"][-1]["test_correct"]
    metrics["test_total"] = metrics["history"][-1]["test_total"]
    metrics["elapsed_sec"] = round(time.perf_counter() - t0, 2)
    metrics["pass_line_90pct"] = metrics["test_accuracy"] >= 0.90

    (out_dir / "metrics.json").write_text(json.dumps(metrics, ensure_ascii=False, indent=2), encoding="utf-8")
    config = vars(args).copy()
    config["data_dir"] = str(config["data_dir"])
    config["out_dir"] = str(out_dir)
    (out_dir / "config.json").write_text(json.dumps(config, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"done test_acc={metrics['test_accuracy']:.4f} pass_90={metrics['pass_line_90pct']}")
    print(f"checkpoint={ckpt_path}")
    print(f"metrics={out_dir / 'metrics.json'}")
    return 0 if metrics["pass_line_90pct"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
