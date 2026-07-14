# GWT · Novelty Gate 设计笔记 V0（软件层）

> **作者**：陈正共 · ChenZhengGong  
> **日期**：2026-07-14  
> **动机**：西北大学 Nat. Commun. 小脑 memtransistor「常态抑制 / 异常触发」；北大 Science NDS「贵操作少搬数据」。  
> **范围**：仅 **4090 GWT 仿真** 的竞争写入前抑制层；**不**引入忆阻器/医疗 ECG scope。

---

## 1. 问题

现网 GWT-MVP（`gwt_workspace.py`）竞争写为 **top-k_active 按分数取前 k**：

- 静止/重复刺激时仍可能每 tick 写满 k 槽
- workspace 被「常态噪声」占满 → 广播读价值下降

目标：在 **不改 K / D 协议** 的前提下，加一层 **novelty / 显著性门**，使「低新奇默认不写、高新奇才竞争写」。

---

## 2. 提议接口（仿真）

```text
WriteCandidate:
  module_id, score, payload, ...
  + novelty: float ∈ [0, 1]   # 相对 workspace 快照 / 模块短时记忆

每 tick:
  1. 各模块产出 candidates
  2. novelty_gate: 过滤 novelty < τ 的（默认不参与竞争）
  3. 剩余按 score 取 top-k_active 写入
  4. 广播 snapshot
```

| 参数 | 建议默认 | 说明 |
|------|----------|------|
| τ | 0.15 | 低于此值不进竞争 |
| novelty 算法（V0） | `1 - cos_sim(candidate.payload, slot_or_mean)` | stub 可用 L2；真感知后换事件差异 |
| 强制写配额 | 每模块每 N tick ≥1 次探路（可选） | 防死锁「全员抑制」 |

---

## 3. 验收（将来挂 exam）

| ID | PASS |
|----|------|
| NG-1 | τ>0 时，静止输入下 `total_writes` **显著低于** 无门控基线（同 T） |
| NG-2 | 注入异常刺激时，异常模块仍能在 ≤2 tick 内写入 |
| NG-3 | `gwt_mvp_exam --stage 2` 仍绿（兼容协议） |

实现顺序：先单测门控函数 → 再进 `run_global_tick` → 再 `--stage 2 --novelty-gate` 可选开关。

---

## 4. Non-goals

- 不采购/仿制 memtransistor
- 不接临床心电
- 不在 Phase4.1 关单前映射到 Atlas/FPGA

---

*附录于 [GWT_愿景与阶段依赖_V1.md](../GWT_愿景与阶段依赖_V1.md) §6 · 热点 [每日热点_20260711](./每日热点_20260711.md) · [Science NDS 笔记](./Science_相变忆阻器NDS_研究笔记_20260714.md)*
