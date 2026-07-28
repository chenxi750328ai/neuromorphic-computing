# Phase4.1 · R-A 向量化入链（M-lif）Implementation Plan

> **For agentic workers:** 按任务序执行；每任务自测后再进下一任务。  
> **总裁批注（2026-07-27）**：同意推进「向量化入链」→ 制定计划 → 开发验证 → 再开 PR。  
> **负责人**：陈正共 · ChenZhengGong  
> **分支**：`feature/phase4.1-ra-mlif-vector-inchain`（自双路线 tip；**不**混 Phase8）  
> **拟 PR**：`feat(phase4.1): R-A M-lif 向量化入链（单核分时整层）— 陈正共`

---

## Goal

在已有 **单神经元 PL PASS** 之上，证明 R-A 下一刀：

> **整层 lif1（256 维）经 FPGA 入推理链**，分类仍可对上定点金标准，并留下延迟账。

**本刀实现形态（诚实钉死）**：仍用现有 `lif_step` **单核**，在板侧 **分时扫 256 神经元 × 25 tick**（软件调度向量化）。  
**不是** 256 核并行 RTL；并行整网仍按 R-B 资源墙另论。

## 人话对照

| 词 | 本计划含义 |
|----|------------|
| 向量化 | 一次前向里 lif1 的 256 维都经 PL（分时），对外是「整层」 |
| 入链 | fc1/fc2/lif2 在 PS（或 host）定点；**lif1 在 PL**；端到端出分类 |
| 金标准 | 同 ckpt 的 host Q16.16（`lif_step_fp`）逐样本 pred 对照 |

## 文件

| 路径 | 职责 |
|------|------|
| `scripts/phase4_fpga_ra_mlif_vector_inchain.py` | 门禁：导权重/样本 → SSH 板上跑 → JSON 证据 |
| `docs/phase4_poc_evidence/fpga_ra_mlif_vector_inchain_gate.json` | 证据 |
| `docs/Phase4.1_FPGA双路线平台可用性_总裁一页.md` | 更新 R-A 进度 |
| `docs/Phase4.1_探索规格与补数议程_V0.md` §4 | 填向量化入链行 |
| `docs/Phase4.1_FPGA双路线平台可用性_总裁裁决.md` | 批注 |

## 验收

| ID | 判据 |
|----|------|
| V-ACC | N≥10（默认 20）：board 与 host_proxy **pred 一致率 ≥ 98%**；或 board vs 标签 ≥ 90% 且一致率注明 |
| V-LAT | 报告整层 lif1 板上耗时 + 端到端样本均时（允许远逊 G-LAT，须写清破在 MMIO/分时） |
| V-DOC | §4 + 总裁一页更新；Summary **禁止**写 Phase4.1 了结 |

## Tasks

### Task 0 · 批注 + 分支登记
- [x] 裁决页/一页写入总裁批注
- [x] 建分支 `feature/phase4.1-ra-mlif-vector-inchain`

### Task 1 · 门禁脚本（host 金标准 + board 分时入链）
- [x] `phase4_fpga_ra_mlif_vector_inchain.py` + `phase4_fpga_ra_mlif_vector_board.py`
- [x] 板上：Overlay 一次；每 tick 对 hidden 维 MMIO `lif_step`；fc* 在 PS 定点

### Task 2 · 板上跑通 + 证据
- [x] PYNQ N=20：match_rate=1.0 · board_acc=0.95 · avg_lif1≈923ms
- [x] 更新 §4 / 一页

### Task 3 · PR
- [x] push + `gh pr create`；不代合

---

## 非目标（本 PR 不做）

- 新并行/向量 RTL、新 bitstream  
- Atlas↔FPGA 以太网入链（本刀拓扑 = **WSL↔PYNQ / 板上 PS+PL**；Atlas 入链可作 follow-up）  
- Phase8 / STDP  

---

*陈正共 · ChenZhengGong*
