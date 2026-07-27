# G-LAT 分段归因 · r1（2026-07-24）

**真源 bench：** `runs/phase4_poc/distributed_bench_daemon_n100_vs_ort_20260724_r1.json`  
**口径：** 与 `phase4_spec_gate_report.py` 一致 — 丢弃前 **5** 暖机帧；`t_e2e_ms` **>100ms** 离群不计入稳态百分位。  
**稳态样本数：** n_steady=**94**（n_after_warmup=95，离群 1 帧 max e2e≈1035ms）。

## 稳态分段 p50 / p95（ms）

| 分段 | 字段 | p50 | p95 | 说明 |
|------|------|-----|-----|------|
| 预处理 | `t_preprocess_ms` | **0.001** | 0.001 | WSL `ascontiguousarray`，可忽略 |
| 入向传输 | `t_xfer_in_ms` | **0.000** | 0.000 | daemon 模式无独立入向计时 |
| Atlas 推理 | `t_atlas_ms` | **1.679** | 5.434 | daemon JSON `infer_ms`（OM 内） |
| 出向/队列 | `t_xfer_out_ms` | **2.959** | 6.690 | `t_rtt − infer_ms`（含 TCP 握手/RTT/栈开销） |
| 端到端 | `t_e2e_ms` | **5.513** | 9.339 | **G-LAT 判定字段** |

**组成校验：** 稳态下 `t_e2e ≈ t_preprocess + t_atlas + t_xfer_out`（无独立 `t_xfer_in`）。

## 相对 G-LAT p50≤5ms

| 项 | 值 |
|----|-----|
| 稳态 **p50(e2e)** | **5.513 ms** |
| 阈值 | 5.0 ms |
| **差额** | **+0.513 ms（FAIL）** |
| Atlas 段 p50 占 e2e | ~30%（1.68/5.51） |
| 通信/队列段 p50 占 e2e | ~54%（2.96/5.51） |

**主耗时：** 非 OM 算子本身，而是 **每帧新建 TCP 连接** 带来的 RTT/队列段（`t_xfer_out_ms`/`t_connect_ms`）；Atlas `infer_ms` 单独 p50 已在 2ms 内。

## bench 侧代码快检（Task 2 候选 1）

| 检查项 | 结论 |
|--------|------|
| 每帧 `sleep` | **无** |
| 每帧重载 ORT `InferenceSession` | **无**（`--vs-ort` 时在循环外 init 一次） |
| ORT 是否计入 `t_e2e_ms` | **否**（`bench_daemon_sample` 计时结束后才 `ort_sess.run`） |
| 明显低风险「删 waste」补丁 | **本轮未改代码**（无上述浪费；改连接复用会改变「逐连接」语义，留下一假说） |

## 建议下一假说（优先顺序）

1. **bench 编排：** 可选 **单连接多帧**（或连接池）复测 — 预期主要压缩 `t_xfer_out_ms`；须在报告注明拓扑变化，**不得**改 G-LAT 阈值。
2. **daemon 侧：** OM 预热/缓冲复用/减少 JSON 序列化开销 — 次要，因 r1 段内 Atlas p50 已 ~1.7ms。
3. **批推理：** 仅在有 G-SCN 口径说明时尝试；**不用 batch 均摊冒充单帧 p50**。

**r2：** 未跑（无「不改语义」的低风险 waste 可删；下一动作为连接复用或 daemon 微优化后再测）。

---
*陈正共 · ChenZhengGong · 2026-07-24*
