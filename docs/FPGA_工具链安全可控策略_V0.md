# FPGA 工具链安全可控策略 V0

**状态**：生效（F6 总裁裁决落地）  
**作者**：陈正共 · ChenZhengGong  
**日期**：2026-07-28  
**关联**：`docs/plans/2026-07-28-fpga-sovereign-toolchain.md`、`docs/Phase4.1_FPGA双路线平台可用性_总裁裁决.md` F6

---

## 1. 信任顺序（钉死）

1. **可审计 RTL + 开源仿真/形式化（Verilator）** — 主信任根  
2. **人工 RTL 检视 + QA 行记录**  
3. **定点金标 / 板级证据**（PYNQ 等）  
4. **Vivado 综合/比特流/利用率/时序** — **仅辅证与快验**，不得作为唯一信任根

双通（R-A/R-B）板级 PASS **不豁免** Verilator / RTL-CR。

---

## 2. Vivado 使用边界

| 项 | 策略 |
|----|------|
| 角色 | QA / 快速验证后端；生成 bitstream、utilization、timing 报告 |
| 钉版本 | **Vivado 2023.2**（本实验室已装版本）；升级须记变更与复跑辅证 |
| 本机路径（实验室） | `/tools/Xilinx/Vivado/2023.2` · `bin/vivado` md5=`94d98ba55f63934680f8919fd146b430` · `settings64.sh` md5=`219c49eb0cb3146a57bdea705b24238d`（换机须重采指纹） |
| 许可/离线 | 使用本机已授权安装；禁止把工程密钥/许可证凭证写入 Git；`~/.Xilinx` 不下库 |
| 禁止 | 以「仅 Vivado 仿真通过」替代开源仿真门禁；以闭源 IP 黑盒代替可审计 LIF RTL（研究轨核心路径）；**开发默认开 GUI** |
| 允许 | 厂商原语/约束文件（`.xdc`）用于落地 Zynq-7000；须在文档标明依赖 |
| batch 出 bit | `source /tools/Xilinx/Vivado/2023.2/settings64.sh && cd fpga/vivado && vivado -mode batch -source create_lif_overlay.tcl` |

---

## 3. 开源仿真门禁

- **命令**：`python3 scripts/phase4_fpga_lif_verilator_gate.py --gate`  
- **证据**：`docs/phase4_poc_evidence/fpga_lif_verilator_gate.json`  
- **CI**：`N-CI-VERILATOR`（须安装 `verilator`）  
- **改 RTL 后**：必须复跑 `--gate`；失败不得合 main

---

## 4. RTL 变更纪律

1. 改 `fpga/rtl/**` → Verilator gate + 更新/确认 RTL-CR  
2. 行为变更须同步 Python 定点金标（`phase4_fpga_lif_fixedpoint` / 既有 gate）  
3. 板级 bitstream 重生成属辅证；不得只交 bit 文件而无仿真证据

---

## 5. S1 · 实现链降依赖（对照）

| 项 | 说明 |
|----|------|
| Yosys | 对 `lif_step` 开源综合（generic cell）；**不等于** xc7 LUT 数 |
| 门禁 | `python3 scripts/phase4_fpga_s1_impl_chain_gate.py --gate` |
| 证据 | `docs/phase4_poc_evidence/fpga_s1_impl_chain_gate.json` |
| Vivado util（辅） | 既有 `fpga/bitstreams/lif_step_utilization.rpt` ≈ 379 Slice LUTs |

## 6. 主权缺口（诚实边界）

- **xc7z020 全开源 bitstream** 短期不可行（缺完整开源后端）；硬主权需求走器件迁移（计划 S2）  
- 本 V0 目标是：**逻辑可信（RTL+Verilator）优先于工具链完全开源**；S1 仅证明开源综合路径存在

## 7. Phase8

本策略不解除 Phase8/STDP 默认阻断；解除须总裁另裁。
