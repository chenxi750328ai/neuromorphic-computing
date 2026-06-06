#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MNIST 小样本 + 数据增强（Phase 3 · 陈正共）。"""
from __future__ import annotations

import argparse
import json
import random
import time
from datetime import datetime, timezone
from pathlib import Path

import torch
import torch.nn as nn
from torch.utils.data import DataLoader, Subset
from torchvision import datasets, transforms

ROOT = Path(__file__).resolve().parents[1]

BASELINE_ANN = 0.981


class MnistMLP(nn.Module):
    def __init__(self, hidden: int = 256) -> None:
        super().__init__()
        self.net = nn.Sequential(
            nn.Flatten(),
            nn.Linear(28 * 28, hidden),
            nn.ReLU(inplace=True),
            nn.Linear(hidden, 10),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.net(x)


def set_seed(seed: int) -> None:
    random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)


def fewshot_train_indices(targets: torch.Tensor, shots_per_class: int, seed: int) -> list[int]:
    g = torch.Generator().manual_seed(seed)
    picked: list[int] = []
    for label in range(10):
        idx = (targets == label).nonzero(as_tuple=True)[0]
        perm = idx[torch.randperm(idx.numel(), generator=g)]
        picked.extend(perm[:shots_per_class].tolist())
    return picked


def build_loaders(
    data_dir: Path,
    shots_per_class: int,
    seed: int,
    batch_size: int,
    augment: bool,
) -> tuple[DataLoader, DataLoader, int]:
    test_tfm = transforms.Compose(
        [
            transforms.ToTensor(),
            transforms.Normalize((0.1307,), (0.3081,)),
        ]
    )
    if augment:
        train_tfm = transforms.Compose(
            [
                transforms.RandomRotation(15),
                transforms.RandomAffine(0, translate=(0.1, 0.1), scale=(0.85, 1.15)),
                transforms.ToTensor(),
                transforms.Normalize((0.1307,), (0.3081,)),
            ]
        )
    else:
        train_tfm = test_tfm

    train_full = datasets.MNIST(str(data_dir), train=True, download=True, transform=train_tfm)
    test_raw = datasets.MNIST(str(data_dir), train=False, download=True)
    test_ds = datasets.MNIST(str(data_dir), train=False, download=True, transform=test_tfm)
    indices = fewshot_train_indices(train_full.targets, shots_per_class, seed)
    train_ds = Subset(train_full, indices)
    train_n = len(indices)
    bs = min(batch_size, max(train_n, 1))
    train_loader = DataLoader(train_ds, batch_size=bs, shuffle=True, num_workers=0)
    test_loader = DataLoader(test_ds, batch_size=256, shuffle=False, num_workers=0)
    return train_loader, test_loader, train_n


@torch.no_grad()
def evaluate(net: nn.Module, loader: DataLoader, device: torch.device) -> tuple[float, int, int]:
    net.eval()
    correct = 0
    total = 0
    for data, target in loader:
        data, target = data.to(device), target.to(device)
        pred = net(data).argmax(dim=1)
        correct += (pred == target).sum().item()
        total += target.size(0)
    return correct / max(total, 1), correct, total


def train_one_epoch(
    net: nn.Module,
    loader: DataLoader,
    device: torch.device,
    optimizer: torch.optim.Optimizer,
    criterion: nn.Module,
) -> float:
    net.train()
    total_loss = 0.0
    n = 0
    for data, target in loader:
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        loss = criterion(net(data), target)
        loss.backward()
        optimizer.step()
        total_loss += loss.item() * target.size(0)
        n += target.size(0)
    return total_loss / max(n, 1)


def param_count(net: nn.Module) -> int:
    return sum(p.numel() for p in net.parameters() if p.requires_grad)


def main() -> int:
    p = argparse.ArgumentParser(description="MNIST few-shot ANN with augmentation (陈正共)")
    p.add_argument("--shots-per-class", "-k", type=int, default=5)
    p.add_argument("--seed", type=int, default=42)
    p.add_argument("--epochs", type=int, default=50)
    p.add_argument("--batch-size", type=int, default=32)
    p.add_argument("--lr", type=float, default=1e-3)
    p.add_argument("--hidden", type=int, default=256)
    p.add_argument("--device", default=None)
    p.add_argument("--data-dir", type=Path, default=ROOT / "data" / "mnist")
    p.add_argument("--out-dir", type=Path, default=None)
    p.add_argument("--pass-line", type=float, default=0.70)
    p.add_argument("--augment", action="store_true", help="启用旋转/平移/缩放增强")
    args = p.parse_args()

    set_seed(args.seed)
    device = torch.device(args.device or ("cuda" if torch.cuda.is_available() else "cpu"))

    tag = "aug" if args.augment else "raw"
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    out_dir = args.out_dir or (ROOT / "runs" / f"{stamp}_fewshot_k{args.shots_per_class}_{tag}")
    out_dir.mkdir(parents=True, exist_ok=True)

    train_loader, test_loader, train_n = build_loaders(
        args.data_dir, args.shots_per_class, args.seed, args.batch_size, args.augment
    )
    net = MnistMLP(hidden=args.hidden).to(device)
    optimizer = torch.optim.Adam(net.parameters(), lr=args.lr)
    criterion = nn.CrossEntropyLoss()

    metrics: dict = {
        "project": "neuromorphic-computing",
        "owner": "陈正共",
        "task": f"MNIST_ANN_fewshot_{tag}",
        "model": "MLP",
        "shots_per_class": args.shots_per_class,
        "train_images": train_n,
        "augment": args.augment,
        "seed": args.seed,
        "device": str(device),
        "params": param_count(net),
        "epochs_planned": args.epochs,
        "baseline_full_ann": BASELINE_ANN,
        "history": [],
    }

    ckpt_path = out_dir / "checkpoint.pt"
    t0 = time.perf_counter()

    for epoch in range(1, args.epochs + 1):
        loss = train_one_epoch(net, train_loader, device, optimizer, criterion)
        acc, correct, total = evaluate(net, test_loader, device)
        row = {
            "epoch": epoch,
            "train_loss": round(loss, 6),
            "test_accuracy": round(acc, 6),
            "test_correct": correct,
            "test_total": total,
        }
        metrics["history"].append(row)
        if epoch % 5 == 0 or epoch == 1:
            print(
                f"k={args.shots_per_class} aug={args.augment} "
                f"epoch {epoch}/{args.epochs} test_acc={acc:.4f}",
                flush=True,
            )
        torch.save(net.state_dict(), ckpt_path)

    final_acc = metrics["history"][-1]["test_accuracy"]
    metrics["test_accuracy"] = final_acc
    metrics["test_correct"] = metrics["history"][-1]["test_correct"]
    metrics["test_total"] = metrics["history"][-1]["test_total"]
    metrics["elapsed_sec"] = round(time.perf_counter() - t0, 2)
    metrics["gap_vs_full_ann"] = round(BASELINE_ANN - final_acc, 6)
    metrics["pass_line"] = args.pass_line
    metrics["pass_fewshot"] = final_acc >= args.pass_line

    (out_dir / "metrics.json").write_text(
        json.dumps(metrics, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    config = vars(args).copy()
    for key in ("data_dir", "out_dir"):
        config[key] = str(config[key])
    (out_dir / "config.json").write_text(
        json.dumps(config, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    print(
        f"done k={args.shots_per_class} aug={args.augment} train_n={train_n} "
        f"test_acc={final_acc:.4f} pass={metrics['pass_fewshot']} "
        f"gap_ann={metrics['gap_vs_full_ann']:.4f}",
        flush=True,
    )
    print(f"metrics={out_dir / 'metrics.json'}")
    return 0 if metrics["pass_fewshot"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
