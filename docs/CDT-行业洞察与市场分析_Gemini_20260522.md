# 类脑计算 · CDT 阶段行业洞察与市场分析

> **执行**：OpenClaw **gemini**（陈方无 · 行业洞察）  
> **时间**：2026-05-22  
> **来源**：子任务会话 `agent:gemini:subagent:6d539123-…`（由会话记录恢复落盘）  
> **负责人**：陈正共 · 类脑计算 PL

---

## 1. 历史里程碑（1970s～2026）

- **起源 (1970s–1980s)**：Carver Mead 提出 Neuromorphic，亚阈值 MOSFET 模拟神经元电导。  
- **发展**：IBM TrueNorth 等百万神经元级芯片。  
- **融合 (2019)**：清华 **天机 (Tianjic)**，ANN 与 SNN 混合计算。  
- **成熟 (2021–2026)**：Intel **Loihi 2**；文献中提及 Loihi 3、IBM **NorthPole** 等边缘感知方向。

## 2. 芯片演进

| 厂商/路线 | 特点 |
|-----------|------|
| Intel Loihi | 可编程神经元、时域动态学习 |
| IBM NorthPole | 高 SRAM 密度、能效相对 GPU 显著提升（文献口径） |
| BrainChip Akida | 车载/IoT 边缘、商业化较快 |
| SynSense | 感算一体、DVS、毫瓦级 |
| 灵汐/天机 | 国内全栈、边缘与云端 |

## 3. 算法突破

- **STDP**：局部自学习、在线适配。  
- **ANN→SNN 转换**：权重归一化与偏差补偿。  
- **脉冲编码**：率编码、相位编码、首脉冲时间编码。  
- **快速学习 / 小样本**：端侧少量刺激适配（方向性结论）。

## 4. 开源生态

| 框架 | 定位（当时结论） |
|------|------------------|
| SpikingJelly | PyTorch 全栈、训练加速生态 |
| Lava | Intel / Loihi 绑定 |
| snnTorch / Norse | PyTorch 扩展、迁移友好 |
| Brian2 | 科研与生物仿真 |

> **与当前工程**：Phase 1 已选用 **snnTorch + MNIST**（见 `requirements_v1.md`），与本文「SpikingJelly + N-MNIST」章程（`agentfuture/brain/CHARTER.md`）并存，评审时需对齐冻结栈。

## 5. 市场分析（2024–2026，调研口径）

- **规模**：神经形态芯片全球约数亿美元量级（多源研报，需 TR1 前再核对一手 URL）。  
- **竞争**：Intel/IBM 偏标准与研发；BrainChip/SynSense 等占边缘细分。  
- **小团队切入点**：  
  1. DVS（事件相机）+ SNN 避障/低功耗监控  
  2. 医疗/穿戴 EEG/ECG 低功耗分类  
  3. ANN→SNN 部署中间件/工具链  

## 6. MVP 路径建议（Gemini 当时）

| 阶段 | 建议 |
|------|------|
| 训练 | RTX 4090 + 替代梯度训练（文内举 SpikingJelly） |
| 转换/量化 | L-SPINE / BrainCog，4/8-bit |
| 部署 | Xilinx Zynq + PYNQ |
| 验证 | 无人机避障、穿戴手势等「极低唤醒功耗」场景 |

**关键结论（原文）**：类脑计算走出实验室；小团队宜深耕「事件驱动 + 极端低功耗」利基场景。

---

## 7. 与仓库其他文档的关系

| 文档 | 路径 | 说明 |
|------|------|------|
| 立项章程 DCP1 | `agentfuture/brain/CHARTER.md` | 2026-05-22，FPGA+SNN 边缘、SpikingJelly/N-MNIST |
| 需求 v1 | `docs/requirements_v1.md` | MNIST + snnTorch 仿真（当前开发基线） |
| TR1 网页看板 | http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html | 工程进度 |

**注意**：`vcompany/docs/01-market/` 下 CDT/市场分析属于 **虚拟公司 v1 团建**，不是本类脑项目。

---

*恢复落盘：2026-05-27 · 陈正共*
