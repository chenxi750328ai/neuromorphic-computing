#!/usr/bin/env python3
"""F7 · PL fc+LIF 整网前向 — PYNQ 板侧（陈正飞 · WO-DEV-NEURO-F7-PL-FC）.

PS 仅 load_dma_orchestrate：装权重/图、kick start、读 pred。
fc* 与 LIF 均在 PL（MMIO linear_mac_0 + lif_step_0）；禁止 PS numpy fc。
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

os.environ["XILINX_XRT"] = "/usr"
from pynq import Overlay  # noqa: E402

FRAC = 16
SCALE = 1 << FRAC


def u32(v: int) -> int:
    return int(v) & 0xFFFFFFFF


def s32(v: int) -> int:
    v = int(v) & 0xFFFFFFFF
    return v - 0x100000000 if v >= 0x80000000 else v


def main() -> int:
    bit, npz_path, out_json = sys.argv[1], sys.argv[2], sys.argv[3]
    z = np.load(npz_path)
    w1 = z["w1_fp"].astype(np.int64)
    b1 = z["b1_fp"].astype(np.int64)
    w2 = z["w2_fp"].astype(np.int64)
    b2 = z["b2_fp"].astype(np.int64)
    xs = z["x_fp"].astype(np.int64)
    ys = z["y"].astype(np.int64)
    timesteps = int(z["timesteps"][0])
    hidden = int(w1.shape[0])
    n_out = int(w2.shape[0])
    in_dim = int(w1.shape[1])

    ol = Overlay(bit)
    if not hasattr(ol, "lif_step_0"):
        print(json.dumps({"ok": False, "error": "missing lif_step_0 IP"}))
        return 2
    lif_drv = ol.lif_step_0
    mac_drv = getattr(ol, "linear_mac_0", None)
    fc_on_pl = mac_drv is not None
    if not fc_on_pl:
        print(json.dumps({"ok": False, "error": "missing linear_mac_0 IP — fc_on_pl=false"}))
        return 2

    def lif_pl(cur: int, mem: int) -> tuple[int, int]:
        lif_drv.write(0x04, u32(cur))
        lif_drv.write(0x08, u32(mem))
        lif_drv.write(0x00, 1)
        for _ in range(20000):
            st = lif_drv.read(0x0C)
            if st & 1:
                break
        spk = (st >> 1) & 1
        return spk, s32(lif_drv.read(0x10))

    def mac_pl(w_row: np.ndarray, x_vec: np.ndarray, bias: int) -> int:
        dim = int(w_row.shape[0])
        mac_drv.write(0x04, dim)
        mac_drv.write(0x10, u32(bias))
        for i in range(dim):
            mac_drv.write(0x08, u32(int(w_row[i])))
            mac_drv.write(0x0C, u32(int(x_vec[i])))
        mac_drv.write(0x00, 1)
        for _ in range(500000):
            if mac_drv.read(0x14) & 1:
                break
        return s32(mac_drv.read(0x18))

    preds: list[int] = []
    t_fc_ms = 0.0
    t_lif_ms = 0.0
    n_mac_calls = 0
    n_lif_calls = 0
    t0 = time.perf_counter()
    for i in range(xs.shape[0]):
        x = xs[i]
        mem1 = np.zeros(hidden, dtype=np.int64)
        mem2 = np.zeros(n_out, dtype=np.int64)
        spk_sum = np.zeros(n_out, dtype=np.int64)
        for _t in range(timesteps):
            spk1 = np.zeros(hidden, dtype=np.int64)
            t_a = time.perf_counter()
            for j in range(hidden):
                cur1 = mac_pl(w1[j], x, int(b1[j]))
                n_mac_calls += 1
                spk, mem1[j] = lif_pl(int(cur1), int(mem1[j]))
                spk1[j] = spk * SCALE
                n_lif_calls += 1
            t_fc_ms += (time.perf_counter() - t_a) * 1000
            t_b = time.perf_counter()
            for k in range(n_out):
                cur2 = mac_pl(w2[k], spk1, int(b2[k]))
                n_mac_calls += 1
                spk, mem2[k] = lif_pl(int(cur2), int(mem2[k]))
                spk_sum[k] += spk
                n_lif_calls += 1
            t_lif_ms += (time.perf_counter() - t_b) * 1000
        preds.append(int(np.argmax(spk_sum)))

    wall_ms = (time.perf_counter() - t0) * 1000
    correct = int(np.sum(np.array(preds, dtype=np.int64) == ys))
    report = {
        "ok": True,
        "n": int(xs.shape[0]),
        "correct": correct,
        "acc_vs_label": round(correct / max(int(xs.shape[0]), 1), 4),
        "preds": preds,
        "labels": [int(v) for v in ys.tolist()],
        "wall_ms": round(wall_ms, 3),
        "fc_pl_ms": round(t_fc_ms, 3),
        "lif_pl_ms": round(t_lif_ms, 3),
        "n_mac_pl_calls": int(n_mac_calls),
        "n_lif_pl_calls": int(n_lif_calls),
        "fc_on_pl": True,
        "lif_on_pl": True,
        "ps_role": "load_dma_orchestrate",
        "split": "F7 fullnet: fc*+LIF on PL time-mux; PS load/orchestrate only",
        "in_dim": in_dim,
        "hidden": hidden,
        "n_out": n_out,
    }
    from pathlib import Path

    Path(out_json).write_text(json.dumps(report) + "\n", encoding="utf-8")
    print("F7_FULLNET_PL_FC_OK")
    print(json.dumps(report))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
