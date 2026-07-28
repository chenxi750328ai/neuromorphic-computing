"""Atlas 侧客户端：fc*/lif2 本地定点；lif1 经 TCP 调 PYNQ PL（R-A A2）。

在 Atlas 上执行：
  python3 phase4_fpga_ra_atlas_mlif_client.py bundle.npz --fpga 192.168.137.3 --port 9530
"""
from __future__ import annotations

import argparse
import json
import socket
import time

import numpy as np

FRAC = 16
SCALE = 1 << FRAC
BETA_FP = int(round(0.9 * SCALE))
TH_FP = SCALE


def linear(x, w, b):
    acc = w.astype(np.int64) @ x.astype(np.int64)
    return (acc >> FRAC) + b


def lif_ps(cur, mem):
    reset = (mem >= TH_FP).astype(np.int64)
    mem = ((BETA_FP * mem) >> FRAC) + cur - reset * TH_FP
    spk = (mem >= TH_FP).astype(np.int64)
    return spk, mem


def rpc(sock: socket.socket, req: dict) -> dict:
    sock.sendall((json.dumps(req) + "\n").encode("utf-8"))
    buf = b""
    while b"\n" not in buf:
        chunk = sock.recv(65536)
        if not chunk:
            raise ConnectionError("fpga daemon closed")
        buf += chunk
    line, _ = buf.split(b"\n", 1)
    return json.loads(line.decode("utf-8"))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("npz")
    ap.add_argument("--fpga", default="192.168.137.3")
    ap.add_argument("--port", type=int, default=9530)
    ap.add_argument("--out", default="/tmp/ra_atlas_mlif_client.json")
    args = ap.parse_args()

    z = np.load(args.npz)
    w1 = z["w1_fp"].astype(np.int64)
    b1 = z["b1_fp"].astype(np.int64)
    w2 = z["w2_fp"].astype(np.int64)
    b2 = z["b2_fp"].astype(np.int64)
    xs = z["x_fp"].astype(np.int64)
    ys = z["y"].astype(np.int64)
    timesteps = int(z["timesteps"][0])
    hidden = int(w1.shape[0])

    sock = socket.create_connection((args.fpga, args.port), timeout=60.0)
    pong = rpc(sock, {"op": "ping"})
    if not pong.get("ok"):
        raise RuntimeError(pong)

    preds = []
    t_fpga_ms = 0.0
    t0 = time.perf_counter()
    for i in range(xs.shape[0]):
        x = xs[i]
        mem2 = np.zeros(w2.shape[0], dtype=np.int64)
        spk_sum = np.zeros(w2.shape[0], dtype=np.int64)
        r = rpc(sock, {"op": "reset_mem", "n": hidden})
        if not r.get("ok"):
            raise RuntimeError(r)
        for _t in range(timesteps):
            cur1 = linear(x, w1, b1)
            resp = rpc(sock, {"op": "lif1_step", "cur": [int(v) for v in cur1.tolist()]})
            if not resp.get("ok"):
                raise RuntimeError(resp)
            t_fpga_ms += float(resp.get("t_ms") or 0)
            spk1 = np.asarray(resp["spk_scaled"], dtype=np.int64)
            cur2 = linear(spk1, w2, b2)
            spk2_bit, mem2 = lif_ps(cur2, mem2)
            spk_sum += spk2_bit
        preds.append(int(np.argmax(spk_sum)))
    wall_ms = (time.perf_counter() - t0) * 1000
    sock.close()

    correct = int(np.sum(np.array(preds, dtype=np.int64) == ys))
    report = {
        "ok": True,
        "n": int(xs.shape[0]),
        "correct": correct,
        "acc_vs_label": round(correct / max(int(xs.shape[0]), 1), 4),
        "preds": preds,
        "labels": [int(v) for v in ys.tolist()],
        "wall_ms": round(wall_ms, 3),
        "fpga_lif1_ms": round(t_fpga_ms, 3),
        "avg_e2e_ms": round(wall_ms / max(int(xs.shape[0]), 1), 3),
        "avg_fpga_lif1_ms": round(t_fpga_ms / max(int(xs.shape[0]), 1), 3),
        "topology": "Atlas(fc*/lif2 Q16.16) ↔ TCP ↔ PYNQ(lif1 PL TMD)",
        "fpga": f"{args.fpga}:{args.port}",
    }
    open(args.out, "w").write(json.dumps(report) + "\n")
    print("ATLAS_MLIF_INCHAIN_OK")
    print(json.dumps(report))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
