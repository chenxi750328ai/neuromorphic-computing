#!/usr/bin/env python3
"""固定输入：对比 ORT(CPU) 与 Atlas OM 的 SNN 脉冲计数。"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

import numpy as np
import onnxruntime as ort

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--onnx", type=Path, default=ROOT / "runs" / "phase4_export" / "model_snn.onnx")
    p.add_argument("--host", default="192.168.137.2")
    p.add_argument("--om", default="/tmp/phase4_snn/mnist_snn.om")
    p.add_argument("--seed", type=int, default=42)
    args = p.parse_args()

    rng = np.random.default_rng(args.seed)
    x = rng.standard_normal((1, 1, 28, 28), dtype=np.float32) * 0.3
    x = np.ascontiguousarray(x)
    bin_path = ROOT / "runs" / "phase4_poc" / "snn_probe_input.npy"
    bin_path.parent.mkdir(parents=True, exist_ok=True)
    np.save(bin_path, x)

    sess = ort.InferenceSession(str(args.onnx), providers=["CPUExecutionProvider"])
    ort_out = sess.run(None, {"input": x})[0]

    scp = [
        "sshpass",
        "-p",
        "Mind@123",
        "scp",
        "-o",
        "StrictHostKeyChecking=no",
    ]
    target = f"root@{args.host}"
    for local, remote in (
        (bin_path, "/tmp/phase4_snn/snn_probe_input.npy"),
        (ROOT / "scripts" / "phase4_atlas_snn_probe.py", "/tmp/phase4_snn/phase4_atlas_snn_probe.py"),
    ):
        subprocess.run(scp + [str(local), f"{target}:{remote}"], check=True)

    proc = subprocess.run(
        [
            "sshpass",
            "-p",
            "Mind@123",
            "ssh",
            "-o",
            "StrictHostKeyChecking=no",
            target,
            "bash -lc 'source /usr/local/Ascend/ascend-toolkit/set_env.sh && "
            "export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH && "
            f"python3 /tmp/phase4_snn/phase4_atlas_snn_probe.py --model {args.om}'",
        ],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print(proc.stderr, file=sys.stderr)
        return proc.returncode

    line = next(ln for ln in proc.stdout.splitlines() if ln.strip().startswith("{"))
    payload = json.loads(line)
    atlas = np.asarray(payload["atlas_counts"], dtype=np.float32)
    diff = float(np.max(np.abs(ort_out[0] - atlas)))
    match = bool(np.allclose(ort_out[0], atlas, atol=1e-3, rtol=0))

    report = {
        "seed": args.seed,
        "ort": ort_out[0].tolist(),
        "atlas": atlas.tolist(),
        "max_abs_diff": diff,
        "aligned": match,
        "atlas_infer_ms": payload.get("infer_ms"),
    }
    out_path = ROOT / "runs" / "phase4_poc" / "snn_board_align.json"
    out_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))
    return 0 if match else 1


if __name__ == "__main__":
    raise SystemExit(main())
