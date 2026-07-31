#!/usr/bin/env python3
"""Phase4.1 · R-A A2：Atlas↔PYNQ M-lif 入链门禁 — 陈正共.

部署：PYNQ lif1 TCP daemon:9530；Atlas 跑定点 fc*/lif2 + RPC lif1。
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
DAEMON_PY = ROOT / "scripts" / "phase4_fpga_pynq_lif1_daemon.py"
CLIENT_PY = ROOT / "scripts" / "phase4_fpga_ra_atlas_mlif_client.py"


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


def ssh_base(user: str, host: str, password: str) -> list[str]:
    return ["sshpass", "-p", password, "ssh", "-o", "StrictHostKeyChecking=no", f"{user}@{host}"]


def scp_base(password: str) -> list[str]:
    return ["sshpass", "-p", password, "scp", "-o", "StrictHostKeyChecking=no"]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--checkpoint", type=Path, default=DEFAULT_CKPT)
    ap.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    ap.add_argument("--samples", type=int, default=10)
    ap.add_argument("--pynq", default="192.168.137.3")
    ap.add_argument("--pynq-user", default="xilinx")
    ap.add_argument("--pynq-pass", default="xilinx")
    ap.add_argument("--atlas", default="192.168.137.2")
    ap.add_argument("--atlas-user", default="root")
    ap.add_argument("--atlas-pass", default="Mind@123")
    ap.add_argument("--bit", type=Path, default=DEFAULT_BIT)
    ap.add_argument("--fpga-port", type=int, default=9530)
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "docs" / "phase4_poc_evidence" / "fpga_ra_atlas_mlif_inchain_gate.json",
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

    pynq = f"{args.pynq_user}@{args.pynq}"
    atlas = f"{args.atlas_user}@{args.atlas}"
    scp = scp_base(args.pynq_pass)
    scp_a = scp_base(args.atlas_pass)
    ssh_p = ssh_base(args.pynq_user, args.pynq, args.pynq_pass)
    ssh_a = ssh_base(args.atlas_user, args.atlas, args.atlas_pass)

    remote_bit = "/tmp/lif_step_overlay.bit"
    remote_daemon = "/tmp/phase4_fpga_pynq_lif1_daemon.py"
    hwh = args.bit.with_suffix(".hwh")

    # deploy bit + daemon to PYNQ
    subprocess.run(scp + [str(args.bit), f"{pynq}:{remote_bit}"], check=True)
    if hwh.is_file():
        subprocess.run(scp + [str(hwh), f"{pynq}:/tmp/lif_step_overlay.hwh"], check=True)
    subprocess.run(scp + [str(DAEMON_PY), f"{pynq}:{remote_daemon}"], check=True)

    # kill old daemon; start new
    subprocess.run(ssh_p + ["echo", args.pynq_pass, "|", "sudo", "-S", "pkill", "-f", "phase4_fpga_pynq_lif1_daemon.py"], check=False)
    # simpler:
    subprocess.run(
        ssh_p
        + [
            f"echo {args.pynq_pass} | sudo -S pkill -f phase4_fpga_pynq_lif1_daemon.py || true"
        ],
        check=False,
    )
    start_cmd = (
        f"echo {args.pynq_pass} | sudo -S bash -c '"
        f"nohup /usr/local/share/pynq-venv/bin/python3 {remote_daemon} "
        f"--port {args.fpga_port} --bit {remote_bit} --autoload "
        f">/tmp/lif1_daemon.log 2>&1 &'"
    )
    subprocess.run(ssh_p + [start_cmd], check=True)
    time.sleep(4)
    # wait for listen
    for _ in range(15):
        chk = subprocess.run(
            ssh_p + [f"grep -q LIF1_DAEMON_LISTEN /tmp/lif1_daemon.log && echo READY"],
            capture_output=True,
            text=True,
        )
        if "READY" in (chk.stdout or ""):
            break
        time.sleep(1)

    with tempfile.TemporaryDirectory(prefix="a2_") as td:
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
        remote_npz = "/tmp/ra_atlas_mlif_bundle.npz"
        remote_client = "/tmp/phase4_fpga_ra_atlas_mlif_client.py"
        remote_out = "/tmp/ra_atlas_mlif_client.json"
        subprocess.run(scp_a + [str(npz), f"{atlas}:{remote_npz}"], check=True)
        subprocess.run(scp_a + [str(CLIENT_PY), f"{atlas}:{remote_client}"], check=True)
        t0 = time.perf_counter()
        proc = subprocess.run(
            ssh_a
            + [
                f"python3 {remote_client} {remote_npz} --fpga {args.pynq} --port {args.fpga_port} --out {remote_out}"
            ],
            capture_output=True,
            text=True,
        )
        wall = (time.perf_counter() - t0) * 1000

    atlas_ok = proc.returncode == 0 and "ATLAS_MLIF_INCHAIN_OK" in (proc.stdout or "")
    board: dict = {}
    if atlas_ok:
        for ln in (proc.stdout or "").splitlines():
            if ln.strip().startswith("{"):
                board = json.loads(ln)
                break
    bp = list(board.get("preds") or [])
    match = int(sum(int(a == b) for a, b in zip(bp, hp))) if bp else 0
    match_rate = round(match / max(len(hp), 1), 4)
    ok = bool(atlas_ok and match_rate >= 0.98 and float(board.get("acc_vs_label") or 0) >= 0.90)

    report = {
        "schema": "phase4.1-fpga-ra-atlas-mlif-inchain-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "route": "R-A A2 Atlas↔PYNQ M-lif",
        "checkpoint": str(args.checkpoint),
        "topology": "Atlas Q16.16 fc*/lif2 ↔ TCP:9530 ↔ PYNQ lif1 PL TMD",
        "host_proxy": {"preds": hp, "n": len(ys)},
        "atlas_client": board,
        "atlas_ssh": {
            "ok": atlas_ok,
            "returncode": proc.returncode,
            "wall_ms": round(wall, 3),
            "stdout_tail": (proc.stdout or "")[-1500:],
            "stderr_tail": (proc.stderr or "")[-1500:],
        },
        "compare": {"pred_match": match, "pred_match_rate": match_rate},
        "platform_runthrough_ra_atlas_fpga": ok,
        "verdict": "PASS_ra_atlas_fpga_mlif" if ok else "FAIL_ra_atlas_fpga_mlif",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"verdict": report["verdict"], "match_rate": match_rate, "acc": board.get("acc_vs_label")}, ensure_ascii=False))
    print(f"wrote {args.out}")
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
