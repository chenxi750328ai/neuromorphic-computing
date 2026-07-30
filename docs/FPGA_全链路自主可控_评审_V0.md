# FPGA 全链路自主可控 · 评审 V0（一次说全）

**评审人**：陈正共 · ChenZhengGong  
**日期**：2026-07-29  
**目标**：端到端「开发 → 交付」**自主可控**（不绑死闭源工具）  
**交付物**：板上可用的 **`lif_step`（类脑核）**，不是点灯 demo  

图例：**OK**＝自主可控工具已闭环 · **弱**＝有但不完整/不进硬门 · **缺**＝未建 · **堵**＝已试但失败 · **靠闭源**＝交付在走但非自主可控

---

## 1. 总判（先看这里）

| 问题 | 结论 |
|------|------|
| 全链路自主可控是否已交付？ | **否** |
| 唯一主断点 | **开源布局布线 → 出 `lif_step` bitstream** |
| 现在板上跑的 LIF | **靠 Vivado 出 bit**（功能可交，主权未交） |
| 点灯级开源全链 | **已通**（综合→bit→上板），**不能**代替 LIF 交付 |

---

## 2. 端到端全表（流程 · 工具 · 状态）

| # | 流程 | 自主可控应用什么 | 状态 | 证据/门禁 | 说明 |
|---|------|------------------|------|-----------|------|
| 1 | 写源码 | 编辑器 + git · `fpga/rtl` | **OK** | 源码在仓 | — |
| 2 | 金标/单元测试 | 自研 Python 定点 | **OK** | `phase4_fpga_lif_fixedpoint.py` 等 | — |
| 3 | 自动 Lint | Verilator `-Wall` / 应用 Verible 等 | **弱** | 嵌在仿真脚本，无独立 lint 门、不进 CI | 计划有、硬门无 |
| 4 | 前仿（RTL 仿真） | **Verilator** | **OK** | `phase4_fpga_lif_verilator_gate.py --gate` · CI `N-CI-VERILATOR` | 主信任根 |
| 5 | 人工检视 | RTL-CR 清单 | **OK** | `F6-RTL-CR-检视清单与意见.md` | 不进 CI |
| 6 | 综合 | **Yosys** | **OK** | `phase4_fpga_s1_impl_chain_gate.py --gate` · CI `N-CI-YOSYS-S1` | 对照级；≠厂商 LUT 数 |
| 7 | **门仿**（综合后门级仿真） | Yosys 网表 + Verilator/Icarus 等 | **缺** | 无 | 全仓未建 |
| 8 | 布局布线 → **出 bit** | openXC7：nextpnr-xilinx + prjxray | **堵**（LIF） | carry：`fpga_z2_openxc7_try_carry.json` FAIL；blinky soft_ps7 PASS | **主权交付断点** |
| 8′ | 出 bit（当前交付旁路） | Vivado 2023.2 batch | **靠闭源** | `fpga/vivado/*.tcl` · `fpga/bitstreams/` | LIF 现网默认 |
| 9 | **后仿**（布线后/时序反标） | 开源极弱；厂商有 SDF | **缺** | 仅有 Vivado timing rpt ≠ 后仿 | — |
| 10 | 上板加载 | PYNQ 开源加载 | **OK**（工具） | `openxc7_board_load` / LIF Overlay 脚本 | 开源 LIF bit 尚无；现加载的是 Vivado bit |
| 11 | 板上实测 / 入链交付 | 自研 daemon + gate | **靠闭源 bit 下 OK** | R-A Atlas 入链 PASS 等 | 功能交付有；主权交付无 |

---

## 3. 一张图看懂缺口

```text
写码 OK → 金标 OK → Lint 弱 → 前仿 OK → 检视 OK → 综合 OK
    → 门仿 缺 → 【出 bit 开源 堵】→ 后仿 缺 → 上板工具 OK → 实测（现靠 Vivado bit）
```

**自主可控交付 = 必须把「出 bit 开源」从堵打成 OK，并补门仿（建议），后仿/强 lint 按风险补。**

---

## 4. 已通 / 未通（对照里程碑）

| 项 | 状态 |
|----|------|
| S0 验证链（前仿+检视+CI） | **已合 main** |
| S1 综合对照（Yosys+钉版本 Vivado 辅） | **已合 main** |
| S2 开源出 bit 评估+blinky 实测 | **PR#20 OPEN**（blinky 出 bit+上板已证） |
| `lif_step` 开源出 bit | **未通**（CARRY/P&R 路由失败） |
| 门仿 / 后仿 / 独立 lint 门 / 形式化 | **未建** |
| Phase4.1 关口关闭 / Phase8 | **未开** |

---

## 5. 根因（只一句）

不是「方案太多」，是 **第 8 步：开源 P&R 对带硬件加法（CARRY）的网表过不了 → 交付核出不了开源 bit**；门仿/后仿/强 lint 是完备性缺口，但当前挡交付主权的是第 8 步。

---

## 6. 建议优先级（不再分叉扯皮）

| 优先级 | 动作 | 完成定义 |
|--------|------|----------|
| P0 | 打通 openXC7 对 **`lif_step`（或等价含加法设计）出 bit** | `openxc7_try` 对 LIF PASS + 证据 JSON |
| P0 | 该 bit **上板 + 脉冲≡金标** | board_load + 与现 Vivado 链同判据 PASS |
| P1 | 合 **PR#20** | main 钉 blinky 开源 F/G 证据 |
| P2 | 建 **门仿** 门禁 | 综合网表仿真 `--gate` + 证据 |
| P3 | 独立 **lint** 门进 CI | 不靠嵌在仿真里的 -Wall |
| P4 | **后仿**（能做多少做多少；开源受限须写明） | 有门或书面降级理由 |
| 备胎 | 仅当 P0 合理工期失败 → 总裁批 **ECP5** | 另立项，不平行空转 |

**混合（仿真开源 + Vivado 出 LIF bit）允许作过渡，不得写成「全链路自主可控已交付」。**

---

## 7. 文档口径纠偏（评审发现）

| 问题 | 处理 |
|------|------|
| 「Z2 不能开源出 bit」 | **过时**；blinky 已通；LIF 仍不通 |
| 把 Verilator 写成「形式化」 | **错**；形式化未做 |
| `fpga_toolchain_gate.json` 旧 false | **勿当总闸**；与后续入链 PASS 矛盾 |
| PR#20 标题偏「迁移评估」 | 实质已含开源出 bit/上板；合入时按 commits |

---

*完整流程日常汇报用：`FPGA_开发流程与工具一览_V0.md` · Skill：`neuro-fpga-dev`*  
*本文件 = 自主可控完备性评审真源，避免再挤牙膏。*
