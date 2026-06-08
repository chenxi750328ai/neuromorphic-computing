# 类脑计算项目（启动包）

> **评审入口**：在 Cursor 按 `Ctrl+P` 输入 **`评审入口`** 或 **`项目看板`**（聊天气泡里的 `file://` 链接点不开，属正常）。  
> **自驱 hook**：须以 **本目录为工作区根** 打开 Cursor；父目录 `/home/cx` 不会触发类脑唤醒。恢复记忆见 [docs/恢复记忆_陈正共.md](docs/恢复记忆_陈正共.md)。  
> 文件：[评审入口.md](评审入口.md) · [docs/项目看板.md](docs/项目看板.md) · [docs/TR1_评审材料清单.md](docs/TR1_评审材料清单.md)

## 项目目标

**江湖 / OpenClaw 身份**：本条线由 **陈正共**（`cursor_陈正共`）负责设计开发；江湖 Agent ID **ChenZhengGong**，OpenClaw 建议 **`chenzhenggong`**；恢复记忆入口见 `agentfuture/docs/恢复记忆_陈正共.md`。

在现有算力上**完成类脑计算能力闭环**：具备类脑相关的**训练**与**推理**，并面向 **小样本学习**、**自学习（持续/在线学习）**、**低能耗** 等特性做设计与验证。  
**部署形态不限**：云端、本地工作站、嵌入式或产线侧（例如自动贴膜机等）均为可选场景，而非项目边界。

**已有资源**：Windows + WSL + RTX 4090 + FPGA 开发板 + 昇腾 ATLAS 200DK A2。

## 任务 1：资料搜集 + 每日进展报告

### 建议持续跟踪的资料方向

| 方向 | 说明 | 关键词 / 入口 |
|------|------|----------------|
| 学术与综述 | SNN、神经形态计算、可塑性 | *spiking neural network*, *neuromorphic*, *few-shot*, *continual learning* |
| 训练与仿真 | 类脑/脉冲网络工具链 | [snnTorch](https://github.com/jeshraghian/snntorch), [Norse](https://github.com/norse/norse), [Brian2](https://brian2.readthedocs.io/), [NEST](https://www.nest-simulator.org/) |
| 小样本 / 自学习 | 元学习、增量学习、生物启发可塑性 | meta-learning, continual learning, STDP（与任务对齐时再收窄） |
| 硬件与能效 | 神经形态芯片、稀疏与事件驱动 | Intel Loihi / Loihi 2、SpiNNaker、国产类脑平台公开资料 |
| 部署与压缩 | 低能耗、定点化、蒸馏 | 量化、剪枝、**事件相机**（若某场景需要高速视觉） |
| 你已有算力 | 研发训练 / 异构验证 | PyTorch + CUDA（4090）；**昇腾** CANN + MindSpore / ONNX（以 Atlas 200DK 文档为准） |
| FPGA | 加速或接口定制 | 定点化、并行脉冲累加、与 CPU/GPU/NPU 协同的数据流 |

### 每日报告（飞书）

1. 在飞书群创建「自定义机器人」，复制 Webhook 地址。  
2. 在 WSL 中设置环境变量（可写入 `~/.bashrc` 或本目录 `.env`，勿提交密钥）：

```bash
export NEUROMORPHIC_FEISHU_WEBHOOK="https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxx"
```

3. 手动试发：

```bash
cd /home/cx/neuromorphic-computing
python3 scripts/daily_progress_report.py
```

4. 定时（crontab 示例见 `crontab.example`）。

报告正文维护在 `reports/daily_progress.md`（按日追加或覆盖「当日」小节均可，脚本会读取该文件）。

## 任务 2：需求分析 → 设计 → 开发 → 验证（阶段划分）

1. **需求**：v0 [docs/requirements_v0.md](docs/requirements_v0.md) · **v1（评审基线）** [docs/requirements_v1.md](docs/requirements_v1.md)（**MNIST + Phase1 SNN 仿真**）。  
2. **流程**：研究轨 IPD/QA 裁剪 [docs/IPD-QA流程裁剪_待VP总裁批准.md](docs/IPD-QA流程裁剪_待VP总裁批准.md) · CI：`python3 scripts/qa-neuro-baseline-run.py --tier ci`
2. **设计**：训练/推理软件栈、数据与实验协议、多硬件分工（4090 / Atlas / FPGA）、能效与精度 KPI。  
3. **开发**：在 WSL 内统一版本管理；昇腾与 FPGA 侧各自子目录与构建说明（后续补充）。  
4. **验证**：可复现实验、基准任务（含小样本/自学习子集）、能耗与延迟测量；工业场景（如贴膜机）在 KPI 明确后作为场景验收之一。

## Phase 1 快速跑（MNIST + SNN）

```bash
cd /home/cx/neuromorphic-computing
python3 -m pip install -r requirements.txt
python3 scripts/train_mnist_snn.py --seed 42 --epochs 10
```

输出：`runs/<时间戳>/metrics.json`、`checkpoint.pt`。仅评估：`--eval-only --checkpoint runs/.../checkpoint.pt`。

## Git 仓库

| 项 | 值 |
|----|-----|
| **远端** | https://github.com/chenxi750328ai/neuromorphic-computing |
| **与江湖关系** | 与 `agent-jianghu` **并列独立仓**，不随 `/home/cx` 父目录提交 |
| **凭证** | `agentfuture/.env` → `CHENXI750328AI_GITHUB_*` |
| **提交署名** | 每条 commit 须含 **陈正共** 或 **ChenZhengGong**（见 [CONTRIBUTING.md](CONTRIBUTING.md)） |
| **TR1 拍板纪要** | [docs/会议纪要_TR1总裁拍板_20260528.md](docs/会议纪要_TR1总裁拍板_20260528.md) |

## 目录

```
neuromorphic-computing/
  README.md
  CONTRIBUTING.md
  docs/项目看板.md
  docs/会议纪要_TR1总裁拍板_20260528.md
  docs/TR1_评审材料清单.md
  docs/requirements_v0.md
  docs/requirements_v1.md
  requirements.txt
  reports/
  scripts/
```

---

*维护人：陈正共 · 报告日期以 daily_progress / 看板为准。*
