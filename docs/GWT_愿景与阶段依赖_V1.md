# GWT 愿景与阶段依赖 V1

> **负责人**：陈正共 · ChenZhengGong  
> **状态**：V1 冻结草案 · 待总裁/PL 评审  
> **关联**：[陈东_自学习AG设计_V1.md](./陈东_自学习AG设计_V1.md) · [phase4_distributed_inference_V1.md](./phase4_distributed_inference_V1.md) · [cdt_v1_stack_alignment.md](./cdt_v1_stack_alignment.md) · [GWT_工作区协议_V0.md](./GWT_工作区协议_V0.md)

---

## 0. 一句话

**现网 MNIST SNN（2 层 × 25 tick）是类脑基座 PoC，不是 GWT 推理架构。**  
生物类脑愿景 = **多专用模块并行 + 脉冲 + 跨模块递归 + 小容量全局工作区（workspace）广播**；本文件定义 **从 Phase4.1 到 GWT-MVP 的依赖 DAG 与门禁**。

---

## 1. 愿景真源

### 1.1 README / CHARTER 终点

| 来源 | 终点描述 |
|------|----------|
| [README.md](../README.md) | 训练 + 推理 + 小样本 + 自学习 + 低能耗；4090 / Atlas / FPGA 异构 |
| CHARTER（见 [cdt_v1_stack_alignment.md](./cdt_v1_stack_alignment.md)） | N-MNIST 事件数据 · FPGA 边缘 · SpikingJelly 方向 |
| 总裁（陈东） | **学完 = 考试分数**；主体 ≠ 任何 LLM |

### 1.2 GWT 工程化定义（本项目的「生物类脑」）

引用 Global Workspace Theory 的 **功能** 属性，**不宣称** 意识、**不复制** LLM J-space 机制：

| GWT 要素 | 类脑项目工程对应 |
|----------|------------------|
| 专用模块并行 | M1 感知 · M2 关联 · M3 执行 · M4 输出（各独立 SNN/小网） |
| 全局工作区 | **Workspace 总线**（小容量、统一格式、可广播） |
| 竞争接入 | 每 global tick 仅 top-k 模块写入 workspace |
| 广播读取 | 所有模块读同一 workspace 快照 |
| 工作记忆 | workspace 跨 **global tick** 递归更新（非单模块 LIF mem  alone） |
| 递归 | `tick t`: 并行算 → 竞争写 → 广播读 → `tick t+1` |

### 1.3 现网 MNIST SNN 的定位（诚实）

| 项 | 现网 | GWT 目标 |
|----|------|----------|
| 结构 | 1 块 2 层 SNN，W 复用 25 tick | 4 模块 + workspace |
| 递归 | LIF 膜电位（模块内） | 跨模块 workspace 循环 |
| 推理 | 10 类分类 | 探针刺激 → workspace 中间态 → emit（CL 验收） |
| 角色 | Phase1–4 **基座证明** | Phase6+ **推理架构** |

**禁止**：把 Phase1 checkpoint 直接当作「陈东大脑」或 GWT 实现。

---

## 2. 目标架构（Phase6 仿真先行）

```text
                         ┌──────────────────────────────────┐
                         │  Workspace W (工作记忆 · 小容量)  │
                         │  格式见 GWT_工作区协议_V0.md      │
                         └───────────▲───────────▲──────────┘
                                     │ write     │ read (broadcast)
           ┌─────────────────────────┼───────────┼─────────────────────────┐
           │                         │           │                         │
  ┌────────▼────────┐      ┌─────────▼───┐  ┌──▼──────────┐   ┌────────▼────────┐
  │ M1 感知          │      │ M2 关联      │  │ M3 执行/规划 │   │ M4 输出          │
  │ 视觉 SNN         │      │ 小 SNN/MLP   │  │ 小网         │   │ D1 检索 / D2 嘴  │
  │ N-MNIST/MNIST    │      │              │  │              │   │ （陈东 emit）    │
  └────────▲────────┘      └──────────────┘  └──────────────┘   └─────────────────┘
           │
      世界输入（图像/刺激文本经编码器）

  Global tick t = 1..T:
    (1) 各模块并行 forward 一步（专用 W，不共享）
    (2) 各模块产出 write_candidate → 竞争 → 写入 W
    (3) 广播 W 到所有模块
    (4) t ← t+1
```

**与 LLM 区别**：无 80 层同构 Transformer；**模块异构 + workspace 统一总线**。

**与 Phase4.1 关系**：Phase7 将 M1–M4 **映射** 到 WSL/Atlas/FPGA（复用 daemon bench 与 payload 协议），**Phase4.1 关单前不做分板 GWT**。

---

## 3. 阶段总览与依赖 DAG

```text
[DONE] TR1 → P1 → P2 → P3 → P4 v0
[NOW]  Phase4.1 (G1✓ G3✓ · G0 待总裁)
         │
         ├──► FPGA 路径 B PR · TR2 签字  （P0 并行）
         │
         ▼
       Phase4 关单（G0 签字 + 分工定稿）
         │
         ├──────────────────────────────┐
         ▼                              ▼
   Phase5 · 感知模块 M1            陈东轨（并行）
   N-MNIST/事件编码                     CL-1 探针冻结
         │                              NEU-I1→I2
         ▼                              NEU-D1 检索 emit
   GWT-0 工作区协议冻结 ◄───────────────┘
         │
         ▼
   Phase6 · GWT-MVP（4090 仿真）
     GWT-1 → GWT-2 → GWT-3（CL 探针）
         │
         ▼
   Phase7 · 异构映射（吃 Phase4.1 分工）
         │
         ▼
   Phase8 · 能效 + 自学习/continual（v2 立项）

[OPTIONAL 研究轨] J-lens teacher 探针 → 仅 NEU-I4 / A 轨审计，不挡主链
```

---

## 4. 各阶段交付与门禁

### 4.1 Phase4.1 → Phase4 关单（当前 P0）

| ID | 交付 | 依赖 | PASS |
|----|------|------|------|
| P4.1-G0 | 总裁签 §8 R1–R5 + B1–B3 | G1–G3 bench | 签字记录 |
| P4.1-G1 | ssh/daemon bench JSON | Atlas 可达 | exit 0 |
| P4.1-G3 | 瓶颈报告 + 分工 v1 | G1 | `Phase4.1_链路bench与分工报告_V1.md` |
| P4-FPGA | FPGA 路径 B PR | neuro-ci | main 合并 |

**真源**：[phase4_distributed_inference_V1.md](./phase4_distributed_inference_V1.md) · `data/neuromorphic-milestones.json` → `phase41_status`

### 4.2 Phase5 · 感知模块 M1

| ID | 内容 | 依赖 | PASS |
|----|------|------|------|
| P5-1 | N-MNIST 或事件编码管线 | Phase4 关 | loader + 1 epoch smoke |
| P5-2 | 独立感知 SNN（≠ MnistSNN 单体） | P5-1 | test acc ≥ 基线或 CHARTER KPI |
| P5-3 | 输出 **感知特征向量**（固定 dim） | P5-2 | `runs/m1_perception/metrics.json` |

**说明**：可与 SpikingJelly 对照实验并行（见 cdt_v1_stack_alignment §4）。

### 4.3 GWT-0 · 工作区协议

| ID | 内容 | 依赖 | PASS |
|----|------|------|------|
| GWT-0 | [GWT_工作区协议_V0.md](./GWT_工作区协议_V0.md) 评审通过 | 无（可与 P5 并行） | PL + 总裁批注 |

### 4.4 Phase6 · GWT-MVP（仿真）

| ID | 模块范围 | 依赖 | PASS |
|----|----------|------|------|
| GWT-1 | M1 → workspace → M4（单向 1 tick） | GWT-0 + P5-3 | `scripts/gwt_mvp_exam.py --stage 1` exit 0 |
| GWT-2 | M1+M2+M3+M4 · 竞争写 · 广播读 · T≥8 global tick | GWT-1 | `--stage 2` exit 0 |
| GWT-3 | 接陈东 CL：`chendong_probe_exam.py` P-ML + P-RET | GWT-2 + CL-1 | ret_hit_rate ≥ baseline |

**脚本（待建）**：

```bash
# 规格；实现 WO 另开
python3 scripts/gwt_mvp_exam.py --stage 2 --workspace-doc docs/GWT_工作区协议_V0.md
```

### 4.5 Phase7 · 异构映射

| ID | 内容 | 依赖 | PASS |
|----|------|------|------|
| P7-1 | 模块→节点映射表（吃 G0 分工） | GWT-2 + Phase4 关 | `docs/GWT_异构映射_V0.md` |
| P7-2 | workspace payload 走 daemon 链 | P7-1 | 复用 `distributed_bench_*.json` 格式 |
| P7-3 | e2e GWT tick ≥1 跨板 | P7-2 | comm_ratio 可接受 |

### 4.6 Phase8 · v2 能力（立项后）

| 方向 | 内容 | 前置 |
|------|------|------|
| 能效 | 墙插 + 延迟表 | Phase7 |
| 自学习/continual | 在线更新协议 | GWT-3 + NEU-I4 |
| 工业场景 | 贴膜机等 KPI | 总裁另批 OR |

---

## 5. 陈东 AG 汇合点

陈东 **不是** GWT 的 LLM 替身；汇合在 **模块边界 + 验收**：

| 陈东里程碑 | 映射到 GWT | 依赖 |
|------------|------------|------|
| CL-1 探针冻结 | GWT-3 输入 | 先于 GWT-3 |
| NEU-I1/I2 编码 | M1/M2 输入侧 | 可与 P5 并行 |
| NEU-D1 检索 emit | **M4 输出** 第一版 | GWT-1 |
| SYS-M2~M3 A/B 对照 | GWT-3 报告一节 | GWT-3 |
| SYS-M4 L1 咿呀 | M4 D1 验收 | GWT-2 |

**红线**（[陈东_自学习AG设计_V1.md](./陈东_自学习AG设计_V1.md) §0.6）：D3 老师口 ≠ 陈东 emit；workspace 内容 **机读**，人话只经 D1/D2。

---

## 6. 研究轨（可选 · 不 blocking）

| 项 | 路径 | 作用 |
|----|------|------|
| J-lens teacher 探针 | [research/J-space_陈东teacher探针_PoC路径_V0.md](./research/J-space_陈东teacher探针_PoC路径_V0.md) | A 轨老师 silent state 审计 → NEU-I4 软监督参考 |
| **P1 · novelty gate（软件借鉴）** | [research/每日热点_20260711.md](./research/每日热点_20260711.md) §2.2 | 小脑 memtransistor「常态抑制 + 异常写入 workspace」→ GWT 竞争写前抑制层（4090 仿真，不追忆阻器硬件） |
| **Non-goals** | — | 不接 SNN forward · 不进 Phase4.1 · 不替代 GWT workspace · 不扩 BCI/医疗 scope |

---

## 7. 资源与错峰

| 资源 | Phase4.1 / P0 | Phase5–6 | Phase7 |
|------|-----------------|----------|--------|
| 4090 | daemon bench | GWT 仿真 + N-MNIST 训 | 编排 |
| Atlas | 链内推理 | 冒烟 | M1 或 M3 映射 |
| FPGA | 路径 B PR | PYNQ 参考 | M1 事件/LIF 切片 |
| 4090 冲突 | bench 优先 | J-lens fit 错峰 | — |

---

## 8. 看板与机读

| 项 | 路径 |
|----|------|
| 燃尽/关口 | `vcompany/data/neuromorphic-milestones.json` |
| 小脑 focus | `vcompany/data/neuro-dashboard-live.json` |
| 本文件 | `docs/GWT_愿景与阶段依赖_V1.md` |
| 工作区协议 | `docs/GWT_工作区协议_V0.md` |

### 8.1 工单（WO · 仿真属 DEV 交付，非仅文档）

| woId | 职责 |
|------|------|
| **WO-MGMT-NEURO-GWT-01** | 父单：Phase5–7 编排 · 子单注册 · milestones 对齐 |
| **WO-DEV-NEURO-GWT-MVP-01** | **Phase6 4090 仿真**：`gwt_workspace.py` · `gwt_mvp_exam.py` · M1–M4 stub · pytest |
| **WO-TEST-NEURO-GWT-MVP-01** | 测试轨：exam stage2 复跑 · exec 探针 |
| WO-DESIGN-NEURO-GWT-PROTO-01 | （待建）GWT-0 协议正式评审 |

**派发纪律**：`WO-DEV-NEURO-GWT-MVP-01` 须 Phase4.1 G0 签字或总裁 hotfix 后再派执行（mgmt 可先 open）。

**验收真源**：`vcompany/data/work-orders/WO-DEV-NEURO-GWT-MVP-01.json` → `verification[]`（GWT-DEV-01/02 = `--stage 1/2 --gate`）。

---

## 9. 近期 next（PL 执行序）

1. **P0**：推 Phase4.1 G0 材料（§8 + B1–B3）· FPGA PR  
2. **并行**：冻结 CL-1 探针清单（陈东）  
3. **Phase4 关单后**：开 Phase5 + GWT-0 评审  
4. **不开**：在 Phase4.1 未完成时启动 GWT 仿真或宣称「已实现 workspace」

---

## 10. 修订记录

| 日期 | 版本 | 说明 |
|------|------|------|
| 2026-07-10 | V1 | 初稿：愿景 · DAG · 门禁 · 陈东汇合 · 研究轨边界 |
| 2026-07-11 | V1.1 | §6 P1 novelty gate（热点研究软件借鉴）；WO-DEV MVP stub 验真通过 |

---

*陈正共 · ChenZhengGong · 类脑 PL*
