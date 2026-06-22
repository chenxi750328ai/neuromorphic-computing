#!/usr/bin/env python3
"""Tri-compare: ONNXRuntime vs Atlas OM vs fixed-point FPGA reference."""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

import numpy as np
import onnxruntime as ort

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from phase4_fpga_snn_fixedpoint import FixedPointSNN, to_fp  # noqa: E402


def main() -> int:
    p = argparse.ArgumentParser(description="ORT / Atlas / fixed-point tri-compare")
    p.add_argument("--onnx", type=Path, default=ROOT / "runs" / "phase4_export" / "model_snn.onnx")
    p.add_argument("--checkpoint", type=Path, default=ROOT / "runs" / "20260527T092534Z" / "checkpoint.pt")
    p.add_argument("--host", default="192.168.137.2")
    p.add_argument("--om", default="/tmp/phase4_snn/mnist_snn.om")
    p.add_argument("--atlas-pass", default="Mind@123")
    p.add_argument("--samples", type=int, default=8)
    p.add_argument("--seed", type=int, default=7)
    p.add_argument("--skip-atlas", action="store_true")
    p.add_argument("--out", type=Path, default=ROOT / "runs" / "phase4_poc" / "fpga_tri_compare.json")
    args = p.parse_args()

    rng = np.random.default_rng(args.seed)
    xs = rng.standard_normal((args.samples, 1, 28, 28), dtype=np.float32) * 0.3
    xs = np.ascontiguousarray(xs)

    sess = ort.InferenceSession(str(args.onnx), providers=["CPUExecutionProvider"])
    ort_out = sess.run(None, {"input": xs})[0]

    fp_net = FixedPointSNN.from_checkpoint(args.checkpoint)
    fp_out = np.zeros((args.samples, 10), dtype=np.float64)
    for i in range(args.samples):
        fp_out[i] = fp_net.forward(to_fp(xs[i].reshape(-1)))

    atlas_out = None
    atlas_ms = None
    if not args.skip_atlas:
        poc_dir = ROOT / "runs" / "phase4_poc"
        poc_dir.mkdir(parents=True, exist_ok=True)
        batch_path = poc_dir / "tri_compare_inputs.npy"
        np.save(batch_path, xs)

        scp_base = ["sshpass", "-p", args.atlas_pass, "scp", "-o", "StrictHostKeyChecking=no"]
        target = f"root@{args.host}"
        subprocess.run(scp_base + [str(batch_path), f"{target}:/tmp/phase4_snn/tri_compare_inputs.npy"], check=True)
        subprocess.run(
            scp_base + [str(ROOT / "scripts" / "phase4_atlas_snn_probe.py"), f"{target}:/tmp/phase4_snn/phase4_atlas_snn_probe.py"],
            check=True,
        )

        proc = subprocess.run(
            [
                "sshpass",
                "-p",
                args.atlas_pass,
                "ssh",
                "-o",
                "StrictHostKeyChecking=no",
                target,
                "bash -lc 'source /usr/local/Ascend/ascend-toolkit/set_env.sh && "
                "export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH && "
                f"python3 /tmp/phase4_snn/phase4_atlas_snn_probe.py --model {args.om} "
                "--input /tmp/phase4_snn/tri_compare_inputs.npy --batch'",
            ],
            capture_output=True,
            text=True,
        )
        if proc.returncode != 0:
            print(proc.stderr, file=sys.stderr)
            return proc.returncode
        line = next(ln for ln in proc.stdout.splitlines() if ln.strip().startswith("{"))
        payload_atlas = json.loads(line)
        raw = payload_atlas["atlas_counts"]
        if isinstance(raw[0], list):
            atlas_out = np.asarray(raw, dtype=np.float32)
        else:
            atlas_out = np.asarray([raw], dtype=np.float32)
        atlas_ms = payload_atlas.get("infer_ms")

    per_sample = []
    for i in range(args.samples):
        row = {
            "i": i,
            "ort": ort_out[i].tolist(),
            "fixed": fp_out[i].astype(int).tolist(),
            "ort_pred": int(ort_out[i].argmax()),
            "fixed_pred": int(fp_out[i].argmax()),
            "ort_vs_fixed_max_diff": float(np.max(np.abs(ort_out[i] - fp_out[i]))),
            "ort_vs_fixed_pred_match": bool(ort_out[i].argmax() == fp_out[i].argmax()),
        }
        if atlas_out is not None:
            row["atlas"] = atlas_out[i].tolist()
            row["atlas_pred"] = int(atlas_out[i].argmax())
            row["ort_vs_atlas_max_diff"] = float(np.max(np.abs(ort_out[i] - atlas_out[i])))
            row["fixed_vs_atlas_max_diff"] = float(np.max(np.abs(fp_out[i] - atlas_out[i])))
            row["atlas_vs_ort_aligned"] = bool(np.allclose(ort_out[i], atlas_out[i], atol=1e-3, rtol=0))
        per_sample.append(row)

    summary = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "samples": args.samples,
        "seed": args.seed,
        "ort_vs_fixed_pred_match_rate": float(np.mean([r["ort_vs_fixed_pred_match"] for r in per_sample])),
        "atlas_infer_ms": atlas_ms,
    }
    if atlas_out is not None:
        summary["ort_vs_atlas_aligned_rate"] = float(
            np.mean([r["ort_vs_atlas_max_diff"] < 1e-3 for r in per_sample])
        )
        summary["fixed_vs_atlas_pred_match_rate"] = float(
            np.mean([r["fixed_pred"] == r["atlas_pred"] for r in per_sample])
        )

    report = {"summary": summary, "per_sample": per_sample}
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(summary, indent=2))
    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
