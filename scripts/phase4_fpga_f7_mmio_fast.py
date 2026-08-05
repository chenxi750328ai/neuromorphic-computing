"""F7 Phase4.2 · 快速 MMIO 辅助（少 Python 开销 / 紧轮询）.

在现有 linear_mac + lif_step overlay 上软件侧优化；不替代 DMA/PL 调度 RTL。
"""
from __future__ import annotations

from typing import Protocol


def u32(v: int) -> int:
    return int(v) & 0xFFFFFFFF


def s32(v: int) -> int:
    v = int(v) & 0xFFFFFFFF
    return v - 0x100000000 if v >= 0x80000000 else v


class MmioLike(Protocol):
    def write(self, offset: int, value: int) -> None: ...
    def read(self, offset: int) -> int: ...


# AXI-Lite reg offsets (linear_mac_axi_lite / lif_step_axi_lite)
MAC_OFF_START = 0x00
MAC_OFF_DIM = 0x04
MAC_OFF_W = 0x08
MAC_OFF_X = 0x0C
MAC_OFF_BIAS = 0x10
MAC_OFF_DONE = 0x14
MAC_OFF_RESULT = 0x18

LIF_OFF_START = 0x00
LIF_OFF_CUR = 0x04
LIF_OFF_MEM = 0x08
LIF_OFF_STATUS = 0x0C
LIF_OFF_MEM_OUT = 0x10


def mac_pl_fast(mac: MmioLike, w_row, x_vec, bias: int, *, poll_max: int = 8000) -> int:
    """Single-neuron MAC via MMIO; w_row/x_vec are indexable int sequences."""
    dim = len(w_row)
    w = mac.write
    r = mac.read
    w(MAC_OFF_DIM, dim)
    w(MAC_OFF_BIAS, u32(bias))
    w(MAC_OFF_START, 1)
    wr_w, wr_x = MAC_OFF_W, MAC_OFF_X
    for i in range(dim):
        w(wr_w, u32(int(w_row[i])))
        w(wr_x, u32(int(x_vec[i])))
    for _ in range(poll_max):
        if r(MAC_OFF_DONE) & 1:
            break
    return s32(r(MAC_OFF_RESULT))


def lif_pl_fast(lif: MmioLike, cur: int, mem: int, *, poll_max: int = 4000) -> tuple[int, int]:
    w = lif.write
    r = lif.read
    w(LIF_OFF_CUR, u32(cur))
    w(LIF_OFF_MEM, u32(mem))
    w(LIF_OFF_START, 1)
    st = 0
    for _ in range(poll_max):
        st = r(LIF_OFF_STATUS)
        if st & 1:
            break
    spk = (st >> 1) & 1
    return spk, s32(r(LIF_OFF_MEM_OUT))
