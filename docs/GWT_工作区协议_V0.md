# GWT 工作区协议 V0

> **负责人**：陈正共 · ChenZhengGong  
> **状态**：V0 草案 · **GWT-0 门禁待评审**  
> **上级**：[GWT_愿景与阶段依赖_V1.md](./GWT_愿景与阶段依赖_V1.md)

---

## 0. 目的

定义 **Global Workspace（工作记忆总线）** 的机读格式与读写语义，供 Phase6 GWT-MVP 仿真与 Phase7 异构 payload 共用。**本协议描述的是类脑多模块系统内部总线，不是 LLM residual stream，也不是 MNIST SNN 的 LIF mem。**

---

## 1. 设计约束（GWT 功能对齐）

| 约束 | 值 / 规则 |
|------|-----------|
| **容量** | 小：默认 **K=32 概念槽**（可配置 16–64） |
| **稀疏** | 每 global tick 活跃槽 ≤ **k_active=8** |
| **格式统一** | 所有模块 read/write 同一 tensor 布局 |
| **竞争写** | 多模块 submit → **top-k 得分** 入槽，其余丢弃本 tick |
| **广播读** | tick 末所有模块收到 **W 快照**（只读副本） |
| **与输出分离** | workspace **≠** M4 emit 文本；emit 由 M4 读 W 后再决策 |

---

## 2. 数据结构

### 2.1 Workspace 张量 `W`

```text
W.shape = [K, D]          # K 槽位，D 维特征（默认 D=256）
W.dtype = float32       # 仿真；Phase7 可定点化
W.active_mask.shape = [K] # bool，本 tick 哪些槽有效
W.tick: int              # global tick 序号
W.version: int           # 协议版本，当前 0
```

### 2.2 模块写请求 `WriteCandidate`

```text
module_id: str          # "M1" | "M2" | "M3" | "M4"
vector: float[D]         # 候选写入向量（模块内部投影后）
score: float             # 竞争分数（模块自报或 gate 网络输出）
slot_hint: int | null    # 可选偏好槽；null 表示仅按 score 竞争
```

### 2.3 竞争写算法（默认 · GWT-0）

```text
输入: candidates[] , 当前 W
1. 按 score 降序排序
2. 取 top min(len(candidates), k_active) 个
3. 依次填入 active 槽：优先空槽，否则替换 score 最低活跃槽
4. 更新 W.active_mask
5. W.tick += 1
输出: W' , write_log[]（审计用）
```

### 2.4 广播读

```text
每个模块在 tick t 收到 broadcast(W_t) — W 的深拷贝或不可变视图
模块不得假设其他模块未读；并行读同一快照
```

---

## 3. Global tick 生命周期

```text
tick t:
  1. PARALLEL  各模块 local_step(input_t, broadcast(W_{t-1})) → candidates
  2. COMPETE   workspace_merge(candidates) → W_t
  3. BROADCAST 分发 W_t 到所有模块
  4. LOG       可选：写 runs/gwt/tick_{t}.json（探针/调试）
```

**T 默认**：GWT-2 验收 **T ≥ 8**；MNIST 分类 MVP 可 T=8..16。

---

## 4. 模块接口（Phase6 实现规格）

```python
# 规格；实现路径 scripts/gwt/modules/*.py（待建）

class GWTModule(Protocol):
    module_id: str

    def local_step(
        self,
        sensory_input: Tensor,
        workspace: WorkspaceSnapshot,
    ) -> tuple[Tensor, WriteCandidate | None]:
        """并行阶段：本地计算 + 可选写候选"""
        ...

    def read_emit(self, workspace: WorkspaceSnapshot) -> EmitDecision:
        """仅 M4：从 W 产生 emit 指针 / 类 id（人话经 D1/D2）"""
        ...
```

| 模块 | 默认职责 | 写 workspace？ |
|------|----------|----------------|
| M1 感知 | 图像/事件 → 特征 | 是 |
| M2 关联 | 特征关联、短期绑定 | 是 |
| M3 执行 | 简单规划/路由 | 是 |
| M4 输出 | 读 W → emit | 读为主，可写 status |

---

## 5. Phase7 异构 payload 映射

跨节点传输 **最小包**：

```json
{
  "proto": "gwt-workspace-v0",
  "tick": 12,
  "K": 32,
  "D": 256,
  "active_mask": "base64...",
  "W": "base64 float32 [K,D] 或 sparse 编码",
  "write_log": [{"module_id": "M1", "score": 0.82, "slot": 3}]
}
```

**依赖 Phase4.1 分工**：payload 大小、是否 sparse、是否 FP16 由 bench 结论驱动（见 [Phase4.1_链路bench与分工报告_V1.md](./Phase4.1_链路bench与分工报告_V1.md)）。

---

## 6. 验收（GWT-0 门禁）

| ID | 检查项 | 方法 |
|----|--------|------|
| GWT-0-a | 本文档 PL 评审 | 签字/看板记录 |
| GWT-0-b | K/D/k_active 默认值冻结 | 改须 CCB 或总裁 hotfix |
| GWT-0-c | 竞争写伪代码可实现 | `scripts/gwt_workspace.py` 单测（Phase6 前可 stub） |

---

## 7. Non-goals（V0 不做）

- 不对应 LLM J-lens 向量或词表对齐  
- 不要求与 MnistSNN 25 tick 兼容  
- 不在 Phase4.1 关单前上板传输 workspace  
- 不宣称生物 GWT 完整实现  

---

## 8. 开放问题（评审填）

| # | 问题 | 建议 |
|---|------|------|
| Q1 | D=256 是否从 M1 感知 dim 对齐？ | Phase5 输出 dim 冻结后回填 |
| Q2 | 竞争 score 谁算？ | MVP：模块输出 norm；GWT-2：可学习 gate |
| Q3 | workspace 是否持久化跨 session？ | MVP：单 session；陈东 episode 只存 emit + W 摘要 hash |

---

*2026-07-10 · 陈正共 · GWT-0 草案*
