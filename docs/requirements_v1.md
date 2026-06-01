# 类脑计算项目 · 需求分析 v1

> **负责人**：陈正共 · **相对 v0**：冻结基准任务与第一阶段范围；其余能力分阶段纳入。

---

## 1. 已冻结决策（相对 v0 开放问题）

| 项 | v1 结论 |
|----|---------|
| **基准任务** | **MNIST** 手写数字分类（10 类，28×28 灰度） |
| **第一阶段** | **SNN 仿真**（GPU/WSL + PyTorch + snnTorch）；**不要求** Atlas/FPGA 上板 |
| **类脑形态** | 首版为 **脉冲神经网络仿真**；ANN 基线作为对照（同数据集，后续脚本补充） |
| **小样本 / 自学习** | **v1 不验收**；保留为 v2 方向 |
| **Atlas / FPGA** | **v1 不验收**；v2 起做推理/转换 PoC |
| **能效** | v1 仅记录 **训练耗时、参数量、测试准确率**；墙插功耗 v2 |

---

## 2. 功能需求（v1 范围）

- [x] **F1-v1** MNIST 数据加载与预处理（归一化、train/test 划分）  
- [x] **F1-v1** SNN 训练脚本可复现（固定随机种子、可配置 epoch/batch/lr）  
- [x] **F1-v1** 训练日志与 checkpoint 输出目录约定（`runs/`）  
- [x] **F1-v1** 单次训练在 4090/WSL 上跑通并记录 **测试集准确率**（2026-05-27：**96.97%**，≥90% 及格线已通过）  
- [x] **F2-v1** 推理/评估：`train_mnist_snn.py --eval-only --checkpoint …`（与训练同指标）  
- [x] **F6-v1** `requirements.txt` + README + `.venv` 一键说明  

**v1 明确不做**：小样本（F3）、自学习（F4）、Atlas/FPGA 部署（F2 硬件）、飞书日报自动化（可并行，非 v1 阻塞）。

---

## 3. 非功能需求（v1）

| 类型 | v1 指标 |
|------|---------|
| 可复现性 | `python scripts/train_mnist_snn.py --seed 42` 可重复；依赖见 `requirements.txt` |
| 精度 | MNIST test accuracy 写入 `runs/.../metrics.json` |
| 环境 | Python 3.10+，CUDA 可选（无 GPU 时 CPU 可冒烟，性能不保证） |

---

## 4. 目录与交付物

```
neuromorphic-computing/
  docs/requirements_v0.md
  docs/requirements_v1.md      # 本文档
  scripts/train_mnist_snn.py   # 阶段一主入口
  requirements.txt
  runs/                        # gitignore，实验输出
```

---

## 5. 阶段路线图

| 阶段 | 内容 | 状态 |
|------|------|------|
| **Phase 1** | MNIST + SNN 仿真（训练/评估） | **首跑完成**（TR1 已通过，基线固化） |
| Phase 2 | ANN 基线 + 与 SNN 对比表 | **首跑完成**（98.10%，对比表初稿） |
| Phase 3 | 小样本 / 自学习 PoC | 未开始 |
| Phase 4 | Atlas / FPGA 推理验证 | 未开始 |

---

*v1 生效日期：2026-05-13 · 陈正共*
