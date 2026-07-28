# Phase4.1 · FPGA 加速 + 整网 **都要跑通** Implementation Plan

> **For agentic workers:** 按任务序执行；每任务自测后再进下一任务。  
> **总裁批注（2026-07-28）**：**FPGA 加速和 FPGA 整网都要跑通。**  
> **负责人**：陈正共 · ChenZhengGong  
> **分支**：`feature/phase4.1-fpga-both-runthrough`  
> **纪律**：合 PR ≠ Phase4.1 关口关闭；Phase8 仍默认等双通验收后再议。  
> **关联 F6（2026-07-28）**：安全可控优先 → [`2026-07-28-fpga-sovereign-toolchain.md`](./2026-07-28-fpga-sovereign-toolchain.md)；双通功能 PASS **不豁免** RTL 开源仿真/检视。

---

## Goal

在已有平台账（并行资源墙、R-A 单核分时向量入链）之上，把两条路线都做到 **「跑通」**——不是只留下 FAIL 结论。

| 路线 | 「跑通」最低定义（本计划钉死） | 今日基线 |
|------|-------------------------------|----------|
| **R-A 加速** | M-lif：lif1 **整层**经 PL；端到端 pred 与 host Q16.16 **一致率 ≥98%**（N≥20）；有延迟账 | ✅ 同板 PS+PL 分时已 PASS（#16）；⏳ **Atlas↔FPGA 以太网入链**仍未做 |
| **R-B 整网** | **整网前向**（fc1+lif1+fc2+lif2）在 PYNQ 上跑通分类；pred 与 host 定点 **一致率 ≥98%**（N≥20）；有资源+延迟账 | ❌ 并行阵列不可用（LUT 墙，保留）；⏳ **整网分时跑通**未做 |

**形态钉死（Z2）**

- **禁止**再赌「256 核并行 LIF 阵列」当 R-B 跑通手段（资源墙已立）。  
- R-B 跑通 = **分时复用**：少量/单核 LIF（+PS 或 PL 上的定点 MAC）扫完整网。  
- R-A 跑通补全优先：**Atlas 主链 + FPGA 加速段**（以太网/TCP）；同板分时算「半通」，双通验收要写清是否要求 Atlas 链。

---

## 人话

- **加速跑通**：整网大半仍在 Atlas（或 PS），FPGA 只扛 lif1 整层，结果还对。  
- **整网跑通**：分类这趟活 **整段都在板子侧完成**（允许分时慢慢算），结果还对。  
- 两者都要，避免「只通加速、整网永远是纸面资源墙」。

---

## 验收门禁

| ID | 路线 | 判据 |
|----|------|------|
| A1 | R-A | 现有 `fpga_ra_mlif_vector_inchain_gate` 保持绿（回归） |
| A2 | R-A | **新增**：Atlas daemon + FPGA lif1 入链门禁 JSON（或书面豁免：本里程碑只认同板）——**默认要做 A2**，除非总裁改口 |
| B1 | R-B | `fpga_rb_fullnet_runthrough_gate.json`：板上整网 N≥20，match_rate≥0.98，acc≥0.90 |
| B2 | R-B | 资源报告：声明「分时整网」LUT/BRAM；**不得**再宣称并行阵列可用 |
| D0 | 文档 | 总裁一页 + §4 两行「跑通」；诚实写延迟破尺点 |

---

## Tasks

### Task 0 · 批注 + 分支
- [x] 裁决页写入「双通」批注  
- [x] 建 `feature/phase4.1-fpga-both-runthrough`  
- [x] 总裁确认：**A2 必做**（2026-07-28「必做」）  

### Task 1 · R-B 整网分时跑通（主缺口）
- [x] LIF 全层 PL 分时 + fc 在 PS（板内跑完）  
- [x] 门禁 N=20：match=1.0 · acc=0.95 · `fpga_rb_fullnet_runthrough_gate.json`  
- [x] §4 / 一页更新  

### Task 2 · R-A 补全（Atlas 入链）
- [x] PYNQ lif1 TCP daemon `:9530`  
- [x] Atlas 客户端 fc*/lif2 + RPC lif1  
- [x] 门禁 N=20：match=1.0 · acc=0.95 · `fpga_ra_atlas_mlif_inchain_gate.json`  

### Task 3 · 双通汇总 PR
- [x] PR **#17** 已开；**不代合**；Summary 禁止写关口关闭  

---

## 非目标

- Phase8 / STDP  
- 换更大 FPGA 器件采购  
- 并行 256-LIF RTL  

---

## 风险

| 风险 | 缓解 |
|------|------|
| 分时整网极慢（秒级/样本） | 允许破 G-LAT；跑通看功能一致，延迟单记账 |
| A2 通信难 | 先 B1 同板整网；A2 并行开，阻塞则升级总裁 |

---

*陈正共 · ChenZhengGong*
