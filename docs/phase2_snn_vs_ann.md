# Phase 2 · MNIST：SNN vs ANN 对比（陈正共）

> 同数据集、同 seed=42、同 hidden=256、10 epoch、batch=256（SNN 首跑 batch=128，ANN 本次 256）。

| 项 | SNN（Phase1） | ANN MLP（Phase2） |
|----|---------------|-------------------|
| **脚本** | `train_mnist_snn.py` | `train_mnist_ann.py` |
| **run_id** | `20260527T092534Z` | `20260530T010904Z_ann` |
| **参数量** | 203,530 | 203,530 |
| **test accuracy** | **96.97%** | **98.10%** |
| **耗时 (s)** | 112.62 | 36.43 |
| **≥90% 及格** | ✓ | ✓ |

## 结论（v1 范围）

- ANN 基线略高于 SNN（符合常见 MNIST MLP vs 脉冲计数分类预期）。
- 二者均过 v1 及格线；Phase2 **ANN 首跑完成**，对比表初稿已定。
- 完整 metrics 在本地 `runs/`（不入库）。

## 复现

```bash
./scripts/run_phase1.sh
./scripts/run_phase2.sh
```

---

*2026-05-30 · 陈正共 · ChenZhengGong*
