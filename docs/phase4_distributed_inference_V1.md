# Phase4.1 · 分布式推理链路验证（WSL+4090 / Atlas / FPGA）

> **负责人**：陈正共 · ChenZhengGong  
> **触发**：总裁 2026-06-22 技术评审 —「PH4 不能了结；FPGA 仅单点；三端分工与通信瓶颈未验证」  
> **前置**：Phase4 v0 单点 PoC 已合 main（PR #5 Atlas · PR #7 FPGA 参考）  
> **上级**：[Phase4 技术报告 §10](./Phase4_技术报告_总裁评审.md#10-phase41--分布式推理链路待总裁拍板)

---

## 1. 问题陈述

Phase4 v0 回答的是：**每个硬件节点单独能不能跑 MNIST SNN 相关算子？**

总裁关心的关键技术点是：

1. **分工**：WSL+4090、Atlas、FPGA 在**整条推理链**里各算什么、不算什么？  
2. **通信**：跨节点传 payload（图像、脉冲、中间激活）时，**延迟/带宽是否成为瓶颈**？  
3. **FPGA 定位**：不是「再做一个单点对照」，而是链上的**哪一段**值得放 FPGA？

**v0 未覆盖以上三点** — 因此 Phase4 **整体关口不应关闭**。

### 1.1 设计纪律（总裁 2026-06-22）· **禁止单点过关**

> **「这三个不能单点过，因为如果发现瓶颈，分工会被迫改变。」**

| 错误做法 | 为何不行 |
|----------|----------|
| Atlas PASS + FPGA PASS + WSL PASS → 关 Phase4 | 分工是**瓶颈实验的结果**，不是单点验收的累加 |
| 先冻结「Atlas 主推理 / FPGA 做切片」再各站实现 | 通信一卡壳，切片位置、payload 形态、是否下沉预处理**全要改** |
| 用 v0 单点 QA 当 Phase4 签字依据 | PR #5/#7 只是**可行性证据**，不是**架构验收** |

**正确做法**：**端到端链路优先** — 先跑通可度量的一条链（哪怕很丑），读出 `comm_ms vs compute_ms`，**再**根据瓶颈**修订分工**，然后重跑，直到分工稳定或明确不可行。

```text
  假说分工 → 链路 bench → 发现瓶颈？ ──是──► 改分工（非改单点脚本了事）
                │                    │
                └──否──► 分工定稿 → 方可关 Phase4
```

**推论**：Phase4.1 的 G0 不是「总裁先签字分工」，而是「跑完 G1–G3 后输出**经瓶颈验证的分工结论**」供总裁签字。

---

## 2. 4R

### purposeStack

1. **验收过关** — 有分段计时数据 + 瓶颈结论（可复现 JSON）  
2. **不浪费** — MVP 先 WSL↔Atlas 双跳，再 optional 接 FPGA 切片  
3. **派发速度** — 复用现有 AclLite / PYNQ 脚本，加薄编排层

### chain（目标主链）

```text
[WSL 编排 + 4090 金标准]
    │  (1) 预处理 28×28
    │  (2) 下发 payload ──────────────┐
    ▼                                  ▼
[Atlas: SNN OM 主推理]          [FPGA: 事件/LIF/累加切片]  ← 可选第二跳
    │  spike_counts / 中间态          │
    └──────────┬──────────────────────┘
               ▼
[WSL: 汇总 pred · 对比金标准 · 写 bench 报告]
```

### owners

| 站 | 责任人 | PASS 信号 |
|----|--------|-----------|
| 拓扑与 bench 脚本 | 陈正共 | `runs/phase4_poc/distributed_bench.json` |
| Atlas 链内推理 | 陈正共 | 非「手动 scp 再本地跑」 |
| FPGA 链内切片 | 陈正共 + 陈小六 | 至少 1 个算子在链内非离线 |
| 网络基线 | 陈小六 device-lab | `device-lab-health.json` + 载荷 ping |

### gates

| 门禁 | 命令/产物 |
|------|-----------|
| G0 **分工定稿** | bench 迭代后的《分工结论》+ 总裁签字（**在 G3 之后**，非之前） |
| G1 双跳 MVP | `scripts/phase4_distributed_bench.py --atlas-only` exit 0 |
| G2 分段计时 | JSON 含 `t_xfer_in,t_atlas,t_xfer_out,t_e2e` |
| G3 瓶颈报告 | `comm_ratio` + **被迫调整的分工说明**（相对初版假说） |
| G4 切分/三跳对照（探索） | 按 [补数议程](./Phase4.1_探索规格与补数议程_V0.md) 跑 **含/不含 FPGA** 与多种切分；**不**用「G3 口头暂缓」代替数据 |
| G5 对照基线 | 「全 Atlas」「全 WSL」与链式方案的 `t_e2e` 对比表 |

### gaps（相对 v0）

- v0 `tri_compare` 在 **WSL 内**调 Atlas API/脚本，非「编排器驱动流水线」  
- FPGA `pynq_spike_demo` 是**演示**，未消费 Atlas 上游输出  
- 未测 **payload 形态**（raw image vs spike tensor vs OM 输入）对带宽影响

### next

- 实现 `phase4_distributed_bench.py`（**链路优先**，禁止以单点 PASS 代替）  
- 开 `feature/phase4.1-distributed`；初版分工仅作**假说 v0**，允许被 G3 推翻

---

## 3. 分工假说 v0（**可被瓶颈实验推翻**）

> 下表是**起点**，不是签字真源。若 G3 显示通信瓶颈，典型调整包括：预处理下沉 FPGA、Atlas 批处理、减少跳数、改 payload 为压缩脉冲等。

| 节点 | 建议职责 | 依据 | 风险 |
|------|----------|------|------|
| **WSL + 4090** | 编排、数据集迭代、ORT/PyTorch 金标准、**通信发起** | 开发机已具备全工具链 | 若每帧都经 WSL 转发，易成瓶颈 |
| **Atlas** | **完整 SNN OM 推理**（已 bit-exact） | NPU 吞吐、OM 已就绪 | 输入若走以太网，需测 jumbo/序列化 |
| **FPGA** | **前处理事件化 / 单步 LIF / 稀疏累加**（单层），不接全网络 | v0 证全网上 PL 不经济 | 链路过长则 comm 放大 |

**待验证命题**：

- P1：Atlas-only 链 daemon 模式 **p95=5.1ms**（N=100）；建议 PoC 定标线 **p95≤10ms**（待总裁 B2 签字）  
- P2：`comm_ms` 占比是否 <50%；若否，瓶颈在何链路（eth/USB/SSH）  
- P3：插入 FPGA 切片后，**总延迟**是否优于「Atlas 全包」— 若否，FPGA 应退到传感器侧而非链中

### 3.1 假说 v0 → v1 修订 diff（G1 数据 · 2026-06-22）

| 项 | v0（起点） | v1（瓶颈驱动修订） | 证据 |
|----|------------|-------------------|------|
| WSL 运行时角色 | 每帧 scp+ssh 转发 | **编排 + 金标准**；链上走 TCP daemon | ssh ~6s → daemon N=100 **p50=2.5ms / p95=5.1ms** |
| Atlas 运行时角色 | 远程 shell 靶机 | **推理常驻服务**（`phase4_atlas_infer_daemon.py:9527`） | N=100 pred 98% · comm 87% |
| FPGA | 链中切片（待定） | **暂不进链**；comm 未稳前不加第三跳 | G1 未测 FPGA |
| Phase4 关口 | 单站 PR #5/#7 叠加 | **G1–G3 链路 bench + 分工定稿** | 总裁纪律 §1.1 |

真源报告：[Phase4.1_链路bench与分工报告_V1.md](./Phase4.1_链路bench与分工报告_V1.md)

---

## 4. 通信与瓶颈度量

### 4.1 分段定义

| 段 | 含义 |
|----|------|
| `t_preprocess` | WSL 读图 + normalize |
| `t_xfer_in` | WSL → Atlas（payload 发出到 Atlas 收到） |
| `t_atlas` | Atlas AclLite execute |
| `t_xfer_mid` | Atlas → FPGA（若启用） |
| `t_fpga` | FPGA 切片执行 |
| `t_xfer_out` | 板 → WSL 结果回传 |
| `t_e2e` | 以上合计 |

### 4.2 通信基线（device-lab 已有）

- Atlas：`192.168.137.2` eth · SSH:22 · Jupyter:8888（见 Atlas 配置文档）  
- FPGA PYNQ：`192.168.137.3`（见 PYNQ 配置文档）  
- **缺**：固定大小 payload 的 **吞吐量曲线**（1KB / 64KB / 1MB）

### 4.3 瓶颈判定规则（草案）

```text
若 comm_ms / t_e2e > 0.5  → 通信瓶颈，出优化建议（压缩、批处理、板端预处理）
若 t_atlas / t_e2e < 0.2 且 comm 高 → 算力闲置，应下沉预处理或合并跳数
若加 FPGA 后 t_e2e 上升 >20% → FPGA 不宜在此链位置
```

---

## 5. MVP 实验步骤

### 5.1 Atlas 双跳（必做）

1. WSL 启动 bench 客户端，通过 **socket 或 SSH 远程命令** 触发 Atlas 推理（禁止「scp 文件后人工登录跑」作为主路径）。  
2. N=100 张 MNIST test，记录每段 ms。  
3. 与 WSL 本地 ORT 比 pred 一致率（应 100%）。  
4. 产出：`runs/phase4_poc/distributed_bench_atlas.json`

### 5.2 FPGA 三跳（可选）

1. Atlas 输出 `spike_counts` 或约定中间张量 → 送 PYNQ 做累加/事件整形。  
2. 对比 5.1 的 `t_e2e` 与精度。  
3. 产出：`distributed_bench_atlas_fpga.json`

---

## 6. 验收与关口

| 关口 | 条件 |
|------|------|
| 单站可行性（v0） | PR #5/#7 — **不等价于 Phase4 PASS** |
| **Phase4 整体关闭** | G1–G3 + **经瓶颈验证的分工定稿**（G0）+ 总裁签字 |
| Phase5（N-MNIST 等） | Phase4 整体关闭之后 |

**禁止**：以「Atlas 单点 PASS + FPGA 单点 PASS」叠加关闭 Phase4（总裁纪律 §1.1）。

---

## 7. 总裁拍板项

| # | 议题 | 陈正共建议 |
|---|------|------------|
| B1 | 是否同意 **链路优先、分工由瓶颈驱动**（§1.1）？ | **同意**（ssh 99.9% comm 迫改编排） |
| B2 | `t_e2e` PoC 目标线（ms/张）：____ | **p95 ≤ 10ms**（N=100 daemon 实测 5.1ms） |
| B3 | 是否批准开发 `phase4_distributed_bench.py` 并开 `feature/phase4.1-distributed`？ | **同意**（脚本+daemon 已跑通，待开 PR） |

---

*陈正共 · ChenZhengGong · 2026-06-22*
