# FPGA 开发流程与工具一览 V0

**作者**：陈正共 · ChenZhengGong  
**日期**：2026-07-29  
**用途**：工具速查 / 阶段对照表（**不是**「完备」标尺，也**不是**汇报唯一视角）  
**汇报真源**：[`FPGA_按项目目标_独立评审_Opus_V0.md`](./FPGA_按项目目标_独立评审_Opus_V0.md) · 机读 `scripts/phase4_fpga_goal_verify.py`  
**策略**：`FPGA_工具链安全可控策略_V0.md` · Skill：`neuro-fpga-dev`

---

## 1. 主链（人话）

```text
写源码 → 仿真 → 检视 → 综合 → 实现/出bit → 上板加载 → 实测/入链
         ↑________信任根优先开源________↑    ↑辅证可 Vivado↑    ↑板级证据↑
```

**信任顺序（钉死）**：RTL+开源仿真 → 人工检视 → 板级/金标 → Vivado 辅证。  
合 PR ≠ 关口关闭；Phase8 默认不开。

---

## 2. 阶段 × 工具一览

| # | 阶段 | 做什么 | 主工具（可控优先） | 辅工具 | 本仓门禁/命令 | 证据落点 |
|---|------|--------|-------------------|--------|---------------|----------|
| **A** | 写源码 | RTL / 约束 / 顶层 | 编辑器 + git；`fpga/rtl/**`、`fpga/openxc7_try/**` | — | 分支 `feature/*`；提交含陈正共 | 源码本身 |
| **B** | 测试（定点金标） | Python 定点对照、脉冲序列 | `phase4_fpga_lif_fixedpoint.py` 等 | — | 随仿真/板测脚本 | `docs/phase4_poc_evidence/*` |
| **C** | 仿真 | 功能对错（主信任根） | **Verilator** | xsim（不进主门） | `python3 scripts/phase4_fpga_lif_verilator_gate.py --gate` | `fpga_lif_verilator_gate.json` |
| **D** | 检视 | 人审 RTL | 清单+意见 md | — | `docs/phase4_poc_evidence/ipd/F6-RTL-CR-检视清单与意见.md` | 同左 |
| **E** | 综合 | 逻辑→网表；资源量级 | **Yosys** `synth_xilinx` / generic | **Vivado 2023.2** synth（辅） | `phase4_fpga_s1_impl_chain_gate.py --gate` | `fpga_s1_impl_chain_gate.json` |
| **F** | 实现/出 bit | P&R → bitstream | **openXC7**：nextpnr-xilinx + prjxray（smoke 已通） | **Vivado batch** TCL（LIF 默认） | open：`phase4_fpga_z2_openxc7_try.py --gate`；Vivado：`fpga/vivado/*.tcl` | `fpga_z2_openxc7_try*.json`；`fpga/bitstreams/` |
| **G** | 上板加载 | PCAP / Overlay 烧 PL | PYNQ `Bitstream.download`；脚本 scp+ssh | Vivado HW Manager（可选） | `phase4_fpga_z2_openxc7_board_load.py --gate` | `fpga_z2_openxc7_board_load.json` |
| **H** | 实测/入链 | 板上功能、与 Atlas/金标一致 | PYNQ daemon + 主机 gate | LED 人眼 | R-A：`phase4_fpga_ra_atlas_mlif_inchain_gate.py --gate`；R-B 分时：`phase4_fpga_rb_fullnet_runthrough_gate.py` | `fpga_ra_*` / `fpga_rb_*` JSON |

### 板卡与网段（实验室）

| 角色 | 地址 | 账号（默认） |
|------|------|--------------|
| PYNQ-Z2 | `192.168.137.3` | `xilinx` / `xilinx` |
| Atlas | `192.168.137.2` | 见 Atlas 文档 |
| Vivado | `/tools/Xilinx/Vivado/2023.2` | 钉版本指纹见策略 V0 |

### 双轨实现（勿混）

| 轨 | 适用 | 状态（2026-07-29） |
|----|------|-------------------|
| **开源轨** openXC7 | blinky smoke；目标扩展到 `lif_step` | A–G 软逻辑(+PS7) **PASS**；**CARRY/P&R 堵** → LIF 未走通 F |
| **辅证轨** Vivado 2023.2 | `lif_step` 出 bit、util/timing | LIF 已上板入链（R-A）；仍是 LIF **默认出 bit** |

---

## 3. 进展矩阵（按上表汇报）

图例：✅ 已通 · ⚠ 部分/降级 · ❌ 未通 · — 不适用

### 3.1 开源轨（Z2 · openXC7 · blinky / 目标 LIF）

| 阶段 | blinky 软逻辑+PS7 | 加法/CARRY blinky | `lif_step` 开源 |
|------|-------------------|-------------------|-----------------|
| A 源码 | ✅ | ✅ | ✅（已有 RTL） |
| B 金标 | —（LED） | — | ⚠ 金标在 Python；开源 bit 未对 |
| C 仿真 | —（smoke） | — | ✅ Verilator（与工具链无关） |
| D 检视 | — | — | ✅ F6 RTL-CR |
| E 综合 | ✅ Yosys | ✅ Yosys | ✅ Yosys generic/S1；xc7 全链待 |
| F 出 bit | ✅ | ❌ P&R route FAIL | ❌ 被 F 阻塞 |
| G 上板 | ✅ PCAP（LED 人眼记 OK） | — | ❌ |
| H 实测 | ⚠ LED 未摄录，口头 OK | — | ❌（仍走 Vivado bit） |

### 3.2 辅证轨（Vivado · LIF / 双通）

| 阶段 | `lif_step` | R-A Atlas↔PL | R-B 并行整网 | R-B 分时整网 |
|------|------------|--------------|--------------|--------------|
| A–D | ✅ | ✅ | ✅ RTL | ✅ |
| E–F Vivado bit | ✅ | ✅ | ❌ LUT 墙 | ✅ 分时 |
| G–H 实测 | ✅ 脉冲≡golden | ✅ A2 PASS | ❌ 合法 FAIL | ✅ runthrough |

### 3.3 F6 里程碑对照

| 里程碑 | 含义 | 状态 |
|--------|------|------|
| S0 验证链可控 | C+D 进 CI | ✅ 已合 main |
| S1 实现链降依赖 | E 对照 + Vivado 钉版本 | ✅ 已合 main |
| S2 开源出 bit/迁移 | F 开源 + 评估 | ⚠ blinky F+G 通；LIF F 未通；[PR#20](https://github.com/chenxi750328ai/neuromorphic-computing/pull/20) 待合 |
| 关口 Phase4.1 | 总裁口径关闭 | ❌ 未关 |
| Phase8 | STDP 等 | ❌ 默认阻断 |

---

## 4. 下一刀（只排主链断点）

1. **合 PR#20** — 钉「开源 F+G 对 blinky 已通」  
2. **打通 F·CARRY/P&R**（或软加）→ 再跑 `lif_step` 开源 F  
3. **`lif_step` 开源 G+H** — 加载 + 脉冲序列≡golden（对标现 Vivado 链）  
4. 仍不过 → 总裁触发 **ECP5 PoC**（换器件，不是 pen 判死刑）

---

## 5. 相关真源

| 文档 | 角色 |
|------|------|
| `FPGA_工具链安全可控策略_V0.md` | 信任根 / Vivado 边界 |
| `FPGA_S2_开源友好器件迁移评估_V0.md` | S2 实测结论 |
| `plans/2026-07-28-fpga-sovereign-toolchain.md` | S0/S1/S2 计划 |
| `Phase4.1_FPGA双路线平台可用性_总裁一页.md` | 双通一页 |
| `QA_验收记录_Phase4.1_FPGA双通.md` | QA 行 |

---

*陈正共 · 2026-07-29*
