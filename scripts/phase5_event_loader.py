#!/usr/bin/env python3
"""Phase5 · P5-1 事件编码 loader（软件轨 · 不依 FPGA 板）。

默认：MNIST → 泊松率编码（T 帧脉冲体）。
可选：若本地存在 N-MNIST 目录则走原生事件（未下载不阻塞 smoke）。

作者：陈正共 · ChenZhengGong · WO 并行于 Phase4.2（板待修）
"""
from __future__ import annotations

import argparse
import json
import time
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MNIST = ROOT / "data" / "mnist"
DEFAULT_OUT = ROOT / "runs" / "m1_perception" / "loader_smoke.json"


@dataclass
class EventBatch:
    """Dense spike volume [N, T, H, W] + labels."""

    spikes: np.ndarray
    labels: np.ndarray
    encoding: str
    T: int
    H: int = 28
    W: int = 28

    @property
    def n(self) -> int:
        return int(self.spikes.shape[0])

    def summary(self) -> dict[str, Any]:
        rate = float(self.spikes.mean()) if self.spikes.size else 0.0
        return {
            "n": self.n,
            "T": self.T,
            "shape": list(self.spikes.shape),
            "encoding": self.encoding,
            "mean_spike_rate": rate,
            "label_hist": {str(int(k)): int(v) for k, v in zip(*np.unique(self.labels, return_counts=True))},
        }


def mnist_to_rate_spikes(
    images: np.ndarray,
    *,
    T: int = 10,
    seed: int = 0,
) -> np.ndarray:
    """images [N,28,28] in [0,1] → Bernoulli spikes [N,T,28,28]."""
    rng = np.random.default_rng(seed)
    x = np.clip(images.astype(np.float32), 0.0, 1.0)
    # broadcast rate over time
    p = np.repeat(x[:, None, :, :], T, axis=1)
    return (rng.random(p.shape, dtype=np.float32) < p).astype(np.uint8)


def _read_idx_images(path: Path) -> np.ndarray:
    raw = path.read_bytes()
    # magic, n, rows, cols
    import struct

    magic, n, rows, cols = struct.unpack(">IIII", raw[:16])
    if magic != 2051:
        raise ValueError(f"bad image magic {magic} in {path}")
    data = np.frombuffer(raw, dtype=np.uint8, offset=16)
    return data.reshape(n, rows, cols).astype(np.float32) / 255.0


def _read_idx_labels(path: Path) -> np.ndarray:
    raw = path.read_bytes()
    import struct

    magic, n = struct.unpack(">II", raw[:8])
    if magic != 2049:
        raise ValueError(f"bad label magic {magic} in {path}")
    return np.frombuffer(raw, dtype=np.uint8, offset=8).astype(np.int64)


def _resolve_mnist_raw(data_dir: Path) -> Path:
    candidates = [
        data_dir / "MNIST" / "raw",
        data_dir / "raw",
        data_dir,
    ]
    for c in candidates:
        if (c / "train-images-idx3-ubyte").is_file():
            return c
    raise FileNotFoundError(f"MNIST idx not found under {data_dir}")


def load_mnist_numpy(data_dir: Path, *, train: bool, n: int, seed: int) -> tuple[np.ndarray, np.ndarray]:
    """Load MNIST via IDX first (no torch). Optional torchvision fallback."""
    try:
        raw = _resolve_mnist_raw(data_dir)
        prefix = "train" if train else "t10k"
        images = _read_idx_images(raw / f"{prefix}-images-idx3-ubyte")
        labels = _read_idx_labels(raw / f"{prefix}-labels-idx1-ubyte")
        rng = np.random.default_rng(seed)
        idx = rng.choice(images.shape[0], size=min(n, images.shape[0]), replace=False)
        return images[idx], labels[idx]
    except Exception:
        pass

    from torchvision import datasets, transforms  # type: ignore

    ds = datasets.MNIST(
        str(data_dir),
        train=train,
        download=False,
        transform=transforms.ToTensor(),
    )
    rng = np.random.default_rng(seed)
    idx = rng.choice(len(ds), size=min(n, len(ds)), replace=False)
    imgs, labels = [], []
    for i in idx:
        img, y = ds[int(i)]
        imgs.append(img.squeeze(0).numpy())
        labels.append(int(y))
    return np.stack(imgs, axis=0), np.asarray(labels, dtype=np.int64)

def try_load_nmnist_stub(nmnist_dir: Path) -> dict[str, Any]:
    """Detect N-MNIST tree without requiring download."""
    if not nmnist_dir.is_dir():
        return {"available": False, "path": str(nmnist_dir), "reason": "absent"}
    files = list(nmnist_dir.rglob("*"))
    return {
        "available": len(files) > 0,
        "path": str(nmnist_dir),
        "n_entries": len(files),
        "note": "native N-MNIST path reserved; smoke uses MNIST→rate until dataset pinned",
    }


def build_batch(
    *,
    data_dir: Path,
    n: int,
    T: int,
    seed: int,
    train: bool,
) -> EventBatch:
    imgs, labels = load_mnist_numpy(data_dir, train=train, n=n, seed=seed)
    spikes = mnist_to_rate_spikes(imgs, T=T, seed=seed + 1)
    return EventBatch(spikes=spikes, labels=labels, encoding="mnist_rate_poisson", T=T)


def run_smoke(args: argparse.Namespace) -> dict[str, Any]:
    t0 = time.perf_counter()
    batch = build_batch(
        data_dir=Path(args.data_dir),
        n=args.n,
        T=args.T,
        seed=args.seed,
        train=not args.test,
    )
    # sanity: at least some spikes for non-blank digits
    assert batch.spikes.ndim == 4 and batch.spikes.shape[1] == args.T
    assert batch.n == batch.labels.shape[0]
    assert batch.spikes.dtype == np.uint8
    mean_rate = float(batch.spikes.mean())
    ok = batch.n == args.n and 0.0 < mean_rate < 1.0

    nmnist = try_load_nmnist_stub(Path(args.nmnist_dir))
    out = {
        "schema": "phase5-p5-1-event-loader-smoke-v1",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ag-chenzhenggong",
        "ok": ok,
        "wall_ms": round((time.perf_counter() - t0) * 1000, 3),
        "batch": batch.summary(),
        "nmnist": nmnist,
        "board_independent": True,
        "note": "P5-1 smoke · MNIST→rate events · Phase4.2 board deferred",
    }
    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description="Phase5 P5-1 event loader (陈正共)")
    ap.add_argument("--smoke", action="store_true", help="写 loader_smoke.json 并断言形状")
    ap.add_argument("--gate", action="store_true", help="smoke 失败则 exit 1")
    ap.add_argument("--n", type=int, default=32)
    ap.add_argument("--T", type=int, default=10)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--test", action="store_true", help="用 MNIST test split")
    ap.add_argument("--data-dir", default=str(DEFAULT_MNIST))
    ap.add_argument("--nmnist-dir", default=str(ROOT / "data" / "nmnist"))
    ap.add_argument("--out", default=str(DEFAULT_OUT))
    args = ap.parse_args()

    if not args.smoke and not args.gate:
        args.smoke = True
    result = run_smoke(args)
    print(json.dumps({"ok": result["ok"], "wall_ms": result["wall_ms"], "batch": result["batch"]}, ensure_ascii=False))
    print(f"wrote {args.out}")
    if args.gate and not result["ok"]:
        return 1
    if args.smoke and not result["ok"]:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
