#!/usr/bin/env python3
"""Atlas 侧：读取固定 probe 输入并打印脉冲计数 JSON 行。"""
from __future__ import annotations

import argparse
import json
import sys
import time

import numpy as np

sys.path.insert(0, "/usr/local/Ascend/thirdpart/aarch64/acllite")
sys.path.insert(0, "/usr/local/Ascend/ascend-toolkit/latest/python/site-packages")

from acllite_model import AclLiteModel
from acllite_resource import AclLiteResource


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="/tmp/phase4_snn/mnist_snn.om")
    ap.add_argument("--input", default="/tmp/phase4_snn/snn_probe_input.npy")
    ap.add_argument("--batch", action="store_true", help="Run each sample in input array separately")
    args = ap.parse_args()

    x = np.load(args.input)
    if x.ndim == 3:
        x = x[:, None, :, :]
    res = AclLiteResource()
    res.init()
    model = AclLiteModel(args.model)

    if args.batch and x.shape[0] > 1:
        counts_all = []
        ms_total = 0.0
        for i in range(x.shape[0]):
            sample = np.ascontiguousarray(x[i : i + 1])
            t0 = time.time()
            out = model.execute([sample])
            ms_total += (time.time() - t0) * 1000
            counts_all.append(np.asarray(out[0])[0].tolist())
        print(
            json.dumps(
                {
                    "atlas_counts": counts_all,
                    "infer_ms": round(ms_total, 2),
                    "batch_size": x.shape[0],
                }
            )
        )
        return 0

    sample = np.ascontiguousarray(x[:1])
    t0 = time.time()
    out = model.execute([sample])
    ms = (time.time() - t0) * 1000
    counts = np.asarray(out[0])[0].tolist()
    print(json.dumps({"atlas_counts": counts, "infer_ms": round(ms, 2)}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
