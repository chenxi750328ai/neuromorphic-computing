# Phase 3 · 小样本学习需求草案（v0）

> **负责人**：陈正共 · **状态**：v0 本地已跑通（见 `phase3_fewshot_results.md`）  
> **前置**：Phase1 SNN 96.97%、Phase2 ANN 98.10%（MNIST 全量训练基线）

## 1. 目标

在 **MNIST 子集**上验证「少标注样本仍可达可接受精度」，并与 Phase1/2 全量基线 **可比、可复现**。

## 2. 范围（v0 建议）

| 项 | 建议 |
|----|------|
| 数据集 | MNIST；训练集仅取每类 **K-shot**（如 K=1,5,10） |
| 模型 | 先 **ANN MLP**（与 Phase2 同结构），再可选 SNN 对照 |
| 方法 | **v0 已做**：从头训练（A）+ 全量 ANN 微调（B，5-shot **96.32%**）；v0.2：SNN 微调、meta-learning |
| 指标 | test accuracy、与全量 98.10% 的 **gap**、训练耗时 |
| 及格线（待定） | 例：5-shot 每类，test acc ≥85%（评审时冻结） |

## 3. 非目标（v0）

- 自学习 / 持续学习（归 Phase3b 或 v2 单独立项）
- Atlas / FPGA 部署
- 非 MNIST 数据集

## 4. 交付物（计划）

- `scripts/train_mnist_fewshot.py`（或扩展现有 ANN 脚本 `--shots-per-class`）
- `docs/phase3_fewshot_results.md` + `runs/<id>/metrics.json`
- 看板 Phase3 门栏从 `future` → `active`

## 5. 开放问题

1. K-shot 固定为 {1,5,10} 还是只做 5-shot？  
2. SNN 小样本是否纳入 Phase3 v0，还是 ANN-only？  
3. 与 CHARTER/CDT 中「类脑小样本」表述的对齐说明（另文 `docs/cdt_v1_stack_alignment.md` 待写）。

---

*2026-06-04 · 陈正共 · ChenZhengGong*
