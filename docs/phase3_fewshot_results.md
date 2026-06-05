# Phase 3 · 小样本实验结果

> 陈正共 · 本地 · 2026-06-05 更新（含 SNN）

## 总览

| 路线 | 方式 | 5-shot | 10-shot | 过 85% 线 |
|------|------|--------|---------|-----------|
| **ANN** | 从头训练 | 66.84% | 76.12% | ✗ |
| **ANN** | 全量预训练 + 微调 | **96.32%** | **96.21%** | ✓ |
| **SNN** | 从头训练 | 41.18% | — | ✗ |
| **SNN** | 全量预训练 + 微调 | **89.23%** | **92.98%** | ✓ |

全量基线：ANN **98.10%** · SNN **96.97%**

**结论：** 小样本在 ANN/SNN 上均适用 **「先全量训好 → 再用极少张微调」**；SNN 微调 5-shot 略低于 ANN（89% vs 96%），但仍过 85% 及格线。

---

## ANN · 从头训练

| K | 训练张数 | test acc | gap vs 98.10% | run_id |
|---|----------|----------|---------------|--------|
| 1 | 10 | 41.66% | 56.44pp | `20260605T030237Z_fewshot_k1` |
| 5 | 50 | 66.84% | 31.26pp | `20260605T030259Z_fewshot_k5` |
| 10 | 100 | 76.12% | 21.98pp | `20260605T030321Z_fewshot_k10` |

## ANN · 全量微调

预训练：`runs/20260530T010904Z_ann/checkpoint.pt`

| K | test acc | run_id |
|---|----------|--------|
| 5 | **96.32%** | `20260605T031655Z_fewshot_k5` |
| 10 | **96.21%** | `20260605T031710Z_fewshot_k10` |

```bash
.venv/bin/python scripts/train_mnist_fewshot.py -k 5 \
  --warm-start runs/20260530T010904Z_ann/checkpoint.pt --epochs 20
```

## SNN · 从头训练

| K | test acc | run_id |
|---|----------|--------|
| 5 | 41.18% | `20260605T075936Z_fewshot_snn_k5` |

## SNN · 全量微调（类脑路线）

预训练：`runs/20260527T092534Z/checkpoint.pt`（全量 test 96.97%）

| K | test acc | gap vs 96.97% | run_id |
|---|----------|---------------|--------|
| 5 | **89.23%** | 7.74pp | `20260605T075828Z_fewshot_snn_k5` |
| 10 | **92.98%** | 3.99pp | `20260605T075903Z_fewshot_snn_k10` |

```bash
.venv/bin/python scripts/train_mnist_fewshot_snn.py -k 5 \
  --warm-start runs/20260527T092534Z/checkpoint.pt --epochs 20
```

---

## 复现

```bash
./scripts/run_phase3.sh   # ANN 从头 K=1,5,10 + SNN + ANN 微调（需 checkpoint 存在）
```

---

*下一步：数据增强从头训；Phase3 看板 active；GitHub 恢复后 push。*
