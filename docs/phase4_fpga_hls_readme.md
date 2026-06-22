# Phase4 · FPGA HLS 参考核

> **状态**：源码就绪 · 本机 WSL **未装** Vitis HLS，需在装 Vivado/Vitis 的机器上综合  
> **目标器件**：PYNQ-Z2 → `xc7z020clg400-1`

---

## 1. 文件

| 文件 | 说明 |
|------|------|
| `fpga/hls/lif_step.cpp` | 单神经元 LIF 一步（Q16.16，`ap_fixed`） |
| `fpga/hls/run_lif_step.tcl` | 一键 C 仿真 + 综合（模板） |

与 Python 参考对齐：

- `scripts/phase4_fpga_lif_fixedpoint.py` — 软件 golden
- `scripts/phase4_fpga_snn_fixedpoint.py` — 全网络定点参考

---

## 2. 在装有 Vitis 的机器上运行

```bash
cd neuromorphic-computing/fpga/hls
vitis_hls -f run_lif_step.tcl
```

产物（默认）：`lif_step/solution1/syn/verilog/` → 可打包进 Vivado block design。

---

## 3. 接入 PYNQ 主链（v1+）

```
lif_step.cpp (HLS IP)
  → AXI-Lite 寄存器 / AXI-Stream 脉冲
  → Vivado 打包 bitstream
  → PYNQ Overlay("lif_accum.bit")
  → Python 喂电流序列，读 spk_out
```

与 Atlas 对照：同一输入的 `spk_sum` 与 `fpga_tri_compare.json` 中 fixed 列比对（WARN 级）。

---

## 4. 创新点落点

| 阶段 | 内容 |
|------|------|
| 现在 | C++ LIF 核 + Python 定点全网络 reference |
| 下一步 | HLS 综合上 PL，板上硬脉冲输出 |
| 再下一步 | fc 乘加 IP + 稀疏事件调度 |

---

*陈正共 · ChenZhengGong*
