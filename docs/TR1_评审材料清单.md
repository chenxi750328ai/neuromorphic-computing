# TR1 · 技术评审材料清单（类脑计算）

> **负责人**：陈正共 · **评审目的**：在 Phase 1（MNIST + SNN 仿真）全面开发前，确认需求、环境与验收标准。  
> **关联看板**：[项目看板.md](./项目看板.md)

---

## 1. 评审范围（TR1 管什么、不管什么）

| TR1 包含 | TR1 不包含 |
|----------|------------|
| 需求 v0/v1 与基准任务冻结 | Atlas / FPGA 上板 |
| Phase 1 架构与目录约定 | 小样本、自学习 PoC |
| MNIST + snnTorch 仿真验收线 | 产线贴膜机等场景 KPI |
| 环境与依赖、Git 策略 | 飞书自动化（可并行，非 TR1 阻塞） |

---

## 2. 必交材料（请你逐项审）

| 序号 | 材料 | 状态 | 链接 / 位置 |
|------|------|------|-------------|
| M1 | 项目目标与资源（4090 / Atlas / FPGA / WSL） | 已有 | [README.md](../README.md) |
| M2 | 需求分析 v0（全景） | 已有 | [requirements_v0.md](./requirements_v0.md) |
| M3 | **需求 v1（评审基线）** | **总裁拍板** | [requirements_v1.md](./requirements_v1.md) · [会议纪要_TR1总裁拍板_20260528.md](./会议纪要_TR1总裁拍板_20260528.md) |
| M4 | **需求 v1 条目一览** | 已有 | [项目看板.md §三](./项目看板.md#三需求-v1-列表评审用) |
| M5 | 阶段路线图 Phase 1～4 | 已有 | [requirements_v1.md §5](./requirements_v1.md#5-阶段路线图) |
| M6 | 当前进度摘要 | 已有 | [项目看板.md §一](./项目看板.md#一当前进度摘要) |
| M7 | Phase 1 依赖清单 | 已有 | [requirements.txt](../requirements.txt) |
| M8 | Phase 1 训练/评估脚本 | **已交已跑** | [scripts/train_mnist_snn.py](../scripts/train_mnist_snn.py) |
| M9 | 实验输出约定 `runs/` | 文档已有 | [requirements_v1.md §4](./requirements_v1.md#4-目录与交付物) |
| M10 | 风险与遗留项 | 见下 §3 | — |

---

## 3. 风险与遗留项（TR1 需知情）

| 风险 / 遗留 | 说明 | 建议处理 |
|-------------|------|----------|
| Git 日常分支 | 独立仓已建，见 §4 | 开发用 `feature/*`，合并 main 走 PR |
| 日报未接飞书 | 不阻塞 TR1 | Phase 1 跑通后再接 |

---

## 4. Git 与提交约定（总裁已拍板 · 2026-05-28）

| 项 | 结论 |
|----|------|
| **策略** | **独立仓库** `chenxi750328ai/neuromorphic-computing`，与 `agent-jianghu` 并列 |
| **本机目录** | `/home/cx/neuromorphic-computing/` |
| **推送账号** | `CHENXI750328AI_GITHUB_*`（`agentfuture/.env`） |
| **提交说明** | 须含 **陈正共** 或 **ChenZhengGong**（见 [CONTRIBUTING.md](../CONTRIBUTING.md)） |
| **纪要** | [会议纪要_TR1总裁拍板_20260528.md](./会议纪要_TR1总裁拍板_20260528.md) |

---

## 5. TR1 通过标准（建议）

- [ ] 同意 **MNIST + Phase 1 SNN 仿真** 为唯一 v1 验收范围  
- [ ] 同意 **requirements_v1.md** 为开发基线（或批注修改后升 v1.1）  
- [ ] 确认 **准确率及格线**（默认 test acc ≥ 90%，可调）  
- [ ] 确认 **Git 策略**（§4）  
- [ ] 同意 Phase 1 交付：**可复现训练 + 评估 + metrics.json**

---

## 6. 评审会后动作（陈正共）

1. 按批注更新 [requirements_v1.md](./requirements_v1.md)  
2. 实现 `scripts/train_mnist_snn.py` 并更新 [项目看板.md](./项目看板.md) 进度  
3. 按选定 Git 策略首次提交（message 含「陈正共」）  
4. 将结论摘要写入 [reports/daily_progress.md](../reports/daily_progress.md)

---

*清单版本：TR1-draft · 2026-05-13 · 陈正共*
