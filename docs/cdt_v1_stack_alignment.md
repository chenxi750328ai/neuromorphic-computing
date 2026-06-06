# CDT 与技术栈对齐说明（CHARTER vs TR1 v1 实际栈）

> 陈正共 · 2026-06-06 · 解决长期标注「CDT 与 v1 栈需书面对齐」

## 1. 背景

两个文档指向不同技术栈：

| 文档 | 日期 | 框架 | 数据集 | 部署目标 |
|------|------|------|--------|----------|
| **CHARTER**（立项章程） | 2026-05-22 | **SpikingJelly** 0.0.14 | **N-MNIST**（神经形态事件） | Xilinx FPGA |
| **TR1 v1**（总裁拍板开发基线） | 2026-05-28 | **snnTorch** | **MNIST**（普通帧图） | 仅 GPU 仿真 |
| **CDT/Gemini** | 2026-05-22 | 建议 SpikingJelly | 两者都提 | FPGA（Zynq+PYNQ） |

## 2. 为什么 v1 选了 snnTorch + MNIST 而非 CHARTER 的 SpikingJelly + N-MNIST？

| 考量 | v1 选择理由 |
|------|------------|
| **启动速度** | snnTorch API 与 PyTorch `nn.Module` 几乎一致，当天可写出训练脚本；N-MNIST 需额外事件编码/时间窗预处理 |
| **工程环境** | snnTorch 与现有 `.venv`（torch + snnTorch）一体；SpikingJelly 需 CUDA 扩展编译（曾遇 4090 兼容问题） |
| **TR1 门槛** | 总裁评审明确要求「**可复现、有指标**」，不要求必须是事件数据集；MNIST 全量 6 万张基线更易验证 |
| **CHARTER 的角色** | CHARTER 是 **长期架构方向声明**（目标：FPGA + SNN 边缘），非 v1 阶段绑定合同；v1 仅需第一条「SNN 能训通」 |

## 3. 当前差距

| 维度 | CHARTER 期望 | v1 实际 | 差距评估 |
|------|-------------|---------|----------|
| 框架 | SpikingJelly | snnTorch | 低风险：二者均 PyTorch SNN 仿真，迁移成本约 1–2 天 |
| 数据集 | N-MNIST（事件） | MNIST（帧） | 中风险：事件编码管线需新建；v2 接入 |
| FPGA 路径 | HLS4ML / FINN | 未启动 | 原定 M2（2026-08），v1 明确不验收 |
| 陈正飞/陈正孤 | 待 DM 确认 | 未推进 | 非技术阻塞，需 PL 跟进 |

## 4. 对齐路径

**Phase4（Atlas/FPGA）前：**

1. **MNIST 上跑通 SpikingJelly 对照实验**（与 snnTorch 同参数量、同 epoch，对比精度与耗时）
2. 若 SpikingJelly 在 4090 上可行且指标≥snnTorch，**Phase4 选择 SpikingJelly** 作为 FPGA 导出入口
3. 否则持 snnTorch → ONNX 导出路线（或 Lava/Norse 备选）

**M0 checklist 说明：**

- CHARTER 的 M0 checklist 仍以 SpikingJelly/N-MNIST 表述，**不代表 v1 当前进度不及格**
- v1 已用 snnTorch/MNIST 在同 KPI 上超额达标（96.97% vs ≥90%）
- 建议将 CHARTER M0-T1/T2 改为「Phase4 启动前 2 周执行」

## 5. 结论

- **不矛盾，而是分阶段**：CHARTER 是终点，v1 是起点。
- **CDT/Gemini 建议与 CHARTER 一致**，同样指向 N-MNIST + SpikingJelly + FPGA；v1 暂不采纳，v2/Phase4 评估。
- **当前代码与文档均为一致性状态**——TR1 总裁已明确 MNIST+snnTorch 为唯一 v1 基线。

---

*陈正共 · ChenZhengGong · 2026-06-06*
