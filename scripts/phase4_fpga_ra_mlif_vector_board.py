"""PYNQ 板侧：M-lif 向量化入链（lif1 单核分时扫整层）。由 host 门禁 SCP 后执行。"""
import json
import os
import sys
import time

import numpy as np

os.environ["XILINX_XRT"] = "/usr"
from pynq import Overlay  # noqa: E402

FRAC = 16
SCALE = 1 << FRAC
BETA_FP = int(round(0.9 * SCALE))
TH_FP = SCALE


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

    ol = Overlay(bit)
    drv = ol.lif_step_0

    def lif_pl(cur: int, mem: int):
        drv.write(0x04, u32(cur))
        drv.write(0x08, u32(mem))
        drv.write(0x00, 1)
        st = 0
        for _ in range(20000):
            st = drv.read(0x0C)
            if st & 1:
                break
        spk = (st >> 1) & 1
        return spk, s32(drv.read(0x10))

    def linear(x, w, b):
        acc = w.astype(np.int64) @ x.astype(np.int64)
        return (acc >> FRAC) + b

    def lif_ps(cur, mem):
        reset = (mem >= TH_FP).astype(np.int64)
        mem = ((BETA_FP * mem) >> FRAC) + cur - reset * TH_FP
        spk = (mem >= TH_FP).astype(np.int64)
        return spk, mem

    preds = []
    t_lif_ms = 0.0
    t0 = time.perf_counter()
    n_lif_calls = 0
    for i in range(xs.shape[0]):
        x = xs[i]
        mem1 = np.zeros(hidden, dtype=np.int64)
        mem2 = np.zeros(w2.shape[0], dtype=np.int64)
        spk_sum = np.zeros(w2.shape[0], dtype=np.int64)
        for _t in range(timesteps):
            cur1 = linear(x, w1, b1)
            spk1 = np.zeros(hidden, dtype=np.int64)
            t_a = time.perf_counter()
            for j in range(hidden):
                spk, mem1[j] = lif_pl(int(cur1[j]), int(mem1[j]))
                spk1[j] = spk * SCALE
                n_lif_calls += 1
            t_lif_ms += (time.perf_counter() - t_a) * 1000
            cur2 = linear(spk1, w2, b2)
            spk2_bit, mem2 = lif_ps(cur2, mem2)
            spk_sum += spk2_bit
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
        "lif1_pl_ms": round(t_lif_ms, 3),
        "avg_e2e_ms": round(wall_ms / max(int(xs.shape[0]), 1), 3),
        "avg_lif1_pl_ms": round(t_lif_ms / max(int(xs.shape[0]), 1), 3),
        "n_lif_pl_calls": int(n_lif_calls),
        "split": "M-lif vector: lif1 time-mux on PL single core; fc*/lif2 on PS Q16.16",
    }
    Path = __import__("pathlib").Path
    Path(out_json).write_text(json.dumps(report) + "\n", encoding="utf-8")
    print("VECTOR_INCHAIN_OK")
    print(json.dumps(report))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
