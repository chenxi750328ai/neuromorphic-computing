# Phase4.1+ · FPGA 全链路安全可控工具链 Implementation Plan

> **For agentic workers:** 按任务序执行；每任务自测后再进下一任务。  
> **总裁批注（2026-07-28）**：**安全可控优先**；目标 **全链路可控**；**Vivado 可作为质量验证手段和快速验证工具**（非唯一信任根）。  
> **负责人**：陈正共 · ChenZhengGong  
> **分支**：建议 `feature/phase4.1-fpga-sovereign-toolchain`（可自本双通枝拆出，或续 PR#17 后继 PR）  
> **纪律**：合 PR ≠ 关口关闭；不混 Phase8。

---

## Goal（人话）

| 要什么 | 不要什么 |
|--------|----------|
| **对错与质量**以可审计、可复现的开源/自主工具为准（仿真、lint、检视、证据门） | 一切以 Vivado GUI「感觉过了」为准 |
| **Vivado** = 快速出 bit / 与厂商实现对照的 **验证后端** | Vivado = 唯一开发 IDE / 唯一质量真源 |
| 中长期：**逻辑→仿真→门禁→（可选）开源实现后端** 主链可控 | 永久锁死「只有 AMD 工具链才能验 RTL」 |

**信任根优先级（钉死）**

```text
1) 可审 RTL 源码 + 开源仿真/形式化门禁（Verilator 等）  ← 主链
2) 人工 RTL 检视清单 + QA 签字
3) 定点金标准 / 板上功能证据
4) Vivado 综合实现 / bitstream / util·timing          ← 辅链：快验与对照
```

Vivado **允许**用于：出 PYNQ 可用 `.bit`、利用率/时序快看、与开源仿真对照。  
Vivado **禁止**单独充当：「RTL 已检视」「功能已验证」「安全可控已满足」。

---

## 背景约束（诚实）

| 事实 | 含义 |
|------|------|
| 现板 **PYNQ-Z2 · xc7z020** | 官方 bitstream 路径短期仍常需 Vivado |
| 本机已有 **Verilator** | 应立刻作主仿真门，进 CI |
| Yosys/nextpnr 对 7-series Zynq bitstream **弱** | 「全链路可控」分阶段：先 **验证链可控**，再评估 **换开源友好器件** 做实现链可控 |
| 研究轨 IPD 原裁剪 **未强制 RTL 闸** | 本计划补上硬项（属流程补洞，非已有未执行） |

---

## 全链路可控 · 阶段目标

### Phase S0 · 验证链可控（本里程碑必达）

- [x] Verilator（或等价开源）对 `lif_step.v` / `lif_step_axi_lite.v` 仿真 `--gate`
- [x] RTL 人工检视清单落盘 + 意见文件（CR）
- [x] `neuro-ci` 或 pre_merge：**开源仿真门 BLOCK**；Vivado **不**作为 CI 唯一依赖
- [x] QA 记录增加 RTL-SIM / RTL-CR 行；未绿不得宣称「硬件逻辑质量已保证」
- [x] 文档钉死：Vivado = 快验/对照后端

### Phase S1 · 实现链降依赖（评估+试点）

- [x] 评估 Yosys 等对 LIF 核的综合对照（利用率数量级）
- [x] Vivado 固定版本、安装包哈希、授权/联网策略（安全基线一页）
- [x] 脚本化 batch 出 bit（已有 TCL）保持；开发默认不依赖 GUI
- [x] 机读：`scripts/phase4_fpga_s1_impl_chain_gate.py --gate`

### Phase S2 · 全链路可控（产品级选项）

- [x] 迁移评估落盘：`docs/FPGA_S2_开源友好器件迁移评估_V0.md`（默认维持 Z2；硬主权触发再 ECP5 PoC）
- [x] 机读：`scripts/phase4_fpga_s2_migration_eval_gate.py --gate`
- [ ] 若总裁升硬约束：开 **ECP5 + Yosys/nextpnr** 移植 PoC（另 PR）
- [ ] PoC Go 后：主路径器件写入架构真源；Z2+Vivado 降为过渡对照

---

## 工具分工表（执行真源）

| 活动 | 主工具（可控优先） | Vivado 角色 |
|------|-------------------|-------------|
| 编辑 RTL | 编辑器 + git | 可选只读对照 |
| 功能仿真 | **Verilator** (+ cocotb 可选) | xsim 可选对照，非门禁 |
| Lint | Verilator `-Wall` / 开源 lint | 不作为主 |
| 形式化（可选） | SymbiYosys | — |
| RTL 检视 | 人工清单 + 记录 md | — |
| 出 bit（现 Z2） | — | **允许**：快验/上板 |
| util/timing 快看 | — | **允许**：对照 |
| 板上功能 | PYNQ + 开源/自研脚本 | bit 来源可暂 Vivado |
| CI | Verilator gate + 证据 gate | **禁止**要求 runner 装全套 Vivado |

---

## Tasks（S0 开工序）

### Task 0 · 批注与 IPD 挂钩
- [x] 总裁口径落盘（本计划 + 裁决页）
- [x] `QA_验收记录` / IPD 裁剪补充「RTL 开源门禁不可裁」脚注
- [x] 与 F4 双通关系：双通功能 PASS **不豁免** S0

### Task 1 · Verilator 主门禁
- [x] testbench（或 cocotb）驱动 `lif_step` / AXI-Lite 最小事务
- [x] `scripts/phase4_fpga_lif_verilator_gate.py`（或 `.sh`）`--gate`；对照 `lif_step_fp`
- [x] 证据 JSON 落 `docs/phase4_poc_evidence/`
- [x] 挂 `qa-neuro-baseline` 或 `neuro-ci` 一步

### Task 2 · RTL 检视
- [x] 清单：复位、Q16.16、溢出、握手 done、AXI-Lite 单拍假设、与 Python 语义差
- [x] 检视意见 md；缺陷建档闭环
- [x] QA 签字栏增加 RTL-CR

### Task 3 · Vivado 降级定位文档
- [x] `docs/FPGA_工具链安全可控策略_V0.md`：信任根、版本钉扎、联网策略、禁止事项
- [x] 更新总裁一页 / path_b：开发默认开源仿真，Vivado=快验

### Task 4 · PR
- [x] 续 PR #17；Summary 写清「可控优先 / Vivado 辅」；不代合

---

## 验收（S0）

| ID | 判据 |
|----|------|
| SOV-1 | Verilator `--gate` exit 0，证据落盘 |
| SOV-2 | RTL-CR 意见文件存在且无未关闭 Critical |
| SOV-3 | CI/pre_merge 含开源仿真门（文档+机读） |
| SOV-4 | 策略文档明示 Vivado 仅为验证/快验后端 |

---

## 非目标（本计划 S0）

- 立即淘汰 PYNQ-Z2  
- 本机强制安装完整 Yosys 出 7-series bit（不可行则记评估结论）  
- Phase8  

---

*陈正共 · ChenZhengGong · 2026-07-28*
