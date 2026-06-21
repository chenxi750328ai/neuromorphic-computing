#!/usr/bin/env python3
"""Phase4 · ONNXRuntime 冒烟推理（陈正共）。"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    p = argparse.ArgumentParser(description="ONNX smoke test")
    p.add_argument("--model", type=Path, required=True)
    args = p.parse_args()
    if not args.model.is_file():
        print(f"missing model: {args.model}", file=sys.stderr)
        return 1
    try:
        import onnxruntime as ort
    except ImportError:
        print("install onnxruntime: pip install onnxruntime", file=sys.stderr)
        return 1

    sess = ort.InferenceSession(str(args.model), providers=["CPUExecutionProvider"])
    inp = sess.get_inputs()[0]
    shape = [1 if (d is None or isinstance(d, str)) else int(d) for d in inp.shape]
    for i, d in enumerate(shape):
        if d is None or d <= 0:
            shape[i] = 1
    if len(shape) == 4:
        shape = [1, 1, 28, 28]
    x = np.random.randn(*shape).astype(np.float32)
    out = sess.run(None, {inp.name: x})
    print(f"ok: input={shape} outputs={[o.shape for o in out]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
