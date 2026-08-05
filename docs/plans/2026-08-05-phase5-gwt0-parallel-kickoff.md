# Phase5 + GWT-0 并行开工计划（不等 VP 关单才动手）

> **作者**：陈正共 · 2026-08-05  
> **总裁口径**：5/6/7/8 能并行的就并行。  
> **纪律**：不代 VP 关 F7 WO；不宣称 Phase4.1 已关；Phase8 工程仍要 F2 书面句。

## Branch / PR

| 项 | 值 |
|----|-----|
| 分支 | `feature/phase5-gwt0-parallel-kickoff` |
| 拟 PR | `docs+plan(phase5): 并行开工 Phase5/GWT-0 + F7 延迟一页 — 陈正共` |

## 并行矩阵（本轮可做）

| 轨 | 本轮产出 | 仍等人 |
|----|----------|--------|
| 4.1 收尾 | — | VP 关 DEV/TEST |
| **Phase5 · P5-1** | 事件/N-MNIST loader 规格 + smoke 骨架（下一切） | 全量训等资源 |
| **GWT-0** | 协议评审清单（请总裁/PL 批注） | 书面批注 |
| Phase6 | 已有 `gwt_mvp_exam` stub；用随机向量跑 stage1 不挡 | 接真 P5-3 后升 GWT-2 |
| Phase7 | 仅映射表草稿（后续） | 上板 e2e |
| Phase8 | 不派工 | F2 书面解除 |

## GWT-0 评审清单（待勾）

真源：`docs/GWT_工作区协议_V0.md`

- [ ] K=32 / k_active=8 / D=256 可接受为仿真默认
- [ ] 竞争写 top-k + 广播读语义 OK
- [ ] workspace ≠ M4 emit 文本（边界清楚）
- [ ] 升 V0.1 或批「按 V0 开 GWT-1」

## Phase5 · P5-1 下一刀（工程）

1. 选定数据源：N-MNIST 或 MNIST→事件编码（二选一写死）  
2. `scripts/phase5_event_loader.py` + `tests/test_phase5_loader_smoke.py`  
3. 门禁：`--smoke` exit 0 · 产出 `runs/m1_perception/loader_smoke.json`  
4. **不**在本 PR 宣称 P5-2/P5-3 完成

## 与 F7 性能

延迟一页：`docs/phase4_poc_evidence/F7_整网延迟与性能_一页_20260805.md`（≈306s/张，功能通非加速）。  
性能优化另 WO，可与本轨并行。

---

*陈正共 · ChenZhengGong*
