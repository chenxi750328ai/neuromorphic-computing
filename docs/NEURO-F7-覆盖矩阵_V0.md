# NEURO-DEMO · F7 FPGA 整网通 覆盖矩阵 V0

> **WO**：WO-TEST-NEURO-F7-PL-FC  
> **方案**：[NEURO-F7-测试方案_V0.md](./NEURO-F7-测试方案_V0.md)  
> **用例**：[NEURO-F7-测试用例_V0.md](./NEURO-F7-测试用例_V0.md)  
> **OR 真源**：OR-NEURO-DEMO-001  
> **作者**：陈正齐（ag-chenzhengqi）  
> **评审人**：陈方瑟（ag-chenfangse）· **reviewer ≠ author · 禁止作者自评**

---

## 1. 文档信息

| 项 | 内容 |
|----|------|
| 模块 | NEURO F7 · 层×维度覆盖矩阵 |
| 版本 | V0 |
| buildScopeInventory | OR-NEURO-DEMO-001 · FT-F7-PL-FC · SR-F7-GATE-EVIDENCE · AR-F7-* |
| 豁免 | CCB skipped · frozen_scope=B · 总裁 2026-08-04 |

---

## 2. 层×维度覆盖矩阵（必填）

> **门禁**：`python3 scripts/m0-test-coverage-matrix-gate.py --gate --layer {OR,FT,SR,AR} --artifact docs/neuromorphic-computing/NEURO-F7-覆盖矩阵_V0.md`  
> **维度**：**正常** · **异常** · **DFX**（子类：性能 / 安全 / 可恢复 / 可观测）

| 层级 | 登记 ID | 正常 | 异常 | DFX |
|------|---------|------|------|-----|
| OR | OR-NEURO-DEMO-001 | TC-F7-OR-01：板上 N≥20 gate PASS_f7_pl_fc | TC-F7-NEG-01：forbidden PASS_rb_tmd 拒收；TC-F7-NEG-03：旧 TMD runthrough 冒充 FAIL | TC-F7-DFX-01：wall_ms/fc_pl_ms 性能可观测 |
| FT | FT-F7-PL-FC | TC-F7-FT-01：pred≡金标≥98%（N=20 match=100%） | TC-F7-NEG-02：PS-fc forbidden · fc_on_pl 必须 true | TC-F7-DFX-01：fc_pl_ms · n_mac_pl_calls 计数 |
| SR | SR-F7-GATE-EVIDENCE | TC-F7-SR-01：JSON verdict/fc_on_pl/lif_on_pl/ps_role 齐全 | TC-F7-NEG-04：禁止纯 test -f 证据冒充 | TC-F7-DFX-02：board_ssh 可恢复 · stdout F7_FULLNET_PL_FC_OK |
| AR | AR-F7-GATE-SCRIPT | TC-F7-AR-01：pytest test_f7_pl_fc_gate 结构绿 | TC-F7-NEG-04：WO lint 拒收 test -f exec | TC-F7-DFX-01：gate 脚本 n_lif_pl_calls 可观测 |
| AR | AR-F7-MAC-RTL | TC-F7-AR-02：linear_mac Verilator 单行点积（辅助） | TC-F7-NEG-04：禁止纯 test -f RTL 冒充 | Verilator smoke 日志（可 FAIL 不阻 F7） |
| AR | AR-F7-LIF-RTL | TC-F7-AR-03：lif_step 与 MAC 分时（辅助） | TC-F7-NEG-04：Verilator 缺 Vlif_step.h 不冒充板 PASS | lif_pl_ms 可观测 |

---

## 3. 登记对象说明

| 登记对象 | 来源 | 备注 |
|---------|------|------|
| OR-NEURO-DEMO-001 | `data/tr1-or-list.json` | Phase4.1 F7 写入 acceptanceCases |
| FT-F7-PL-FC | F7 design spec §2–§3 | fc+LIF on PL 分时特性 |
| SR-F7-GATE-EVIDENCE | DEV 交付 evidence JSON | 可对读 WO-DEV-NEURO-F7-PL-FC |
| AR-F7-GATE-SCRIPT | `scripts/phase4_fpga_rb_fullnet_pl_fc_gate.py` | TST-EXEC 命令真源 |
| AR-F7-MAC-RTL | `fpga/rtl/linear_mac.v` | MAC RTL |
| AR-F7-LIF-RTL | `fpga/rtl/lif_step.v` | LIF RTL |

---

## 4. DFX 子类映射

| DFX 子类 | 对应用例 | 度量 |
|----------|----------|------|
| 性能 | TC-F7-DFX-01 | wall_ms · fc_pl_ms |
| 安全 | — | F7 范围外（威胁模型另 WO） |
| 可恢复 | TC-F7-DFX-02 | board_ssh returncode |
| 可观测 | TC-F7-DFX-01/02 | n_mac_pl_calls · stdout_tail |

---

*2026-08-04 · 陈正齐 · WO-TEST-NEURO-F7-PL-FC*
