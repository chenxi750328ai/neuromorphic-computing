---
name: neuro-fpga-dev
description: >-
  类脑仓 FPGA 开发主链（写源码→仿真→检视→综合→出bit→上板→实测）与工具/门禁纪律。
  Use when 改 fpga/rtl、openXC7、Vivado bit、PYNQ 上板、Verilator、F6/S0–S2、
  或汇报 FPGA 进展时。
---

# 类脑 · FPGA 开发（neuro-fpga-dev）

**身份**：陈正共 · ChenZhengGong（commit 须含该署名）  
**流程真源**：`neuromorphic-computing/docs/FPGA_开发流程与工具一览_V0.md`  
**策略真源**：`docs/FPGA_工具链安全可控策略_V0.md`

## 何时用本 skill

- 写/改 `fpga/rtl/**`、`fpga/openxc7_try/**`、`fpga/vivado/**`
- 跑仿真、综合、出 bit、上板、Atlas↔FPGA 入链
- 向总裁/用户**按阶段**汇报 FPGA 进展（禁止只报「开源试了一下」）

## 主链八阶段（汇报必须用这张表）

| # | 阶段 | 主工具 | 门禁（优先） |
|---|------|--------|--------------|
| A | 写源码 | git + `fpga/rtl` | feature 分支 |
| B | 定点金标 | `phase4_fpga_lif_fixedpoint.py` | 随 C/H |
| C | 仿真 | **Verilator** | `phase4_fpga_lif_verilator_gate.py --gate` |
| D | 检视 | RTL-CR md | `docs/phase4_poc_evidence/ipd/F6-RTL-CR-*.md` |
| E | 综合 | Yosys；Vivado 辅 | `phase4_fpga_s1_impl_chain_gate.py --gate` |
| F | 出 bit | openXC7 或 Vivado batch | `phase4_fpga_z2_openxc7_try.py --gate` / vivado TCL |
| G | 上板 | PYNQ Bitstream | `phase4_fpga_z2_openxc7_board_load.py --gate` |
| H | 实测 | daemon + host gate | `phase4_fpga_ra_atlas_mlif_inchain_gate.py --gate` 等 |

**信任顺序**：C/D → H/金标 → Vivado 辅。禁止 Vivado 单独充当「已验证」。

## 双轨（勿混结论）

| 轨 | 用途 | 诚实边界 |
|----|------|----------|
| 开源轨 openXC7 | 主权/smoke；blinky F+G 已通 | **CARRY P&R 仍 FAIL** → 不得宣称 `lif_step` 开源可实现 |
| 辅证轨 Vivado 2023.2 | LIF 默认出 bit、util/timing | 钉版本 `/tools/Xilinx/Vivado/2023.2`；batch 非 GUI |

## 板卡

- PYNQ-Z2：`192.168.137.3` · `xilinx`/`xilinx`
- Atlas：`192.168.137.2`
- 上板脚本：**禁止** `echo pass \| sudo -S python3 -`（stdin 被密码吃掉 → 假绿）；先 scp 脚本再 `sudo -S python3 /tmp/....py`

## 证据纪律

- 完成定义 = `docs/phase4_poc_evidence/*.json` 且对应 `--gate` exit 0  
- 聊天转述 ≠ 完成；pen 判断「不能开源」禁止（须实测阶段 FAIL）  
- LED/人眼：无摄录时须在证据写明「人签/口头 OK」，不得写成仪器 PASS  
- 合 PR ≠ Phase4.1 关口关闭；不主动开 Phase8

## 改 RTL 最小闭环

1. 改 `fpga/rtl/**`  
2. 跑 Verilator `--gate`  
3. 更新/确认 RTL-CR  
4. 若行为变：同步定点金标  
5. LIF bit：Vivado batch（开源 F 通之前）→ G → H 复测  
6. 进展汇报用「阶段矩阵」：对 A–H 逐格 ✅/⚠/❌，分轨写清

## 下一断点（默认）

开源轨 **F·CARRY/P&R** → `lif_step` 开源 F/G/H；并行维护 PR#20 合入与 Vivado 辅证不回退。

## 相关脚本速查

```bash
# C
python3 scripts/phase4_fpga_lif_verilator_gate.py --gate
# E/S1
python3 scripts/phase4_fpga_s1_impl_chain_gate.py --gate
# F openXC7
python3 scripts/phase4_fpga_z2_openxc7_try.py --design soft_ps7 --gate
# G
python3 scripts/phase4_fpga_z2_openxc7_board_load.py --gate
# H R-A
python3 scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py --samples 20 --gate
```
