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
    args = ap.parse_args()

    x = np.load(args.input)
    res = AclLiteResource()
    res.init()
    model = AclLiteModel(args.model)
    t0 = time.time()
    out = model.execute([x])
    ms = (time.time() - t0) * 1000
    counts = np.asarray(out[0])[0].tolist()
    print(json.dumps({"atlas_counts": counts, "infer_ms": round(ms, 2)}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
