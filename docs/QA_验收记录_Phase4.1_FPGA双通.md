# 类脑计算 · QA 验收记录（Phase4.1 · FPGA 双通）

> **轨道**：研究轨 IPD/QA 裁剪（CI 不裁 · VP QA 签字 · 见 `IPD-QA流程裁剪_待VP总裁批准.md`）  
> **范围**：F4 双通 — R-A Atlas↔FPGA（A2）+ R-B 分时整网（B1）  
> **PR**：https://github.com/chenxi750328ai/neuromorphic-computing/pull/17  
> **负责人**：陈正共 · **机读门禁**：`scripts/phase4_fpga_both_runthrough_evidence_gate.py --gate`

---

## 0. 延迟口径说明（人话 · 防误读）

| 说法 | 含义 |
|------|------|
| **G-LAT** | Atlas **整网** daemon 端到端尺子：稳态 p50≤5ms / p95≤10ms（#13 已过，p50≈**3.5ms**） |
| **MMIO** | CPU 通过总线寄存器 **一个一个** 读写 FPGA IP（每次 lif 一步都要多次读写） |
| **分时** | 只有 **1 个** LIF 核，轮流算 256（+10）个神经元，不是 256 核一起算 |
| **远逊 G-LAT** | 双通路径平均约 **0.9–1.5 秒/样本**（见下表），比 Atlas 整网毫秒级慢 **两个数量级以上** —— **功能跑通 ≠ 延迟过 G-LAT** |

---

## 1. 追溯验收（双通）

| ID | 项 | 标准 | 结果 | 证据路径 |
|----|----|------|------|----------|
| F4-A2 | R-A Atlas↔PYNQ M-lif | N≥20；vs host pred 一致率≥98%；标签 acc≥90% | **PASS** match=**1.0** acc=**0.95** | `docs/phase4_poc_evidence/fpga_ra_atlas_mlif_inchain_gate.json` |
| F4-B1 | R-B 分时整网 | 同上；lif1+lif2 走 PL | **PASS** match=**1.0** acc=**0.95** | `docs/phase4_poc_evidence/fpga_rb_fullnet_runthrough_gate.json` |
| F4-PAR | R-B 并行资源墙（保留） | 外推 LUT 不拟合 Z2 | **FAIL（合法）** | `docs/phase4_poc_evidence/fpga_rb_fullnet_platform_gate.json` |
| F4-LAT | 延迟诚实披露 | 不得用双通 PASS 冒充 G-LAT | **记入** A2≈993ms/样本 · B1≈1450ms/样本 | 同上 JSON `avg_*_ms` |
| F4-CI | neuro-ci | PR #17 CI 绿 | 待合入前复核 | GitHub Actions |
| F4-EVID | 机读证据门 | `phase4_fpga_both_runthrough_evidence_gate.py --gate` exit 0 | 本 PR 须绿 | 脚本 |

**复现命令**

```bash
.venv/bin/python3 scripts/phase4_fpga_rb_fullnet_runthrough_gate.py --samples 20 --gate
.venv/bin/python3 scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py --samples 20 --gate
.venv/bin/python3 scripts/phase4_fpga_both_runthrough_evidence_gate.py --gate
```

---

## 2. 质量保证措施（研究轨 IPD 映射）

| IPD 环节 | 本包动作 |
|----------|----------|
| **设计** | 计划 `docs/plans/2026-07-28-fpga-both-routes-runthrough.md` + 总裁一页/裁决 F4–F5 |
| **开发** | `feature/phase4.1-fpga-both-runthrough` · PR #17 |
| **测试** | 上表复现命令 + 证据 JSON；机读 `--gate` |
| **QA** | 本页签字栏 + TE/QA SubAG 评审意见（见 §4） |
| **合并** | neuro-ci 绿 + VP QA PASS + 总裁确认后合（研究轨） |

**禁止假绿**：不得把「pred 一致」写成「G-LAT 过」；不得把「分时整网 PASS」写成「并行整网可用」。

### 2.1 F6 补洞（2026-07-28 总裁：安全可控优先）

研究轨原裁剪 **未强制 RTL 开源门禁** → 属流程缺口。F6 起：

| 项 | 要求 |
|----|------|
| 信任根 | 开源仿真（Verilator 等）+ RTL 检视；**先于** Vivado |
| Vivado | 仅质量对照 / 快速出 bit；**不得**单独证明「逻辑已验证」 |
| 计划 | [`plans/2026-07-28-fpga-sovereign-toolchain.md`](./plans/2026-07-28-fpga-sovereign-toolchain.md) |
| 与 F4 | 双通功能 PASS **不豁免** S0（Verilator 门 + RTL-CR） |

| ID | 项 | 标准 | 结果 | 证据 |
|----|----|------|------|------|
| F6-SIM | Verilator 开源仿真 | `phase4_fpga_lif_verilator_gate.py --gate` | **PASS** | `fpga_lif_verilator_gate.json` |
| F6-CR | RTL 人工检视 | 无未关闭 Critical | **PASS_WITH_NOTE** | `ipd/F6-RTL-CR-检视清单与意见.md` |
| F6-POL | 工具链策略 | Vivado=辅证 | **落盘** | `docs/FPGA_工具链安全可控策略_V0.md` |
| F6-CI | N-CI-VERILATOR | CI BLOCK | 已随 #17 合入 | `neuro-qa-gate-baseline.json` |
| F6-S1 | Yosys+钉版本+batch TCL | `phase4_fpga_s1_impl_chain_gate.py --gate` | **PASS**（Yosys cells=2522；Vivado util 辅 379 LUT） | `fpga_s1_impl_chain_gate.json` |

---

## 3. 审批签字

<!-- SIGNOFF-START -->
```signoff
TE_REVIEW: DONE (陈正齐 · F4-TE 要点已落盘)
QA_INTEGRATION: PASS_WITH_NOTE (陈正孤 · 见 F4-QA-评审意见)
QA_VP: PENDING
PRESIDENT: PENDING
SIGNED_AT:
NOTE: 功能双通+F6 S0(Verilator/RTL-CR)证据已落；延迟远逊 G-LAT 已披露；待 VP QA 签字与总裁确认后合
```
<!-- SIGNOFF-END -->

---

## 4. 评审附件（IPD）

| 角色 | 产出 | 状态 |
|------|------|------|
| 陈正齐 TE | [`ipd/F4-TE-测试方案与用例要点.md`](./phase4_poc_evidence/ipd/F4-TE-测试方案与用例要点.md) | ✅ |
| 陈正孤 QA | [`ipd/F4-QA-评审意见.md`](./phase4_poc_evidence/ipd/F4-QA-评审意见.md) | ✅ PASS_WITH_NOTE |

---

*陈正共 · ChenZhengGong · 2026-07-28*
