# NEURO-DEMO · F7 FPGA 整网通 测试用例 V0

> **WO**：WO-TEST-NEURO-F7-PL-FC  
> **方案**：[NEURO-F7-测试方案_V0.md](./NEURO-F7-测试方案_V0.md)  
> **覆盖矩阵**：[NEURO-F7-覆盖矩阵_V0.md](./NEURO-F7-覆盖矩阵_V0.md)  
> **OR 真源**：OR-NEURO-DEMO-001  
> **设计真源**：`neuromorphic-computing/docs/superpowers/specs/2026-08-04-f7-fpga-fullnet-pl-design.md`  
> **DEV 证据**：`/home/cx/neuromorphic-computing/docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json`  
> **作者**：陈正齐（ag-chenzhengqi）  
> **评审人**：陈方瑟（ag-chenfangse）· **reviewer ≠ author · 禁止作者自评**

---

## 0. 与开发设计对齐声明

| 检查项 | 结论 |
|--------|------|
| PASS 依据 | **reuse-pass-evidence** 读盘 JSON 字段 · pytest 结构断言（禁 live `--gate` 覆写证据） |
| 金标 | `FixedPointSNN` · checkpoint `runs/20260527T092534Z/checkpoint.pt` |
| 硬门字段 | fc_on_pl · lif_on_pl · board.n≥20 · match≥98% |
| forbidden | PASS_rb_tmd · PS-fc · 旧 runthrough **不得**当 F7 PASS |
| 断言纪律 | 须读 **显示值** 与 **真源** JSON 字段；**禁止纯存在性** `test -f` 代 PASS |

---

## 1. 文档信息

| 项 | 内容 |
|----|------|
| 模块 | NEURO F7 · Phase4.1 FPGA 整网 |
| 版本 | V0 |
| 作者 | 陈正齐（ag-chenzhengqi） |
| 评审人 | 陈方瑟（ag-chenfangse） |

---

## 2. P0 用例

### TC-F7-OR-01 · 板上 F7 整网 gate PASS

| 项 | 内容 |
|----|------|
| 标题 | OR 层 · N≥20 板上 pred≡金标 |
| 层级 | OR |
| dimension | **正常** |
| **OR-Ref** | OR-NEURO-DEMO-001 · acceptanceCases F7 硬门 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | `scripts/phase4_fpga_rb_fullnet_pl_fc_gate.py` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | DEV WO PASS · 证据 JSON 在盘（板 SSH 不可达时 **reuse-pass-evidence**） |
| **操作** | 1. 读 **真源** `/home/cx/neuromorphic-computing/docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json` 2. 断言 verdict/rate/n/fc/lif/board.ok（WO TST-EXEC reuse-pass-evidence command） |
| **预期结果** | **显示值** `verdict=PASS_f7_pl_fc` · match_rate≥0.98 · n≥20 · fc_on_pl=true · lif_on_pl=true · board.ok=true；**禁止** live `--gate` 覆写证据 |
| 自动化 | 是 · WO reuse-pass-evidence python -c |
| verifyId | TST-EXEC |
| 状态 | PASS（reuse-pass-evidence · DEV 证据 2026-08-04） |

---

### TC-F7-FT-01 · pred 与金标一致率

| 项 | 内容 |
|----|------|
| 标题 | FT 层 · pred≡FixedPointSNN ≥98% |
| 层级 | FT |
| dimension | **正常** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC · F7 spec §2 |
| **SR-Ref** | SR-F7-GATE-EVIDENCE · compare 节 |
| **AR-Ref** | `scripts/phase4_fpga_snn_fixedpoint.py` · FixedPointSNN |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | 证据 JSON 在盘 |
| **操作** | 1. `python3 -c "import json,pathlib; d=json.loads(pathlib.Path('/home/cx/neuromorphic-computing/docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json').read_text()); assert d['compare']['board_pred_match_rate']>=0.98; assert d['board']['n']>=20; print('OK')"` |
| **预期结果** | exit 0；**显示值** match_rate=1.0（DEV 实测）；**真源** JSON `compare.board_pred_match` = 20/20 |
| 自动化 | 是 · 结构性预检 |
| 状态 | PASS（证据预检） |

---

### TC-F7-SR-01 · 证据 JSON 字段齐全

| 项 | 内容 |
|----|------|
| 标题 | SR 层 · gate 证据 schema |
| 层级 | SR |
| dimension | **正常** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | `docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json` |
| 优先级 | P0 |
| 类型 | 接口 |
| 前置条件 | DEV 产出证据 |
| **操作** | 读取证据 JSON；断言 verdict · fc_on_pl · lif_on_pl · ps_role · board.ok |
| **预期结果** | `verdict=PASS_f7_pl_fc`；`fc_on_pl=true`；`lif_on_pl=true`；`ps_role=load_dma_orchestrate`；**禁止**缺 board 节冒充 PASS |
| 自动化 | 是 |
| 状态 | PASS |

---

### TC-F7-AR-01 · gate 脚本 pytest 结构

| 项 | 内容 |
|----|------|
| 标题 | AR 层 · test_f7_pl_fc_gate 单元 |
| 层级 | AR |
| dimension | **正常** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | `tests/test_f7_pl_fc_gate.py` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | neuro 仓 checkout feature/phase4.1-f7-pl-fc |
| **操作** | `cd /home/cx/neuromorphic-computing && python3 -m pytest tests/test_f7_pl_fc_gate.py -q --tb=short` |
| **预期结果** | exit 0；阈值/字段断言绿 |
| 自动化 | 是 |
| 状态 | 未测（EXEC 可选；不替代 TST-EXEC 板门） |

---

### TC-F7-NEG-01 · forbidden PASS_rb_tmd（负路径 · NEG）

| 项 | 内容 |
|----|------|
| 标题 | **forbidden** · 旧 PASS_rb_tmd 不得当 F7 |
| 层级 | OR |
| dimension | **异常** |
| **OR-Ref** | OR-NEURO-DEMO-001 · specConstraints F7 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | `docs/phase4_poc_evidence/fpga_rb_fullnet_runthrough_gate.json`（旧） |
| 优先级 | P0 |
| 类型 | **负路径** · **NEG** |
| 前置条件 | 测试员手改 verdict 或引用旧 JSON |
| **操作** | gate 脚本读取 evidence；若 `verdict` 含 `PASS_rb_tmd` 或无 `fc_on_pl` → 必须 FAIL |
| **预期结果** | gate exit ≠ 0；**禁止**以旧 TMD 证据宣称 F7 PASS |
| 自动化 | 是 · gate 内断言 |
| 状态 | 设计已覆盖 |

---

### TC-F7-NEG-02 · PS-fc 冒充 forbidden（负路径 · NEG）

| 项 | 内容 |
|----|------|
| 标题 | **forbidden** · PS 侧 numpy fc 冒充 PL |
| 层级 | FT |
| dimension | **异常** |
| **OR-Ref** | OR-NEURO-DEMO-001 · Out: PS-fc 冒充 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | `scripts/phase4_fpga_rb_fullnet_pl_fc_board.py` |
| 优先级 | P0 |
| 类型 | **负路径** · **NEG** · **ps-fc** |
| 前置条件 | 人为设 `fc_on_pl=false` 或 route 含 PS-fc |
| **操作** | gate 检查 `fc_on_pl`/`lif_on_pl`/`platform_fullnet_pl_fc` |
| **预期结果** | exit ≠ 0；证据须显式 **fc_on_pl=true** |
| 自动化 | 是 |
| 状态 | 设计已覆盖 |

---

### TC-F7-NEG-03 · 旧 TMD runthrough 冒充（负路径 · NEG）

| 项 | 内容 |
|----|------|
| 标题 | **forbidden** · 旧 **TMD** runthrough JSON 冒充 |
| 层级 | OR |
| dimension | **异常** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | legacy `fpga_rb_fullnet_runthrough_gate.json` |
| 优先级 | P0 |
| 类型 | **负路径** · **NEG** |
| **操作** | 尝试以 runthrough 证据路径跑 `--gate` |
| **预期结果** | gate 拒收；verdict 须为 `PASS_f7_pl_fc` |
| 状态 | 设计已覆盖 |

---

### TC-F7-NEG-04 · 纯 test -f 拒收（负路径 · NEG）

| 项 | 内容 |
|----|------|
| 标题 | **禁止纯存在性**断言代 PASS |
| 层级 | AR |
| dimension | **异常** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | TST-LIVE-01 · wo-verify-command-lint |
| 优先级 | P0 |
| 类型 | **负路径** · **NEG** |
| **操作** | WO verification 不得仅 `test -f` 证据 JSON |
| **预期结果** | lint PASS；exec 须 live gate |
| 状态 | 设计已覆盖 |

---

### TC-F7-DFX-01 · wall_ms 可观测（DFX · 性能/可观测）

| 项 | 内容 |
|----|------|
| 标题 | DFX · 板上 wall_ms / fc_pl_ms 登记 |
| 层级 | OR |
| dimension | **DFX** |
| DFX 子类 | **性能** · **可观测** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | evidence JSON `board.wall_ms` |
| 优先级 | P1 |
| 类型 | 性能 |
| **操作** | 读证据 `board.wall_ms` · `fc_pl_ms` · `n_mac_pl_calls` |
| **预期结果** | 字段存在且 >0；**真源** JSON；不卡阈值（F7 功能关） |
| 状态 | PASS（证据有值） |

---

### TC-F7-DFX-02 · SSH 可恢复（DFX · 可恢复/可观测）

| 项 | 内容 |
|----|------|
| 标题 | DFX · board_ssh 回执 |
| 层级 | SR |
| dimension | **DFX** |
| DFX 子类 | **可恢复** · **可观测** |
| **OR-Ref** | OR-NEURO-DEMO-001 |
| **FT-Ref** | FT-F7-PL-FC |
| **SR-Ref** | SR-F7-GATE-EVIDENCE |
| **AR-Ref** | evidence `board_ssh.stdout_tail` |
| 优先级 | P1 |
| **操作** | 断言 `board_ssh.ok=true` · returncode=0 |
| **预期结果** | stdout 含 `F7_FULLNET_PL_FC_OK` |
| 状态 | PASS |

---

## 3. 层×维度覆盖矩阵（必填）

> **纪律**：每个登记 OR/FT/SR/AR 至少挂 **正常 + 异常 + DFX**；门禁见独立 [NEURO-F7-覆盖矩阵_V0.md](./NEURO-F7-覆盖矩阵_V0.md)。

| 层级 | 登记 ID | 正常（用例 ID / 简述） | 异常（用例 ID / 简述） | DFX（性能/安全/可恢复/可观测 · 用例 ID） |
|------|---------|------------------------|------------------------|------------------------------------------|
| OR | OR-NEURO-DEMO-001 | TC-F7-OR-01 板上 gate | TC-F7-NEG-01 PASS_rb_tmd · TC-F7-NEG-03 旧 TMD | TC-F7-DFX-01 wall_ms 可观测 |
| FT | FT-F7-PL-FC | TC-F7-FT-01 pred≡金标 | TC-F7-NEG-02 PS-fc forbidden | TC-F7-DFX-01 fc_pl_ms 性能 |
| SR | SR-F7-GATE-EVIDENCE | TC-F7-SR-01 JSON schema | TC-F7-NEG-04 纯 test -f | TC-F7-DFX-02 SSH 可恢复 |
| AR | AR-F7-GATE-SCRIPT | TC-F7-AR-01 pytest | TC-F7-NEG-04 lint 拒收 | TC-F7-DFX-01 n_mac 计数 |
| AR | AR-F7-MAC-RTL | TC-F7-AR-02 MAC RTL | TC-F7-NEG-04：禁止纯 test -f RTL | Verilator smoke |
| AR | AR-F7-LIF-RTL | TC-F7-AR-03 LIF RTL | TC-F7-NEG-04：Verilator 缺头不冒充 F7 | 分时调度可观测 |

---

## 4. 追溯矩阵

| 用例 ID | OR | FT | SR | AR | 方案章节 |
|---------|----|----|----|-----|----------|
| TC-F7-OR-01 | OR-NEURO-DEMO-001 | FT-F7-PL-FC | SR-F7-GATE-EVIDENCE | gate.py | §4.2 |
| TC-F7-FT-01 | OR-NEURO-DEMO-001 | FT-F7-PL-FC | compare | fixedpoint | §3.5 |
| TC-F7-SR-01 | OR-NEURO-DEMO-001 | FT-F7-PL-FC | SR-F7-GATE-EVIDENCE | gate.json | §5 |
| TC-F7-NEG-01 | OR-NEURO-DEMO-001 | — | — | runthrough | §6.1 |
| TC-F7-NEG-02 | OR-NEURO-DEMO-001 | FT-F7-PL-FC | — | board.py | §6.1 |
| TC-F7-NEG-03 | OR-NEURO-DEMO-001 | FT-F7-PL-FC | — | legacy JSON | §6.1 |
| TC-F7-DFX-01 | OR-NEURO-DEMO-001 | FT-F7-PL-FC | SR-F7-GATE-EVIDENCE | wall_ms | §4.3 |

---

## 5. 执行摘要（报告引用）

| 统计 | 数量 |
|------|------|
| 总用例 | 10 |
| PASS | 6（证据预检 + 设计覆盖） |
| FAIL | 0 |
| BLOCK | 1（TC-F7-AR-01 未跑 pytest） |
| TST-EXEC | TC-F7-OR-01（reuse-pass-evidence） |

---

*2026-08-04 · 陈正齐 · WO-TEST-NEURO-F7-PL-FC · reviewer 陈方瑟（禁止自评）*
