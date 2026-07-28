"""PYNQ · lif1 向量分时 TCP 服务（R-A Atlas↔FPGA 入链）— 陈正共.

协议（JSON 一行一个请求，响应一行 JSON）：
  {"op":"ping"} -> {"ok":true,"pong":true}
  {"op":"load_overlay","bit":"/tmp/lif_step_overlay.bit"}
  {"op":"reset_mem","n":256}
  {"op":"lif1_step","cur":[int,...]} -> {"ok":true,"spk_scaled":[int,...],"t_ms":...}

环境：须 root/sudo + PYNQ venv；默认监听 0.0.0.0:9530。
"""
from __future__ import annotations

import argparse
import json
import os
import socket
import sys
import time

os.environ.setdefault("XILINX_XRT", "/usr")

FRAC = 16
SCALE = 1 << FRAC


def u32(v: int) -> int:
    return int(v) & 0xFFFFFFFF


def s32(v: int) -> int:
    v = int(v) & 0xFFFFFFFF
    return v - 0x100000000 if v >= 0x80000000 else v


class Lif1Engine:
    def __init__(self) -> None:
        self.drv = None
        self.mem = None

    def load(self, bit: str) -> None:
        from pynq import Overlay

        ol = Overlay(bit)
        self.drv = ol.lif_step_0

    def reset(self, n: int) -> None:
        import numpy as np

        self.mem = np.zeros(int(n), dtype=np.int64)

    def lif_pl(self, cur: int, mem: int):
        drv = self.drv
        drv.write(0x04, u32(cur))
        drv.write(0x08, u32(mem))
        drv.write(0x00, 1)
        st = 0
        for _ in range(20000):
            st = drv.read(0x0C)
            if st & 1:
                break
        return (st >> 1) & 1, s32(drv.read(0x10))

    def step(self, cur_list: list) -> tuple[list, float]:
        if self.drv is None or self.mem is None:
            raise RuntimeError("overlay/mem not ready")
        if len(cur_list) != len(self.mem):
            raise ValueError(f"cur len {len(cur_list)} != mem {len(self.mem)}")
        t0 = time.perf_counter()
        spk_scaled = []
        for j, c in enumerate(cur_list):
            spk, mem_o = self.lif_pl(int(c), int(self.mem[j]))
            self.mem[j] = mem_o
            spk_scaled.append(int(spk * SCALE))
        return spk_scaled, (time.perf_counter() - t0) * 1000


def handle(eng: Lif1Engine, req: dict) -> dict:
    op = req.get("op")
    if op == "ping":
        return {"ok": True, "pong": True}
    if op == "load_overlay":
        eng.load(str(req.get("bit") or "/tmp/lif_step_overlay.bit"))
        return {"ok": True, "loaded": True}
    if op == "reset_mem":
        eng.reset(int(req.get("n") or 256))
        return {"ok": True, "n": len(eng.mem)}
    if op == "lif1_step":
        spk, t_ms = eng.step(list(req["cur"]))
        return {"ok": True, "spk_scaled": spk, "t_ms": round(t_ms, 3)}
    return {"ok": False, "error": f"unknown op {op}"}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--bind", default="0.0.0.0")
    ap.add_argument("--port", type=int, default=9530)
    ap.add_argument("--bit", default="/tmp/lif_step_overlay.bit")
    ap.add_argument("--autoload", action="store_true")
    args = ap.parse_args()

    eng = Lif1Engine()
    if args.autoload:
        eng.load(args.bit)
        eng.reset(256)

    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind((args.bind, args.port))
    srv.listen(4)
    print(f"LIF1_DAEMON_LISTEN {args.bind}:{args.port}", flush=True)

    while True:
        conn, addr = srv.accept()
        with conn:
            buf = b""
            while True:
                chunk = conn.recv(65536)
                if not chunk:
                    break
                buf += chunk
                while b"\n" in buf:
                    line, buf = buf.split(b"\n", 1)
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        req = json.loads(line.decode("utf-8"))
                        resp = handle(eng, req)
                    except Exception as e:  # noqa: BLE001
                        resp = {"ok": False, "error": str(e)}
                    conn.sendall((json.dumps(resp) + "\n").encode("utf-8"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
