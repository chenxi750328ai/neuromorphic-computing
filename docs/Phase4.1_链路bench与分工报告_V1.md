# Phase4.1 · 链路 Bench 与分工报告 V1

> **负责人**：陈正共 · ChenZhengGong  
> **数据真源**：`runs/phase4_poc/distributed_bench_atlas_g1_n10.json`（逐帧 ssh 双跳 · N=10）  
> **对照**：`runs/phase4_poc/distributed_bench_daemon_n20.json`（常驻 daemon · N=20）  
> **纪律**：禁止单点过关；分工由瓶颈实验驱动，非「batch 调参」

---

## 1. Executive Summary

| 结论 | 证据 |
|------|------|
| **主瓶颈 = 跨板通信 + SSH 编排** | 逐帧 ssh `comm_ratio ≈ 99.9%`；Atlas NPU ~3.4ms 可忽略 |
| **常驻 daemon 可降 3 个数量级** | TCP daemon N=20：`t_e2e` p50≈4.8ms（vs ssh ~6s）；`comm_ratio≈65%`（TCP/会话开销） |
| **batch scp 不是架构优化** | 均摊延迟下降是 **统计假象**，未改变链拓扑与分工 |
| **初版分工假说 v0 需修订** | WSL 不应做「每帧 sshpass 转发器」；Atlas 不应被当作远程 shell 靶机 |

---

## 2. 实验设计（G1 · 逐帧双跳）

```text
[WSL] preprocess → scp payload → [Atlas] AclLite OM → ssh stdout 回传 → [WSL] 收 pred
```

- Payload：MNIST 单张 `1×1×28×28` float32 ≈ **3.2 KB**
- 编排：**sshpass + scp + ssh 远程 python**（与 v0 tri_compare 同族，非链式服务）
- 样本：**N=10**（逐帧独立计时，非 batch 均摊）

> batch×100 实验仅作对照：**不能**用均摊 ms/张 替代分段分布做分工决策（见 §5）。

---

## 3. 延迟分布（逐帧 · ms）

| 段 | min | p50 | p95 | max | mean | 占 t_e2e |
|----|-----|-----|-----|-----|------|----------|
| t_preprocess | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | **0%** |
| t_xfer_in (scp→Atlas) | 505 | 527 | 704 | 829 | 555 | **9%** |
| **t_atlas (NPU)** | 3.2 | 3.4 | 3.5 | 3.5 | 3.4 | **0.06%** |
| **t_xfer_out (ssh 回传)** | 5332 | 5477 | 5736 | 5847 | 5504 | **91%** |
| **t_e2e** | 5883 | 6018 | 6383 | 6404 | 6063 | 100% |

**comm_ratio（mean）= 99.94%**

### 3.1 分布图（ASCII）

```text
t_e2e  ████████████████████████████████████████  ~6.0s
t_out  ████████████████████████████████████░░░░  ~5.5s  ← 主瓶颈
t_in   ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ~0.55s
t_atlas ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ~0.003s
```

### 3.2 解读

1. **Outbound（ssh 会话）>> Inbound（scp）**：瓶颈在 **SSH 远程启动 + stdout 回传**，不是 3KB payload 带宽本身。  
2. **Atlas 算力稳定**（σ≈0.09ms）：NPU 不是变量，**编排方式**是变量。  
3. **t_e2e 方差 σ≈195ms**：主要来自 xfer_in 波动（829 vs 505），仍属 **会话/连接** 层，非模型。

---

## 3b. 常驻 daemon 对照（G1-next · N=20）

| 模式 | avg t_e2e | p50 t_e2e | avg t_atlas | comm_ratio | 备注 |
|------|-----------|-----------|-------------|------------|------|
| ssh 逐帧 | 5939 ms | 6018 ms | 3.4 ms | **99.94%** | `phase4_distributed_bench.py --atlas-only` |
| **TCP daemon** | **5.1 ms** | **4.8 ms** | 1.8 ms | **~65%** | `phase4_atlas_infer_daemon.py` + `--daemon-port 9527` |

**解读**：瓶颈从「SSH 编排」转为「TCP + NPU」；**Atlas 常驻**有数据支持。FPGA 去留与最终拓扑 **仍证据不足**，见 [探索规格与补数议程](./Phase4.1_探索规格与补数议程_V0.md)。

---

## 4. 分工结论（瓶颈驱动 · 假说 v0 → v1）

### 4.1 假说 v0（已证伪路径）

| 节点 | v0 设想 | bench 结论 |
|------|---------|------------|
| WSL+4090 | 编排 + 金标准 + **每帧 scp/ssh** | ❌ 编排本身吃掉 ~6s/帧，**不可量产** |
| Atlas | 全包 SNN OM | ✅ 算力 OK（~3ms），但被 ssh 掩盖 |
| FPGA | 链中切片 | ⏸ **入链未测**；不得用「暂缓」代替规格对照数据 |

### 4.2 假说 v1（待下一轮 bench 验证）

| 节点 | 修订职责 | 理由 |
|------|----------|------|
| **WSL+4090** | 离线训练 / 金标准 / **bench 编排器**；推理链上 **不做 per-frame ssh** | 开发工具链留 WSL；运行时改常驻服务 |
| **Atlas** | **推理服务常驻**（gRPC/Unix socket/ACL 长连接）；消费 **批量或流式 payload** | 释放 3ms NPU；消除 5.5s ssh |
| **FPGA** | **待证**：入链切分矩阵是否达标/有益（H2）；亦保留「场景内不用」（H1） | 现有数据不足以定去留 |

### 4.3 目标链（Phase4.1 next）

```text
[WSL 编排] ──TCP/常驻──► [Atlas inference daemon] ──► pred
                │                    │
           批量/流式 payload      AclLite 长连接
           分段计时：t_connect, t_queue, t_atlas, t_e2e
```

**禁止**：用 batch scp **代替** 常驻服务设计（只可证明「scp 比逐帧 scp 好」，不证明分工对）。

**已落地**：`scripts/phase4_atlas_infer_daemon.py`（Atlas 侧）+ bench `--daemon-port 9527`（WSL 侧）。

---

## 5. 为何 batch×100 优化方向不对

| 做法 | 现象 | 为何不算过关 |
|------|------|--------------|
| batch scp + 1 次 ssh | 均摊 ~60ms/张 | 把 **6000ms ssh 成本摊到 100 张**；**单帧路径未变** |
| comm_ratio 仍 ~97% | 通信仍主导 | 未建立 **服务化链**，Phase4 分工仍不确定 |
| pred 98% | 精度 OK | 精度不是 Phase4.1 关口 |

**正确 next**：`phase4_atlas_infer_daemon.py` + socket bench → 再出 **逐帧真实分布** + 修订分工。

---

## 6. 精度

- 逐帧 N=10：**90%**（1/10 mismatch，label 5 → pred 6）
- 与通信瓶颈 **独立**；精度问题留 Phase4.1-G2 对照 ORT

---

## 7. 总裁拍板对照（§7）

| # | 议题 | 本报告立场 |
|---|------|------------|
| B1 | 链路优先、分工由瓶颈驱动 | ✅ 数据支持（comm 99.9% 迫改编排） |
| B2 | t_e2e 目标线 ms/张 | daemon N=100：**p50=2.5ms / p95=5.1ms**（ssh ~6s 废弃）；建议 PoC 线 **p95≤10ms** |
| B3 | 批准 bench 脚本 + 分支 | ✅ G1+daemon 已跑通；N=100+payload 对照见 `distributed_bench_payload_compare.json` |

---

## 8. Next（陈正共）· 2026-07-14 修订

1. ~~**Atlas 推理常驻 daemon**~~ → **已跑通**（仅否证 SSH 逐帧；**≠** 分工定稿）  
2. ~~N≥100 daemon 分布~~ → `distributed_bench_daemon_n100.json`  
3. ~~payload 对照~~ → `distributed_bench_payload_compare.json`  
4. ~~「总裁签 B1–B3 → 定稿 v1 / G0」~~ → **作废写法**。项目为**技术探索**：须先按  
   [愿景方案_平台映射与规格_V0.md](./愿景方案_平台映射与规格_V0.md) 与  
   [Phase4.1_探索规格与补数议程_V0.md](./Phase4.1_探索规格与补数议程_V0.md)  
   用**全链路规格**跑通信矩阵 / Atlas 基线 / FPGA 切分对照；**数据齐前不下 FPGA 去留结论**。

---

*2026-06-22 初稿 · 2026-07-14 目标对齐修订 · 陈正共*
