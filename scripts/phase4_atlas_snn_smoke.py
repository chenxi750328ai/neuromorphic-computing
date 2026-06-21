#!/usr/bin/env python3
"""Phase4 · 真 SNN OM 冒烟（Atlas AclLite）。"""
from __future__ import annotations

import argparse
import sys
import time

import numpy as np

sys.path.insert(0, "/usr/local/Ascend/thirdpart/aarch64/acllite")
sys.path.insert(0, "/usr/local/Ascend/ascend-toolkit/latest/python/site-packages")

from acllite_model import AclLiteModel
from acllite_resource import AclLiteResource


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="mnist_snn.om")
    ap.add_argument("--batch", type=int, default=1)
    args = ap.parse_args()

    blob = np.random.randn(args.batch, 1, 28, 28).astype(np.float32) * 0.3
    blob = np.ascontiguousarray(blob)

    res = AclLiteResource()
    res.init()
    model = AclLiteModel(args.model)

    t0 = time.time()
    out = model.execute([blob])
    ms = (time.time() - t0) * 1000

    counts = np.asarray(out[0])
    pred = counts.argmax(axis=-1)
    print(f"PASS ok infer_ms={ms:.2f} spike_counts_shape={counts.shape} pred={pred.tolist()}")
    print(f"counts_sample={np.round(counts[0], 3).tolist()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
