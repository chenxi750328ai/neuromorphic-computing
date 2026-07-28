#!/usr/bin/env python3
"""Phase4.1 · R-A M-lif 向量化入链门禁 — 陈正共.

形态：现有 lif_step 单核；板侧分时扫 hidden=256；fc*/lif2 在 PS 定点；
对照 host Q16.16 pred。

  .venv/bin/python3 scripts/phase4_fpga_ra_mlif_vector_inchain.py --samples 20 --gate
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from phase4_fpga_snn_fixedpoint import (  # noqa: E402
    FixedPointSNN,
    linear_fp,
    lif_step_fp,
    to_fp,
)
from train_mnist_snn import loaders  # noqa: E402

DEFAULT_CKPT = ROOT / "runs" / "20260527T092534Z" / "checkpoint.pt"
DEFAULT_BIT = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit"
BOARD_PY = ROOT / "scripts" / "phase4_fpga_ra_mlif_vector_board.py"


def host_proxy_preds(net: FixedPointSNN, xs: np.ndarray) -> list[int]:
    preds: list[int] = []
    for i in range(xs.shape[0]):
        mem1 = np.zeros(net.w1_fp.shape[0], dtype=np.int64)
        mem2 = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
        spk_sum = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
        x_fp = xs[i]
        for _ in range(net.timesteps):
            cur1 = linear_fp(x_fp, net.w1_fp, net.b1_fp)
            spk1, _, mem1 = lif_step_fp(cur1, mem1)
            cur2 = linear_fp(spk1, net.w2_fp, net.b2_fp)
            _, spk2_bit, mem2 = lif_step_fp(cur2, mem2)
            spk_sum += spk2_bit
        preds.append(int(spk_sum.argmax()))
    return preds


def main() -> int:
    ap = argparse.ArgumentParser(description="R-A M-lif vectorized in-chain gate")
    ap.add_argument("--checkpoint", type=Path, default=DEFAULT_CKPT)
    ap.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    ap.add_argument("--samples", type=int, default=20)
    ap.add_argument("--host", default="192.168.137.3")
    ap.add_argument("--user", default="xilinx")
    ap.add_argument("--pass", dest="password", default="xilinx")
    ap.add_argument("--bit", type=Path, default=DEFAULT_BIT)
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "docs" / "phase4_poc_evidence" / "fpga_ra_mlif_vector_inchain_gate.json",
    )
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    if not args.bit.is_file() or not args.checkpoint.is_file() or not BOARD_PY.is_file():
        print("missing bit/ckpt/board script", file=sys.stderr)
        return 2

    net = FixedPointSNN.from_checkpoint(args.checkpoint)
    _, test_loader = loaders(args.data, batch_size=1)
    xs_list, ys = [], []
    for i, (data, target) in enumerate(test_loader):
        if i >= args.samples:
            break
        xs_list.append(to_fp(data.view(-1).numpy()))
        ys.append(int(target.item()))
    x_fp = np.stack(xs_list, axis=0)
    y = np.asarray(ys, dtype=np.int64)

    t_h0 = time.perf_counter()
    host_preds = host_proxy_preds(net, x_fp)
    host_ms = (time.perf_counter() - t_h0) * 1000
    host_correct = int(sum(int(p == t) for p, t in zip(host_preds, ys)))

    target = f"{args.user}@{args.host}"
    ssh = ["sshpass", "-p", args.password, "ssh", "-o", "StrictHostKeyChecking=no", target]
    scp = ["sshpass", "-p", args.password, "scp", "-o", "StrictHostKeyChecking=no"]
    remote_bit = "/tmp/lif_step_overlay.bit"
    remote_npz = "/tmp/ra_mlif_vector_bundle.npz"
    remote_py = "/tmp/phase4_fpga_ra_mlif_vector_board.py"
    remote_out = "/tmp/ra_mlif_vector_board.json"

    with tempfile.TemporaryDirectory(prefix="ra_vec_") as td:
        npz = Path(td) / "bundle.npz"
        np.savez(
            npz,
            w1_fp=net.w1_fp.astype(np.int64),
            b1_fp=net.b1_fp.astype(np.int64),
            w2_fp=net.w2_fp.astype(np.int64),
            b2_fp=net.b2_fp.astype(np.int64),
            x_fp=x_fp.astype(np.int64),
            y=y,
            timesteps=np.asarray([net.timesteps], dtype=np.int64),
        )
        # also copy hwh next to bit on remote if present
        hwh = args.bit.with_suffix(".hwh")
        subprocess.run(scp + [str(args.bit), f"{target}:{remote_bit}"], check=True)
        if hwh.is_file():
            subprocess.run(scp + [str(hwh), f"{target}:/tmp/lif_step_overlay.hwh"], check=True)
        subprocess.run(scp + [str(npz), f"{target}:{remote_npz}"], check=True)
        subprocess.run(scp + [str(BOARD_PY), f"{target}:{remote_py}"], check=True)

        remote_cmd = (
            f"echo {args.password} | sudo -S /usr/local/share/pynq-venv/bin/python3 "
            f"{remote_py} {remote_bit} {remote_npz} {remote_out}"
        )
        t0 = time.perf_counter()
        proc = subprocess.run(ssh + [remote_cmd], capture_output=True, text=True)
        wall_ssh_ms = (time.perf_counter() - t0) * 1000

    board_ok = proc.returncode == 0 and "VECTOR_INCHAIN_OK" in (proc.stdout or "")
    board: dict = {}
    if board_ok:
        for ln in (proc.stdout or "").splitlines():
            if ln.strip().startswith("{"):
                board = json.loads(ln)
                break

    board_preds = list(board.get("preds") or [])
    match = 0
    if board_preds and len(board_preds) == len(host_preds):
        match = int(sum(int(a == b) for a, b in zip(board_preds, host_preds)))
    match_rate = round(match / max(len(host_preds), 1), 4)

    report = {
        "schema": "phase4.1-fpga-ra-mlif-vector-inchain-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "route": "R-A M-lif vectorized in-chain (single-core time-mux)",
        "checkpoint": str(args.checkpoint),
        "bit": str(args.bit),
        "topology": "WSL host orchestrates; PYNQ PS=fc*/lif2 + PL=lif1 vector TMD",
        "note": (
            "向量化=整层 256 经 PL（单核分时）；入链=推理路径含 PL lif1。"
            "非并行 RTL；非 Atlas 以太网入链。"
        ),
        "host_proxy": {
            "n": len(ys),
            "correct": host_correct,
            "acc_vs_label": round(host_correct / max(len(ys), 1), 4),
            "preds": host_preds,
            "wall_ms": round(host_ms, 3),
            "avg_e2e_ms": round(host_ms / max(len(ys), 1), 3),
        },
        "board": board,
        "board_ssh": {
            "ok": board_ok,
            "returncode": proc.returncode,
            "wall_ms": round(wall_ssh_ms, 3),
            "stdout_tail": (proc.stdout or "")[-1500:],
            "stderr_tail": (proc.stderr or "")[-1500:],
        },
        "compare": {
            "pred_match": match,
            "pred_match_rate": match_rate,
        },
        "platform_available_ra_vector_inchain": bool(
            board_ok and match_rate >= 0.98 and board.get("acc_vs_label", 0) >= 0.90
        ),
        "verdict": None,
    }
    if report["platform_available_ra_vector_inchain"]:
        report["verdict"] = "PASS_vector_inchain_tmd_single_core"
    elif board_ok and match_rate >= 0.98:
        report["verdict"] = "PASS_match_but_label_acc_low"
    elif board_ok:
        report["verdict"] = "FAIL_pred_mismatch_or_acc"
    else:
        report["verdict"] = "FAIL_board_run"

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        json.dumps(
            {
                "verdict": report["verdict"],
                "match_rate": match_rate,
                "board_acc": board.get("acc_vs_label"),
                "avg_lif1_pl_ms": board.get("avg_lif1_pl_ms"),
            },
            ensure_ascii=False,
        )
    )
    print(f"wrote {args.out}")
    if args.gate:
        return 0 if report["platform_available_ra_vector_inchain"] else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
