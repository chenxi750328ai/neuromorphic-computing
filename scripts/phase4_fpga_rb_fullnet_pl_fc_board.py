#!/usr/bin/env python3
"""F7 · PL fc+LIF 整网前向 — PYNQ 板侧（陈正飞 · WO-DEV-NEURO-F7-PL-FC / Phase4.2 perf）.

PS 仅 load_dma_orchestrate：装权重/图、kick start、读 pred。
fc* 与 LIF 均在 PL（MMIO linear_mac_0 + lif_step_0）；禁止 PS numpy fc。
Phase4.2：软件侧 fast MMIO（紧轮询 / 本地引用）；RTL DMA 调度另账。
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

os.environ["XILINX_XRT"] = "/usr"
from pynq import MMIO, Overlay  # noqa: E402

from phase4_fpga_f7_mmio_fast import lif_pl_fast, mac_pl_fast, s32, u32  # noqa: E402

FRAC = 16
SCALE = 1 << FRAC
MAC_BASE = 0x40001000
LIF_BASE = 0x40000000


class _MmioRegs:
    def __init__(self, base: int, span: int = 0x1000) -> None:
        self._m = MMIO(base, span)

    def write(self, off: int, val: int) -> None:
        self._m.write(off, u32(val))

    def read(self, off: int) -> int:
        return int(self._m.read(off))


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
    lif_drv = getattr(ol, "lif_step_0", None) or _MmioRegs(LIF_BASE)
    mac_drv = getattr(ol, "linear_mac_0", None)
    mac_via = "ip_dict"
    if mac_drv is None:
        # Probe PL: write/read DIM @ +0x04
        probe = _MmioRegs(MAC_BASE)
        probe.write(0x04, 0xA5)
        if probe.read(0x04) != 0xA5:
            print(json.dumps({"ok": False, "error": "missing linear_mac_0 IP — fc_on_pl=false"}))
            return 2
        mac_drv = probe
        mac_via = "mmio_0x40001000"
    fc_on_pl = True
    # Pre-bind for inner loops (Phase4.2 fast path — same overlay, less Python overhead)
    w1_rows = [w1[j] for j in range(hidden)]
    w2_rows = [w2[k] for k in range(n_out)]
    b1_i = [int(b1[j]) for j in range(hidden)]
    b2_i = [int(b2[k]) for k in range(n_out)]

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
                cur1 = mac_pl_fast(mac_drv, w1_rows[j], x, b1_i[j])
                n_mac_calls += 1
                spk, mem1[j] = lif_pl_fast(lif_drv, int(cur1), int(mem1[j]))
                spk1[j] = spk * SCALE
                n_lif_calls += 1
            t_fc_ms += (time.perf_counter() - t_a) * 1000
            t_b = time.perf_counter()
            for k in range(n_out):
                cur2 = mac_pl_fast(mac_drv, w2_rows[k], spk1, b2_i[k])
                n_mac_calls += 1
                spk, mem2[k] = lif_pl_fast(lif_drv, int(cur2), int(mem2[k]))
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
        "mac_access": mac_via,
        "ps_role": "load_dma_orchestrate",
        "split": "F7 fullnet: fc*+LIF on PL time-mux; PS load/orchestrate only",
        "in_dim": in_dim,
        "hidden": hidden,
        "n_out": n_out,
        "optimizations_applied": [
            "phase4.2_fast_mmio_helpers",
            "tighter_done_polling",
            "prebound_weight_rows",
        ],
        "perf_note": "Phase4.2 software MMIO trim; ≤100ms needs PL layer scheduler + DMA overlay",
    }
    from pathlib import Path

    Path(out_json).write_text(json.dumps(report) + "\n", encoding="utf-8")
    print("F7_FULLNET_PL_FC_OK")
    print(json.dumps(report))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
