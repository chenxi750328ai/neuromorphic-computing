# Phase4.1 · F4 双通证据包 · QA 集成评审意见

> **角色**：陈正孤 · QA integration  
> **日期**：2026-07-28  
> **范围**：R-A Atlas↔FPGA M-lif 入链（A2）+ R-B 分时整网跑通（B1）  
> **依据**：研究轨 IPD（CI 不裁 · QA 追溯 · 见 `docs/IPD-QA流程裁剪_待VP总裁批准.md`）  
> **PR**：https://github.com/chenxi750328ai/neuromorphic-computing/pull/17

---

## 1. 总 verdict

| 字段 | 值 |
|------|-----|
| **integrationVerdict** | **PASS_WITH_NOTE** |
| **功能双通** | 认可（A2 + B1 机读 PASS） |
| **延迟/G-LAT** | 未过尺（已诚实披露，见 §3） |
| **并行整网** | 仍 FAIL（合法保留，见 §4） |
| **合 main 前置** | 见 §6 备注项（非本包 BLOCK） |

---

## 2. 追溯与数字自洽（§2.1 双路 PASS JSON）

### 2.1 R-A · A2 Atlas↔PYNQ M-lif 入链

| 检项 | 标准 | 证据 | 复核 |
|------|------|------|------|
| 机读 verdict | `PASS_*` | `PASS_ra_atlas_fpga_mlif` | ✓ |
| 样本量 n | ≥20 | 20 | ✓ |
| pred 一致 | match_rate ≥0.98 | 20/20 = **1.0** | ✓ |
| 标签 acc | ≥0.90 | 19/20 = **0.95** | ✓ |
| host↔Atlas pred | 逐样本一致 | `host_proxy.preds` ≡ `atlas_client.preds`（20/20） | ✓ |
| 延迟披露 | 含 `avg_*_ms` | `avg_e2e_ms=993.333`，`avg_fpga_lif1_ms=914.047` | ✓ |

**算术抽检**：`19866.657 / 20 = 993.333`；`18280.947 / 20 = 914.047` — 与 JSON 一致。  
**唯一错分**：index 8，label=5 vs pred=6（与 R-B 同源，非双路不一致）。

**证据路径**：`docs/phase4_poc_evidence/fpga_ra_atlas_mlif_inchain_gate.json`

### 2.2 R-B · B1 分时整网跑通

| 检项 | 标准 | 证据 | 复核 |
|------|------|------|------|
| 机读 verdict | `PASS_*` | `PASS_rb_tmd_fullnet` | ✓ |
| 样本量 n | ≥20 | 20 | ✓ |
| pred 一致 | match_rate ≥0.98 | 20/20 = **1.0** | ✓ |
| 标签 acc | ≥0.90 | 19/20 = **0.95** | ✓ |
| host↔board pred | 逐样本一致 | `host_proxy.preds` ≡ `board.preds`（20/20） | ✓ |
| 模式声明 | 非并行整网 | `mode: time_mux_not_parallel` | ✓ |
| 延迟披露 | 含 `avg_*_ms` | `avg_e2e_ms=1450.013`，`avg_lif_pl_ms=976.41` | ✓ |

**算术抽检**：`29000.258 / 20 = 1450.013`；`19528.209 / 20 = 976.410` — 与 JSON 一致。  
**note 字段**：「并行资源墙仍成立；本闸证明分时整网可跑通」— 叙事边界清晰。

**证据路径**：`docs/phase4_poc_evidence/fpga_rb_fullnet_runthrough_gate.json`

### 2.3 机读汇总门禁

本地复跑：

```bash
.venv/bin/python3 scripts/phase4_fpga_both_runthrough_evidence_gate.py --gate
```

**结果**：`PASS phase4_fpga_both_runthrough_evidence_gate`（exit 0）。

---

## 3. 延迟诚实披露（禁止功能 PASS 冒充 G-LAT 过尺）

| 尺子 | 口径 | 数值 |
|------|------|------|
| **G-LAT** | Atlas 整网 daemon 稳态 | p50≈**3.5 ms**/样本（#13 已过） |
| **A2 双通** | Atlas↔FPGA M-lif 入链 | avg_e2e≈**993 ms**/样本 |
| **B1 双通** | 板侧分时整网 | avg_e2e≈**1450 ms**/样本 |

**QA 判定**：

- 双通路径比 G-LAT 慢 **两个数量级以上**（约 280×–410×）。
- JSON 含 `avg_*_ms` 字段；`docs/QA_验收记录_Phase4.1_FPGA双通.md` §0 有「远逊 G-LAT / MMIO / 分时」人话说明。
- 两路 verdict 字符串均为功能跑通语义（`PASS_ra_*` / `PASS_rb_*`），**未**宣称 G-LAT 合格。
- **结论**：延迟破尺已记账，不构成假绿。**功能 PASS ≠ 延迟过 G-LAT** — 接受为 NOTE，非 BLOCK。

---

## 4. 并行资源墙 FAIL 保留（防叙事漂移）

| 项 | 状态 | 证据 |
|----|------|------|
| R-B 并行整网 on Z2 | **FAIL（合法）** | `fpga_rb_fullnet_platform_gate.json` |
| platform flag | `false` | `platform_available_rb_on_pynq_z2_parallel: false` |
| conclusion | 资源墙 | `FAIL_parallel_fullnet_on_z2_resource_wall` |
| B1 跑通形态 | 分时复用 | `time_mux_not_parallel` + note 引用资源墙 |

**QA 判定**：并行阵列不可用结论 **未被 B1 分时 PASS 覆盖或稀释**；QA 验收记录 F4-PAR 行仍为 FAIL（合法）。✓

---

## 5. 研究轨 QA 追溯映射

| IPD 环节 | 本包 | QA 意见 |
|----------|------|---------|
| 设计 | `docs/plans/2026-07-28-fpga-both-routes-runthrough.md` | 与 A2/B1 判据对齐 ✓ |
| 开发 | PR #17 · 证据 JSON | 可追溯 ✓ |
| 测试 | 门禁脚本 + N=20 复现命令 | 机读 gate 绿 ✓ |
| QA | 本文件 + `QA_验收记录_Phase4.1_FPGA双通.md` | 本轮回执 |
| CI | `neuro-ci` | **待合入前复核**（见 NOTE-1） |

**交叉评审**：`F4-TE-测试方案与用例要点.md` **尚未落盘**（TE 本轮派发中）— 见 NOTE-2。

---

## 6. NOTE 清单（PASS_WITH_NOTE 条件）

| ID | 级别 | 项 | 说明 |
|----|------|-----|------|
| NOTE-1 | 合入前 | F4-CI `neuro-ci` 绿 | QA 记录 §1 F4-CI 为「待合入前复核」；研究轨 CI 不可裁 |
| NOTE-2 | 追溯 | TE 测试方案未落盘 | `ipd/F4-TE-测试方案与用例要点.md` 缺失；建议 TE 补签后 VP 一并收束 |
| NOTE-3 | 口径 | 延迟远逊 G-LAT | A2≈0.99 s/样本、B1≈1.45 s/样本；对外表述须区分「功能跑通」与「性能过尺」 |
| NOTE-4 | 流程 | VP / 总裁签字栏 | `QA_验收记录` signoff 仍为 PENDING；本 QA 意见不替代 VP QA: PASS |

**BLOCK 项**：**无**（证据包本体未发现追溯断裂、数字不自洽、延迟假绿或并行墙叙事漂移）。

---

## 7. 签字

```signoff
QA_INTEGRATION: PASS_WITH_NOTE
QA_REVIEWER: 陈正孤 · ag-chenzhenggu
SIGNED_AT: 2026-07-28
BLOCK_ITEMS: (none)
NOTES: NOTE-1..NOTE-4
EVIDENCE_GATE: PASS (local --gate 2026-07-28)
```

---

*陈正孤 · QA · 2026-07-28*
