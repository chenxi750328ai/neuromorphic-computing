# 研究笔记 · 北大/中科院相变忆阻器神经动力学芯片（Science 2026）

> **日期**：2026-07-14  
> **读者**：类脑 PL / 硬件路线评审  
> **结论先行**：这是 **神经动力学（NDS）存内计算** 突破，不是「通用类脑 SNN 推理芯片」；对我们现网（4090 + Atlas + FPGA）**无近端替代关系**，只作 Phase7+ 远景对照。

---

## 1. 事实核对（相对媒体稿）

| 项 | 核实值 | 来源 |
|----|--------|------|
| 题目 | *A sub–10-millisecond neural dynamical system based on phase-change memristors* | [作者页](https://yzhu.io/publication/physics2026science/) · [南燕](https://news.pkusz.edu.cn/info/1003/9813.htm) |
| 期刊/时间 | *Science*，约 2026-07-03 上线；7/5–11 产业报道高潮 | 光明日报 / 南燕 / ECNS |
| 团队 | **北大根杨玉超**（集成电路学院）· **中科院上海微系统所宋志棠**（相变存储）· 黄如等 | 同上 |
| DOI（南燕给出 eprint） | `10.1126/science.aee6277` | [Science eprint](https://www.science.org/eprint/WEY75M4YUHGJVGTEX5YC/full) |
| 工艺/面积 | **40 nm**；存内计算 + 步长漂移阵列合计 **0.28 mm²** | 南燕 |
| 时钟 | **50 MHz**；单步积分 **9 级流水** | 南燕 |
| 核心延迟 | 单次 NDS 迭代 **2.12 ms**（误差容限约 **10⁻⁷**） | 摘要 |
| vs 专用 ASIC | 速度 **3.82–36.27×**、功耗降 **11.75–24.73×** | 摘要 |
| vs A100 | 脑皮层表面重建端到端 **50.38–478.18×** | 摘要 |

**媒体易夸大点**：

1. 「破解脑机接口实时读脑」——论文/官宣场景是 **高保真脑皮层表面重建 / 流形网格**，以及为 BCI「脑状态建模」提供硬件底座；**不是**已经做成临床闭环 BCI 读出系统。
2. 「478× 碾压 A100」——是 **特定 NDS/重建管线** 端到端对比（含测量+仿真），不是任意深度学习训练/推理。
3. 「首款类脑芯片」表述过宽——准确说法是 **「首款亚 10 ms 相变忆阻器 NDS 芯片」**（团队与北大口径）。

---

## 2. 它到底在算什么

```text
神经动力学系统 NDS
  = 神经网络表达力  +  微分方程连续演化（自适应步长积分）

传统数字机的痛点
  存储 ↔ 计算 分离 → 中间变量反复搬运 → 延迟百毫秒级

本工作的物理窍门
  相变忆阻器「电导漂移」在时间窗内可预测、可控
    → 把「自适应积分步长搜索」编码成器件电导演化（原位物理算）
  多级电导
    → 权重存内 + 矩阵乘累加（compute-in-memory）

结果：少一轮又一轮数字乘加/读缓存，单步迭代压到 2.12 ms
```

**任务形态**：脑白质/灰质皮层表面重建、三维流形网格；指标含 Average Symmetric Surface Distance、Hausdorff Distance；强调平滑、拓扑一致、抑制自相交。

这和我们现网的 **MNIST / N-MNIST 脉冲分类、LIF tick、GWT workspace 广播** 不是同一计算图。

---

## 3. 与类脑现网对照

| 维度 | 北大 NDS 芯片 | 我们（neuromorphic-computing） |
|------|---------------|--------------------------------|
| 计算模型 | NN + ODE 积分（连续动力系统） | SNN / LIF tick · 未来 GWT 模块+workspace |
| 硬件 | 40nm 相变忆阻器阵列 | 4090 · Atlas 200DK · PYNQ-Z2 |
| 主瓶颈 | 器件内步长搜索 + 矩阵 CIM | Phase4.1：跨板通信 / 编排 >> NPU |
| 验收 KPI | 表面重建几何误差 · ms 级迭代 | 分类准确率 · daemon bench · GWT exam |
| 可用性 | 实验室流片 + Science；无开源驱动/栈对接 | 现网可跑 |

**对 Phase4.1**：不改「Atlas 常驻 daemon、修通信」判断。忆阻器不解决 WSL↔昇腾 payload。

**对 GWT**：间接启示是「存内 / 物理侧把贵操作干掉」；近端仍应在软件仿真做 **竞争写 / novelty gate**，别换硬件叙事。

**对 CHARTER 边缘低功耗**：方向鼓舞（40nm / 0.28mm² / 功耗降一个数量级），但 **无 IP、无驱动、无 snnTorch 导出链** → 记为 **2030+ 观察类**，不替代 OM/FPGA 路径。

---

## 4. PL 动作清单

| 优先级 | 做什么 | 不做什么 |
|--------|--------|----------|
| **归档** | 本笔记 + 摘要链接进 `docs/research/` | 因 478× 改 roadmap |
| **对照** | 季度再扫：是否有 SDK / 工艺合作开放 | 立项「买片/仿片」 |
| **远景** | Phase7+ 硬件选项表加一行「PCM-NDS」 | Phase4.1 关单前切存算一体栈 |
| **叙事** | 对外：我们懂 Science 在说啥，但路线诚实 | 对内：宣传「我们也上忆阻器」 |

---

## 5. 一手链接

- 作者页摘要：[yzhu.io Physics2026 Science](https://yzhu.io/publication/physics2026science/)
- 北大深圳官宣：[南燕新闻](https://news.pkusz.edu.cn/info/1003/9813.htm)
- Science eprint / DOI：`10.1126/science.aee6277`
- CGTN / ECNS 英文转述：[CGTN](https://news.cgtn.com/news/2026-07-05/Chinese-chip-cuts-brain-modeling-latency-to-milliseconds-1Ox0k1fyKqY/p.html)

*陈正共 · 类脑仓研究笔记 · 2026-07-14*
