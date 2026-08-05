# Phase4.2 · FPGA 整网性能 + 依赖 STALL 登记 V0

> **总裁裁定（2026-08-05）**：Phase4.1 **性能不达标，不能算过**——仅等于「功能可用」；同意计划往后走，可与 Phase5 **并行**；凡后续依赖性能的点标为 **STALL**，**STALL 之前必须完成 Phase4.2**。  
> **作者**：陈正共 · ChenZhengGong  
> **证据**：[`phase4_poc_evidence/F7_整网延迟与性能_一页_20260805.md`](./phase4_poc_evidence/F7_整网延迟与性能_一页_20260805.md)

---

## 1. 4.1 / 4.2 两态分离（强制）

| 阶段 | 含义 | 当前 |
|------|------|------|
| **Phase4.1** | 功能可用：F7 board pred≡golden、链路/双路线证据齐 | ✅ 功能侧（#26）；**≠性能过关** |
| **Phase4.2** | 性能可用：整网延迟/吞吐达门禁，才允许宣称加速/上依赖性能的下游 | ❌ **未开始验收** · 与 Phase5 并行攻关 |

**禁止话术**：「Phase4.1 过了所以 FPGA 整网性能 OK」。  
**允许话术**：「4.1 功能可用；性能在 4.2；未过 4.2 前相关下游 STALL」。

---

## 2. Phase4.2 目标（KPI）

| ID | 门禁 | 阈值 | 状态 |
|----|------|------|------|
| **P4.2-LAT** | 单张 e2e 墙钟（同 F7 网 · 板上 · 与现证据同切分口径） | **≤ 100 ms/张**（总裁 2026-08-05 接受） | ☐ **FAIL** · ≈306s/张（4.1 基线；WO-DEV-NEURO-F7-PERF exec 2026-08-05） |
| P4.2-ACC | 功能不回退 | board_pred_match_rate=1.0（N≥20） | ☑ 基线 1.0（4.1 gate）· 待 overlay v2 复验 |
| P4.2-BENCH | 机读报告 | `docs/phase4_poc_evidence/fpga_rb_fullnet_*_perf.json` + 一页更新 | ☑ perf JSON + 一页已落盘 · lat 红 |
| P4.2-ROOT | 根因关闭 | MMIO 细粒度踢门不再占墙钟主导（或书面豁免） | ☐ MMIO 仍主导 · RTL 草案 `fullnet_tick_scheduler.v` |

**其它业务指标**（吞吐/功耗/多板 GWT/场景 KPI 等）：**不绑本表**，由对应业务/OR **单独定标** 后再挂门禁。

**工程方向（非穷尽）**：DMA/AXI-stream · 减少 PS↔PL 往返 · PL 内调度 · 批处理。

**关单**：P4.2-LAT/ACC/BENCH（+ROOT 或豁免）绿 + neuro-ci + IPD（另开 WO）后，才解除 STALL 登记表。

---

## 3. STALL 登记表（依赖性能 → 必须先 4.2）

| STALL-ID | 位置 | 为何依赖性能 | 4.2 前允许做什么 |
|----------|------|----------------|------------------|
| **STALL-P7-2** | Phase7 · workspace payload 走板端/daemon 链（性能相关验收） | 跨板延迟/comm 无尺子 | 只写映射**草稿文档** |
| **STALL-P7-3** | Phase7 · e2e GWT tick≥1 **跨板实跑验收** | 整网/链路延迟未达标则验收无意义 | 仿真侧 GWT 不挡 |
| **STALL-P8-EN** | Phase8 · 能效（墙插+延迟表） | 延迟表以 4.2 为输入 | 文献/算法草案；**不开**能效验收 |
| **STALL-DEMO-FPGA** | 对外/评审「FPGA 整网加速/实时」话术与演示 | 当前 ≈306s/张 | **禁止** |
| **STALL-4CLOSE-PERF** | 把「Phase4 性能闭环」写进关单/里程碑 | 4.1≠性能过 | 4.1 只可标 **功能可用** |

### 明确不 STALL（可与 4.2 并行）

| ID | 内容 |
|----|------|
| P5-1…P5-3 | 感知数据/训练/特征向量（软件） |
| GWT-0 / GWT-1…3 | 4090 **仿真** MVP |
| P7-1 | 模块→节点映射**表草稿**（无板测 KPI） |
| Phase8 文献/小仿真（若 F2 解除） | 不含能效板测 |
| Phase4.2 本身 | 与 Phase5 **并行** |

---

## 4. 与主链关系（修订后）

```text
Phase4.1 功能可用 ──┬──► Phase5 + GWT-0/6 仿真（并行）
                    │
                    └──► Phase4.2 性能 ──► 解除 STALL-* ──► P7-2/P7-3、P8 能效、FPGA 加速话术
```

---

## 5. 已裁定 / 待办

| 项 | 状态 |
|----|------|
| P4.2-LAT ≤ **100 ms/张** | ✅ 总裁 2026-08-05 接受 |
| 其它业务指标 | ✅ 同意：**单独定标**（不塞进 4.2-LAT） |
| 本 STALL 表 | ✅ 按登记执行 |

下一刀：**WO-DEV-NEURO-F7-PERF** exec rework（2026-08-05T1633）：离线充实 `fullnet_tick_scheduler.v` + Verilator 骨架 + overlay v2 TCL 草案；**板 192.168.137.3 DOWN** → perf JSON 标 `board.status=unreachable`；**P4.2-LAT 仍 FAIL**（≈306s/张）→ **STALL 保持** → 需 overlay v2 bitstream + 板可达复测。

---

*陈正共 · 裁定落盘 2026-08-05*
