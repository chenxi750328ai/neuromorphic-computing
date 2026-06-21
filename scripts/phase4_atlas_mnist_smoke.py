#!/usr/bin/env python3
"""Phase4 M4-3 · MNIST ANN-surrogate OM 冒烟（Atlas AclLite）。"""
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
    ap.add_argument("--model", default="mnist_snn_surrogate.om")
    ap.add_argument("--batch", type=int, default=1)
    args = ap.parse_args()

    blob = np.random.randn(args.batch, 1, 28, 28).astype(np.float32)
    blob = np.ascontiguousarray(blob)

    res = AclLiteResource()
    res.init()
    model = AclLiteModel(args.model)

    t0 = time.time()
    out = model.execute([blob])
    ms = (time.time() - t0) * 1000

    logits = np.asarray(out[0])
    pred = logits.argmax(axis=-1)
    print(f"ok infer_ms={ms:.2f} logits_shape={logits.shape} pred={pred.tolist()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
