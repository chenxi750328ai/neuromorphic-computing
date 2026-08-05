#!/usr/bin/env python3
"""Phase4.1 · R-B 分时整网跑通门禁 — 陈正共.

LIF 全层 PL 单核分时；fc 在 PYNQ PS。对照 host Q16.16 pred。
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

from phase4_fpga_snn_fixedpoint import FixedPointSNN, linear_fp, lif_step_fp, to_fp  # noqa: E402
from train_mnist_snn import loaders  # noqa: E402

DEFAULT_CKPT = ROOT / "runs" / "20260527T092534Z" / "checkpoint.pt"
DEFAULT_BIT = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit"
BOARD_PY = ROOT / "scripts" / "phase4_fpga_rb_fullnet_runthrough_board.py"


def host_preds(net: FixedPointSNN, xs: np.ndarray) -> list[int]:
    out = []
    for i in range(xs.shape[0]):
        mem1 = np.zeros(net.w1_fp.shape[0], dtype=np.int64)
        mem2 = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
        spk_sum = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
        x = xs[i]
        for _ in range(net.timesteps):
            cur1 = linear_fp(x, net.w1_fp, net.b1_fp)
            spk1, _, mem1 = lif_step_fp(cur1, mem1)
            cur2 = linear_fp(spk1, net.w2_fp, net.b2_fp)
            _, spk2_bit, mem2 = lif_step_fp(cur2, mem2)
            spk_sum += spk2_bit
        out.append(int(spk_sum.argmax()))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--checkpoint", type=Path, default=DEFAULT_CKPT)
    ap.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    ap.add_argument("--samples", type=int, default=20)
    ap.add_argument("--host", default="192.168.137.3")
    ap.add_argument("--user", default="xilinx")
    ap.add_argument("--pass", dest="password", default="", help="env PYNQ_PASS/NEURO_PYNQ_PASS")
    ap.add_argument("--bit", type=Path, default=DEFAULT_BIT)
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_runthrough_gate.json",
    )
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    net = FixedPointSNN.from_checkpoint(args.checkpoint)
    _, tl = loaders(args.data, batch_size=1)
    xs_list, ys = [], []
    for i, (data, target) in enumerate(tl):
        if i >= args.samples:
            break
        xs_list.append(to_fp(data.view(-1).numpy()))
        ys.append(int(target.item()))
    x_fp = np.stack(xs_list, axis=0)
    y = np.asarray(ys, dtype=np.int64)
    hp = host_preds(net, x_fp)

    target = f"{args.user}@{args.host}"
    ssh = ["sshpass", "-p", args.password, "ssh", "-o", "StrictHostKeyChecking=accept-new", target]
    scp = ["sshpass", "-p", args.password, "scp", "-o", "StrictHostKeyChecking=accept-new"]
    remote_bit, remote_npz = "/tmp/lif_step_overlay.bit", "/tmp/rb_fullnet_bundle.npz"
    remote_py, remote_out = "/tmp/phase4_fpga_rb_fullnet_runthrough_board.py", "/tmp/rb_fullnet_board.json"
    hwh = args.bit.with_suffix(".hwh")

    with tempfile.TemporaryDirectory(prefix="rb_fn_") as td:
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
        subprocess.run(scp + [str(args.bit), f"{target}:{remote_bit}"], check=True)
        if hwh.is_file():
            subprocess.run(scp + [str(hwh), f"{target}:/tmp/lif_step_overlay.hwh"], check=True)
        subprocess.run(scp + [str(npz), f"{target}:{remote_npz}"], check=True)
        subprocess.run(scp + [str(BOARD_PY), f"{target}:{remote_py}"], check=True)
        cmd = (
            f"echo {args.password} | sudo -S /usr/local/share/pynq-venv/bin/python3 "
            f"{remote_py} {remote_bit} {remote_npz} {remote_out}"
        )
        t0 = time.perf_counter()
        proc = subprocess.run(ssh + [cmd], capture_output=True, text=True)
        ssh_ms = (time.perf_counter() - t0) * 1000

    board_ok = proc.returncode == 0 and "RB_FULLNET_RUNTHROUGH_OK" in (proc.stdout or "")
    board: dict = {}
    if board_ok:
        for ln in (proc.stdout or "").splitlines():
            if ln.strip().startswith("{"):
                board = json.loads(ln)
                break
    bp = list(board.get("preds") or [])
    match = int(sum(int(a == b) for a, b in zip(bp, hp))) if bp else 0
    match_rate = round(match / max(len(hp), 1), 4)
    ok = bool(board_ok and match_rate >= 0.98 and float(board.get("acc_vs_label") or 0) >= 0.90)

    report = {
        "schema": "phase4.1-fpga-rb-fullnet-runthrough-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "route": "R-B time-mux fullnet runthrough",
        "checkpoint": str(args.checkpoint),
        "note": "并行资源墙仍成立；本闸证明分时整网可跑通。fc* 在 PS，LIF 全在 PL。",
        "host_proxy": {"preds": hp, "n": len(ys)},
        "board": board,
        "board_ssh": {
            "ok": board_ok,
            "returncode": proc.returncode,
            "wall_ms": round(ssh_ms, 3),
            "stderr_tail": (proc.stderr or "")[-1200:],
        },
        "compare": {"pred_match": match, "pred_match_rate": match_rate},
        "platform_runthrough_rb_tmd": ok,
        "verdict": "PASS_rb_tmd_fullnet" if ok else "FAIL_rb_tmd_fullnet",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"verdict": report["verdict"], "match_rate": match_rate, "board_acc": board.get("acc_vs_label")}, ensure_ascii=False))
    print(f"wrote {args.out}")
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
