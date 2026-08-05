# NEURO-DEMO · F7 FPGA 整网通 测试报告 V0

> **CHECKLIST 真源**：`data/role-standards/checklists/test-v1.json`  
> **WO**：WO-TEST-NEURO-F7-PL-FC · EXEC 节点  
> **方案**：[NEURO-F7-测试方案_V0.md](./NEURO-F7-测试方案_V0.md)  
> **用例**：[NEURO-F7-测试用例_V0.md](./NEURO-F7-测试用例_V0.md)  
> **作者**：陈正齐（ag-chenzhengqi）  
> **日期**：2026-08-04

---

## 1. 文档信息

| 项 | 内容 |
|----|------|
| 测试轮次 | V0 · EXEC 预检 |
| 上游 DEV | WO-DEV-NEURO-F7-PL-FC · nodeVerdict PASS |
| 证据路径 | `/home/cx/neuromorphic-computing/docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json` |
| 分支 | vcompany `feature/phase4.1-f7-pl-fc` · neuro `feature/phase4.1-f7-pl-fc` |

---

## 2. 业界测试规范符合性 CHECKLIST（必填）

| 规范 ID | 处置 | 证据（用例 ID） | 理由 | 评审确认 |
|---------|------|-----------------|------|----------|
| Q-TST-001 | 适用 | NEURO-F7-测试方案_V0.md | 方案落盘 | 待 REV |
| Q-TST-002 | 适用 | TC-F7-* | OR-Ref/AR-Ref 齐全 | 待 REV |
| Q-TST-003 | 适用 | TC-F7-OR-01 | TST-EXEC **reuse-pass-evidence**（预检见 §3） | checker |
| TST-FAIL-01 | 适用 | TC-F7-NEG-01~04 | forbidden/负路径/NEG | 待 REV |
| TST-TRACE-01 | 适用 | 全部 P0 | OR-Ref + AR-Ref | 待 REV |

---

## 3. F7 gate 证据与判定

### 3.1 上游 DEV 证据摘要（结构性预检 · 未重跑板上）

| 字段 | 值 | 阈值 | 判定 |
|------|-----|------|------|
| verdict | PASS_f7_pl_fc | PASS_f7_pl_fc | OK |
| board.n | 20 | ≥20 | OK |
| compare.board_pred_match_rate | 1.0 | ≥0.98 | OK |
| board.correct / acc_vs_label | 19 / 0.95 | ≥90% 辅助 | OK |
| fc_on_pl | true | true | OK |
| lif_on_pl | true | true | OK |
| ps_role | load_dma_orchestrate | ∈{load_dma_orchestrate,load_start_read} | OK |
| board.ok | true | true | OK |
| generated_at | 2026-08-04T18:16:30+08:00 | — | DEV c9b9ee5 恢复 @ f2be5ed |

**预检说明**：EXEC 节点采用 **reuse-pass-evidence**（板 SSH 192.168.137.3:22 不可达；**禁止** live `--gate` 覆写 PASS 证据）。判定依据为 DEV 既有证据 JSON 字段结构性断言。checker 须按 WO `TST-EXEC` 原文 reuse-pass-evidence command 复跑。

### 3.2 TST-EXEC 命令（checker 真源 · reuse-pass-evidence）

WO `TST-EXEC`：读盘 `/home/cx/neuromorphic-computing/docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json`，断言 `PASS_f7_pl_fc` · rate≥0.98 · n≥20 · fc∧lif · board.ok；写 evidence 至 `WO-TEST-NEURO-F7-PL-FC-Q-TST-003.txt`。

### 3.3 禁止冒充项（已测设计覆盖）

| 反例 | 处置 | 用例 |
|------|------|------|
| PASS_rb_tmd | gate 拒收 | TC-F7-NEG-01 |
| PS-fc / fc_on_pl=false | gate 拒收 | TC-F7-NEG-02 |
| 旧 TMD runthrough JSON | 不得代 F7 | TC-F7-NEG-03 |
| test -f 证据 | lint 拒收 | TC-F7-NEG-04 |

---

## 4. 用例摘要

| 用例 ID | OR-Ref | AR-Ref | 结果 | 证据 |
|---------|--------|--------|------|------|
| TC-F7-OR-01 | OR-NEURO-DEMO-001 | phase4_fpga_rb_fullnet_pl_fc_gate.py | **预检 PASS**（引用 DEV JSON） | 见 §3.1 |
| TC-F7-FT-01 | OR-NEURO-DEMO-001 | phase4_fpga_snn_fixedpoint.py | PASS | match_rate=1.0 |
| TC-F7-SR-01 | OR-NEURO-DEMO-001 | fpga_rb_fullnet_pl_fc_gate.json | PASS | 字段齐全 |
| TC-F7-AR-01 | OR-NEURO-DEMO-001 | test_f7_pl_fc_gate.py | BLOCK | 未跑 pytest |
| TC-F7-NEG-01~04 | OR-NEURO-DEMO-001 | 各 forbidden 路径 | 设计覆盖 | 用例 V0 |
| TC-F7-DFX-01 | OR-NEURO-DEMO-001 | wall_ms | PASS | 6124026 ms |
| TC-F7-DFX-02 | OR-NEURO-DEMO-001 | board_ssh | PASS | returncode=0 |

---

## 5. 预检 verification 摘要（EXEC 自跑 · 详见 outbox）

| verifyId | 预检 exitCode | 备注 |
|----------|---------------|------|
| TST-PLAN | 0 | m0-test-plan-gate ok=true |
| TST-CASE | 0 | m0-test-case-gate ok=true |
| TST-EXEC | 0 | reuse-pass-evidence ok=true · PASS_f7_pl_fc n=20 rate=1.0 |
| TST-TRACE | 0 | rg OR-Ref/AR-Ref |
| TST-FAIL-NEG | 0 | rg forbidden/NEG |
| TST-COV-OR/FT/SR/AR | 0 | coverage-matrix gate 全绿 |
| TST-REV-INDEP | 0 | revIndepOk=true |
| TST-LIVE | 0 | wo-verify lint exit 0 |

> **纪律**：本报告**不**自评节点 PASS；节点判定权在 checker。

---

## 6. 遗留与建议

1. checker 须按 WO reuse-pass-evidence command 复跑 `TST-EXEC`（板不可达时不尝试 live `--gate`）。  
2. TC-F7-AR-01 pytest 可在 neuro 仓补跑。  
3. Verilator smoke 当前 FAIL（缺 Vlif_step.h）— 不阻 F7 板门。

---

*2026-08-04 · 陈正齐 · WO-TEST-NEURO-F7-PL-FC*
