# NEURO-DEMO · F7 FPGA 整网通 测试方案 V0

> **测试对象**：Phase4.1 F7 · FPGA 整网 fc+LIF on PL（784→256→10 · 25 tick · Q16.16）  
> **作者**：陈正齐（ag-chenzhengqi / TE）  
> **评审人**：陈方瑟（ag-chenfangse / TE 评审）  
> **关联工单**：WO-TEST-NEURO-F7-PL-FC · 依赖 WO-DEV-NEURO-F7-PL-FC  
> **OR 真源**：OR-NEURO-DEMO-001 · `data/tr1-or-list.json`  
> **设计真源**：`neuromorphic-computing/docs/superpowers/specs/2026-08-04-f7-fpga-fullnet-pl-design.md`  
> **配套**：[NEURO-F7-测试用例_V0.md](./NEURO-F7-测试用例_V0.md) · [NEURO-F7-覆盖矩阵_V0.md](./NEURO-F7-覆盖矩阵_V0.md)  
> **CHECKLIST**：`data/role-standards/checklists/test-v1.json`

---

## 1. 文档信息

| 项 | 内容 |
|----|------|
| 测试对象 | OR-NEURO-DEMO-001 / FT-F7-PL-FC / SR-F7-GATE / AR-F7-PL-FC |
| 版本 | V0 |
| 作者 | 陈正齐（ag-chenzhengqi） |
| 评审人 | 陈方瑟（ag-chenfangse）· **reviewer ≠ author · 禁止作者自评** |
| 关联工单 | WO-TEST-NEURO-F7-PL-FC |
| 开发设计引用 | `scripts/phase4_fpga_rb_fullnet_pl_fc_gate.py` · `fpga/rtl/linear_mac.v` · `fpga/rtl/lif_step.v` |
| DEV 基线 | `feature/phase4.1-f7-pl-fc` · 证据 `fpga_rb_fullnet_pl_fc_gate.json` · verdict=`PASS_f7_pl_fc` |

---

## 2. 业界测试规范 CHECKLIST（必填）

| 规范 ID | 处置 | 证据章节 | 理由 | 评审确认 |
|---------|------|----------|------|----------|
| Q-TST-001 | **适用** | §3–§6 | 本文件即方案交付；声明 unit/int/sys 与 F7 退出准则 | 陈方瑟 待签 |
| Q-TST-002 | **适用** | 配套用例 V0 | TC-F7-* 含 OR-Ref/AR-Ref + dimension | 陈方瑟 待签 |
| Q-TST-003 | **适用（F7 reuse-pass-evidence）** | §4.2 · §6 | WO TST-EXEC 读盘 JSON（禁 live `--gate` 覆写证据） | checker |
| TST-TRACE-01 | **适用** | 用例 §2 | 每条 P0 含 OR-Ref/AR-Ref | 陈方瑟 待签 |
| TST-FAIL-01 | **适用** | 用例 TC-F7-NEG-* | forbidden/负路径/NEG：PS-fc、PASS_rb_tmd、旧 TMD | 陈方瑟 待签 |
| TST-LIVE-01 | follow | §6.3 | `wo-verify-command-lint.py --gate` | checker |
| Q-TST-REV-INDEP | **适用** | §1 评审人栏 | reviewer（陈方瑟）≠ author（陈正齐） | checker |

---

## 3. 测试范围与目标

### 3.1 buildScopeInventory（登记对象清单）

| 登记类型 | 登记 ID | 摘要 | 真源 |
|----------|---------|------|------|
| OR | OR-NEURO-DEMO-001 | 类脑演示 TR1 · Phase4.1 F7 硬门 | `data/tr1-or-list.json` |
| FT | FT-F7-PL-FC | FPGA 整网 fc+LIF on PL 特性 | F7 design spec §2 |
| SR | SR-F7-GATE-EVIDENCE | 门禁 JSON + 板 SSH 证据链 | `fpga_rb_fullnet_pl_fc_gate.json` |
| AR | AR-F7-MAC-RTL | linear_mac 分时 MAC RTL | `fpga/rtl/linear_mac.v` |
| AR | AR-F7-LIF-RTL | lif_step 神经元 RTL | `fpga/rtl/lif_step.v` |
| AR | AR-F7-GATE-SCRIPT | 板上门禁脚本 | `scripts/phase4_fpga_rb_fullnet_pl_fc_gate.py` |

> **子集豁免纪律**：CCB skipped（总裁 2026-08-04 · frozen_scope=B）；未扩 vcompany pathScope 外模块；INV-1~5 标 WO notApplicable。

### 3.2 测试分层（unit / int / sys / UAT）

| 层 | 范围 | 本方案处置 |
|----|------|------------|
| **unit** | RTL 单行点积 · gate 脚本结构断言 | AR 层 · `tests/test_f7_pl_fc_gate.py` |
| **int** | PL 行为模型 vs 金标 · 证据 JSON 字段 | SR 层 · 证据结构性预检 |
| **sys** | 板上 N≥20 整网 pred≡金标 · `--gate` live | OR/FT 层 · **F7 唯一硬门** |
| **UAT（用户验收）** | 总裁/PL 可读 PASS_f7_pl_fc + 证据 JSON | 报告挂证据 · **与回归物理分离** |

### 3.3 在范围内

| 范围 | 说明 |
|------|------|
| F7 硬门 | N≥20 · pred≡金标≥98% · fc_on_pl=true · lif_on_pl=true |
| 证据可对读 | DEV `fpga_rb_fullnet_pl_fc_gate.json` 字段与 TEST 报告一致 |
| 负路径 | 禁 PASS_rb_tmd / PS-fc / 旧 runthrough 冒充 F7 |
| pytest AR | `tests/test_f7_pl_fc_gate.py` 结构/阈值断言 |

### 3.4 在范围外

| 排除项 | 理由 |
|--------|------|
| Phase8 / 自学习 | F7 spec 非目标 |
| 正加速比 / Atlas 打赢 | F7 不卡延迟 |
| Verilator 全绿 | 证据中 verilator_smoke 可 FAIL；不替代板门 |
| GWT-MVP / VC 主链 INV | 本 WO notApplicable |

### 3.5 测试目标（可衡量）

| ID | 目标 | PASS 信号 |
|----|------|-----------|
| F7-OR-01 | Phase4.1 关口可演示 | gate JSON `verdict=PASS_f7_pl_fc` |
| F7-FT-01 | pred ≡ FixedPointSNN 金标 | `board_pred_match_rate ≥ 0.98` · N≥20 |
| F7-SR-01 | 证据字段完整 | fc_on_pl · lif_on_pl · ps_role 合法 |
| F7-AR-01 | 门禁脚本可机验 | `phase4_fpga_rb_fullnet_pl_fc_gate.py --gate` exit 0 |
| F7-NEG | 旧 TMD/PS-fc 不得冒充 | 负路径用例 TC-F7-NEG-* 定义期望 FAIL |

---

## 4. 测试策略

| 层级 | 策略 | 工具/环境 | 负责人 |
|------|------|-----------|--------|
| OR 验收 | 端到端板上整网 pred≡金标 | PYNQ-Z2 + overlay | 陈正齐 |
| FT | fc+LIF on PL 分时特性 | gate `--gate` | 陈正齐 |
| SR | 证据 JSON + SSH 回执 | scp/ssh · JSON schema | 陈正齐 |
| AR | RTL 单元 + gate 脚本 pytest | Verilator/pytest | 陈正齐 |

### 4.1 F7 验收链

```text
FixedPointSNN 金标 ──► PL 行为模型 ──► 板上 overlay
                              │                │
                              └──── compare ───┘
                                       │
                         phase4_fpga_rb_fullnet_pl_fc_gate.py --gate
                                       │
                         fpga_rb_fullnet_pl_fc_gate.json (PASS_f7_pl_fc)
```

### 4.2 Q-TST-003 exec 探针（F7 · reuse-pass-evidence）

> **模式**：`reuse-pass-evidence` — 读盘校验 DEV 产出 JSON，**禁止**调用 `phase4_fpga_rb_fullnet_pl_fc_gate.py --gate`（防 scp_failed 覆写 PASS 证据；板 SSH 不可达时仍可对读）。

| 字段 | 阈值 |
|------|------|
| N | ≥ 20 |
| pred≡金标 | ≥ 98% |
| fc_on_pl | true |
| lif_on_pl | true |
| verdict | PASS_f7_pl_fc |
| board.ok | true |

**真源**：`/home/cx/neuromorphic-computing/docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json`

**硬禁**：不得以 `test -f` 证据 JSON、旧 `PASS_rb_tmd`、PS-fc numpy 路径冒充 PASS；**禁止 live `--gate` 覆写证据 JSON**。

### 4.3 层×维度覆盖矩阵（必填 · 详见独立交付件）

> 门禁：`python3 scripts/m0-test-coverage-matrix-gate.py --gate --layer {OR,FT,SR,AR} --artifact docs/neuromorphic-computing/NEURO-F7-覆盖矩阵_V0.md`

| 层级 | 登记 ID | 正常策略 / 代表场景 | 异常策略 / 负路径 | DFX 策略（性能/安全/可恢复/可观测） |
|------|---------|---------------------|-------------------|-------------------------------------|
| OR | OR-NEURO-DEMO-001 | TC-F7-OR-01 板上 N=20 gate PASS | TC-F7-NEG-03 旧 TMD 冒充 FAIL | TC-F7-DFX-01 wall_ms 可观测 |
| FT | FT-F7-PL-FC | TC-F7-FT-01 pred≡金标≥98% | TC-F7-NEG-02 PS-fc forbidden | TC-F7-DFX-02 fc_pl_ms 性能登记 |
| SR | SR-F7-GATE-EVIDENCE | TC-F7-SR-01 JSON 字段齐全 | TC-F7-NEG-01 PASS_rb_tmd 拒收 | TC-F7-DFX-03 SSH stderr 可恢复 |
| AR | AR-F7-GATE-SCRIPT | TC-F7-AR-01 pytest gate 结构 | TC-F7-NEG-04 纯 test -f 拒收 | TC-F7-DFX-04 n_mac_pl_calls 计数 |
| AR | AR-F7-MAC-RTL | TC-F7-AR-02 linear_mac 单行点积 | TC-F7-NEG-04：RTL 缺省不得 test -f 代 PASS | Verilator smoke（辅助） |
| AR | AR-F7-LIF-RTL | TC-F7-AR-03 lif_step 行为 | TC-F7-NEG-04：仿真缺 Vlif_step.h 不冒充板 PASS | 与 MAC 分时调度可观测 |

---

## 5. 测试环境与数据

| 环境 | 用途 | 依赖 | 真源 |
|------|------|------|------|
| PYNQ-Z2 · 192.168.2.x | 板上 F7 live | overlay bit/hwh | `fpga/bitstreams/f7_fullnet_pl_fc_overlay.bit` |
| WSL2 · Python 3 + torch | 金标/证据预检 | `.venv` | `neuromorphic-computing` 仓 |
| checkpoint | 权重真源 | 文件存在 | `runs/20260527T092534Z/checkpoint.pt` |
| MNIST test | N=20 顺序抽样 | loaders | `train_mnist_snn.py` |

---

## 6. 进入/退出准则

| 阶段 | 进入条件 | 退出条件 |
|------|----------|----------|
| 方案评审 | DEV WO nodeVerdict PASS | 本方案 V0 落盘 · reviewer≠author |
| 用例评审 | 方案 V0 评审通过 | 用例 V0 落盘 · 负路径齐全 |
| 执行 | checker 派发 EXEC | TST-EXEC reuse-pass-evidence ok=true |
| 报告 | 执行完成 | 报告挂证据 JSON 字段与 verdict |
| **F7 退出（Phase4.1）** | DEV+TEST 证据可对读 | `PASS_f7_pl_fc` · N≥20 · match≥98% · fc/lif on PL |

### 6.1 F7 退出准则（总裁方案 3）

1. TST-EXEC **reuse-pass-evidence**：读盘 JSON · verdict/rate/n/fc/lif/board.ok 全满足  
2. 证据 JSON：`verdict=PASS_f7_pl_fc` · `board.n≥20` · `compare.board_pred_match_rate≥0.98`  
3. `fc_on_pl=true` · `lif_on_pl=true` · `ps_role∈{load_dma_orchestrate,load_start_read}`  
4. **禁止**旧 `PASS_rb_tmd` / PS-fc / runthrough JSON 替代

### 6.2 UAT 与回归物理分离

| 类型 | 内容 | 执行者 | 证据 |
|------|------|--------|------|
| **回归** | pytest AR · gate 脚本结构 · 证据字段预检 | TE checker | `tests/test_f7_pl_fc_gate.py` |
| **UAT（用户验收）** | 总裁/PL 审阅 PASS_f7_pl_fc + 演示 pred 一致 | 人类 | 测试报告 §3 · milestones |

> **物理分离**：回归可在 CI/WSL 无板环境跑；UAT 须读板上证据与报告，不得用回归 pytest  alone 宣称 Phase4.1 关闭。

### 6.3 WO verification 命令表（checker 真源）

| verifyId | command 摘要 | expect |
|----------|--------------|--------|
| TST-PLAN | `m0-test-plan-gate.py --gate --artifact NEURO-F7-测试方案_V0.md` | ok=true |
| TST-CASE | `m0-test-case-gate.py --gate --artifact NEURO-F7-测试用例_V0.md` | exit 0 |
| TST-EXEC | reuse-pass-evidence 读盘 JSON（WO command） | ok=true |
| TST-COV-* | `m0-test-coverage-matrix-gate.py --gate --layer {OR,FT,SR,AR}` | ok=true |
| TST-REV-INDEP | `--check-rev-indep` on 本方案 | revIndepOk=true |
| TST-LIVE | `wo-verify-command-lint.py --wo WO-TEST-NEURO-F7-PL-FC.json --gate` | exit 0 |

---

## 7. 风险与应对

| 风险 | 影响 | 应对 |
|------|------|------|
| 板上 N=20 ~1.5h | EXEC 阻塞 | 引用 DEV 既有证据 + 结构性预检；checker 另跑 live |
| Verilator 缺 Vlif_step.h | AR smoke FAIL | 不替代板门；记录 blockers |
| 双仓 neuro/vcompany | 证据路径 | 报告写绝对路径 + 字段摘要 |
| PS-fc 冒充 | 假绿 | TC-F7-NEG-02 + gate 字段断言 |

---

## 8. 进度与资源

| 里程碑 | 交付 |
|--------|------|
| V0 方案/用例/矩阵 | 本系列 NEURO-F7-*_V0.md |
| DEV 证据 | `fpga_rb_fullnet_pl_fc_gate.json` PASS_f7_pl_fc |
| TEST EXEC | outbox + wo-verify 证据 |
| UAT | 总裁审阅报告 |

---

## 9. 追溯

| OR | FT | SR | AR | 测试方案章节 |
|----|----|----|-----|--------------|
| OR-NEURO-DEMO-001 | FT-F7-PL-FC | SR-F7-GATE-EVIDENCE | AR-F7-GATE-SCRIPT | §3 · §4 · §6 |
| F7 design spec §2 | fc+LIF on PL | 证据 JSON | linear_mac / lif_step | §4.1 |

---

*2026-08-04 · 陈正齐 · WO-TEST-NEURO-F7-PL-FC · reviewer 陈方瑟（禁止自评）*
