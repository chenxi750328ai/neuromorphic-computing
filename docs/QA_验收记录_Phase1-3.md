# 类脑计算 · QA 验收记录（Phase 1–3 · 研究轨）

> **用途**：VP QA 签字真源；`scripts/qa-neuro-phase-signoff.py --check` 检索 `VP QA: PASS`  
> **裁剪方案**：[`IPD-QA流程裁剪_待VP总裁批准.md`](./IPD-QA流程裁剪_待VP总裁批准.md)  
> **状态**：✅ VP 已确认（2026-06-08）· ⏳ **总裁批准裁剪方案后** VP 填 signoff PASS

---

## 1. 追溯验收（Retrospective · 4090 手跑）

| Phase | 脚本 | 指标 | 及格线 | 结果 | 留档 |
|-------|------|------|--------|------|------|
| Phase1 SNN | `scripts/train_mnist_snn.py` | test acc **96.97%** | ≥90% | **PASS** | `runs/20260527T092534Z/metrics.json` |
| Phase2 ANN | `scripts/train_mnist_ann.py` | test acc **98.10%** | ≥90% | **PASS** | `runs/20260530T010904Z_ann/metrics.json` |
| Phase3 小样本 | `train_mnist_fewshot*.py`（feature 分支） | ANN 微调 5-shot **96.32%**；SNN **89.23%** | 路线验证 | **PASS（工程结论）** | 见 `phase3_fewshot_results.md`（待 PR #2 合 main） |

**结论**：v1 训练/对照/小样本路线 **达标**；Phase3 代码合 main 后本记录 §1 链接须更新。

---

## 2. CI 验收（本 PR 起）

| 检查 | 命令 | 期望 |
|------|------|------|
| 研究轨 CI | `python3 scripts/qa-neuro-baseline-run.py --tier ci` | 全绿 |
| GitHub | `.github/workflows/ci.yml` `neuro-ci` | PR 触发 |

---

## 3. 审批签字（生效前勿改 SIGNOFF 块）

<!-- SIGNOFF-START -->
```signoff
VP_QA: PENDING
PRESIDENT: PENDING
SIGNED_AT:
```
<!-- SIGNOFF-END -->

| 角色 | 状态 | 说明 |
|------|------|------|
| **陈正共** | 已提交材料 | 2026-06-08 起草 CI + 裁剪方案 |
| **VP（陈小五）** | ✅ 裁剪方案已确认 | 2026-06-08；**总裁批准后**改 signoff `VP_QA: PASS` |
| **总裁** | ⏳ 待批准 | 批准后改 signoff 块 `PRESIDENT: APPROVED` |

**生效条件**（须同时满足）：

1. signoff 块中 **`VP_QA: PASS`**  
2. signoff 块中 **`PRESIDENT: APPROVED`**  
3. `neuro-ci` 在 GitHub 至少跑通一次  

---

## 4. Phase4 前置（批准后执行）

- [ ] TR2 轻评审：Atlas 200DK A2 / FPGA 推理 PoC 方案  
- [ ] 新建 `docs/QA_验收记录_Phase4.md`（Phase4 合 main 时用）

---

*陈正共 · ChenZhengGong*
