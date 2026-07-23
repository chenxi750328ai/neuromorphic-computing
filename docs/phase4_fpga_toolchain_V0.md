# Phase4 · FPGA 开发链路 V0（通/不通标准）

> **负责人**：陈正共 · ChenZhengGong  
> **合格定义（总裁）**：类脑功能经 **FPGA 工具链** 开发并部署到 **PL** 真实运行，留下 **结果 + 规格 + 资源占用**。  
> **明确不算**：板载点灯、仅 ARM 上跑 Python 定点。  
> **进展报告**：[Phase4.1_Wave1_进展报告_20260723.md](./Phase4.1_Wave1_进展报告_20260723.md) §2

---

## 1. 链路台阶

```text
[1] HLS/RTL 源码（lif_step）
      ↓
[2] RTL/HLS 仿真 ≡ Python golden     ← 本仓可无 Vivado 完成
      ↓
[3] Vivado 综合 → utilization.rpt + .bit/.hwh
      ↓
[4] PYNQ sudo Overlay 烧 PL
      ↓
[5] 板上读 spk / 延迟 / 与 golden 对照
```

门禁：

```bash
python3 scripts/fpga_lif_rtl_sim.py --gate
source /tools/Xilinx/Vivado/*/settings64.sh   # 或已在 PATH
cd fpga/vivado && vivado -mode batch -source write_lif_bitstream.tcl
python3 scripts/phase4_fpga_pynq_lif_pl.py --gate
python3 scripts/phase4_fpga_toolchain_gate.py --gate   # 须 chain_full_pl_ok
```

---

## 2. 本机现状（2026-07-23 更新）

| 台阶 | 状态 |
|------|------|
| HLS `fpga/hls/lif_step.cpp` | ✅ |
| RTL `fpga/rtl/lif_step.v` + `lif_step_axi_lite.v` | ✅ |
| Vivado TCL | ✅ `create_lif_overlay.tcl`（利用率）· **`write_lif_bitstream.tcl`（出 bit）** |
| RTL 语义 ≡ golden | ✅ |
| PYNQ ping/ssh + sudo Overlay | ✅ |
| **vivado 可执行** | ✅ `/tools/Xilinx/Vivado/2023.2` |
| `fpga/bitstreams/lif_step_overlay.bit` + `.hwh` | ✅ **2026-07-23 产出** |
| 资源报告 LUT/BRAM/DSP | ✅ 核单独 synth + overlay place 两份 |
| 板上 LIF MMIO + golden 一致 | ✅ `fpga_lif_pl_run.json` · `golden_match=true` |
| `chain_full_pl_ok` | ✅ **true**（`fpga_toolchain_gate.json`） |

**结论**：E4「类脑算子上 PL」开发链路 **已闭环**。仍 **不是** 全网分类上 FPGA，也 **不是** 产品低功耗证明。

---

## 3. 产物目录约定

| 路径 | 含义 |
|------|------|
| `fpga/bitstreams/lif_step_overlay.bit` | 可烧 PL |
| `fpga/bitstreams/lif_step_overlay.hwh` | PYNQ 解析 |
| `fpga/bitstreams/lif_step_utilization.rpt` | 核单独综合利用率 |
| `fpga/bitstreams/lif_step_overlay_utilization_placed.rpt` | 完整 overlay place 利用率 |
| `runs/phase4_poc/fpga_lif_pl_run.json` | 板上延迟与脉冲 |
| `runs/phase4_poc/fpga_toolchain_gate.json` | 门禁 |

---

## 4. 资源摘要（2026-07-23）

| 范围 | LUT | FF | BRAM | DSP |
|------|-----|----|------|-----|
| `lif_step_axi_lite` synth-only | 379 (0.71%) | 204 | 0 | 0 |
| `design_1_wrapper` placed | 737 (1.39%) | 663 | 0 | 0 |

*陈正共 · ChenZhengGong*
