# 类脑计算 · QA 验收记录（Phase 4 · 推理 PoC）

> **用途**：Phase4 合 main 前 VP QA 检索；`scripts/qa-neuro-phase-signoff.py` 可扩展 Phase4 块  
> **方案**：[TR2_Phase4_轻评审草案](./TR2_Phase4_轻评审草案.md) · [phase4_inference_poc_plan.md](./phase4_inference_poc_plan.md)

---

## 1. 追溯验收（PoC）

| 项 | 标准 | 结果 | 留档 |
|----|------|------|------|
| S1 · 4090 复现 | test acc ≥96% | **PASS** 96.97% | `runs/20260608T090726Z/metrics.json` |
| S2 · SNN ONNX | 直接导出 | **WARN** snnTorch LIF + 缺 onnx 包 | `runs/phase4_export/export_notes.md` |
| S2b · ANN 近似 ONNX | 兜底 IR | **PASS** `model_ann_surrogate.onnx` | `runs/phase4_export/surrogate_manifest.json` |
| S2 · CPU 冒烟 | ONNXRuntime 前向 | **PASS** `(1,10)` | 2026-06-22 本地 |
| S3 · 硬件冒烟 | Atlas MNIST-surrogate OM | **PASS** ~0.86ms | `runs/phase4_poc/atlas_smoke.log` |
| S4 · CI | `neuro-ci` 绿 | **PASS** | [PR #3](https://github.com/chenxi750328ai/neuromorphic-computing/pull/3) · merge `ddabfcd` |

---

## 2. CI 验收

| 检查 | 命令 | 期望 |
|------|------|------|
| 研究轨 CI | `python3 scripts/qa-neuro-baseline-run.py --tier ci` | 全绿 |
| Phase4 脚本 | `tests/test_smoke.py` + 新增 export 测试（若有） | 通过 |

---

## 3. 审批签字

<!-- SIGNOFF-START -->
```signoff
VP_QA: PENDING
PRESIDENT: N/A
SIGNED_AT: 
NOTE: Phase4 PoC；VP 可后补签字
```
<!-- SIGNOFF-END -->

---

*陈正共 · ChenZhengGong*
