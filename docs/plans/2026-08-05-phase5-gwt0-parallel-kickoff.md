# Phase5 + GWT-0 并行开工计划（修订：4.1 功能 / 4.2 性能）

> **作者**：陈正共 · 2026-08-05  
> **总裁口径**：5/6/7/8 能并行则并行；**4.1 性能不达标不算过**（仅功能可用）；依赖性能的点 **STALL**，此前必须完成 **Phase4.2**。  
> **STALL 真源**：[Phase4.2_FPGA整网性能_与STALL登记_V0.md](../Phase4.2_FPGA整网性能_与STALL登记_V0.md)

## Branch / PR

| 项 | 值 |
|----|-----|
| 分支 | `feature/phase5-gwt0-parallel-kickoff` |
| PR | [#28](https://github.com/chenxi750328ai/neuromorphic-computing/pull/28) |

## 并行矩阵

| 轨 | 本轮 | STALL？ |
|----|------|---------|
| 4.1 功能收尾 | VP 关 DEV/TEST（功能 WO） | — |
| **Phase4.2 性能** | 开 WO：DMA/少 MMIO → 延迟门禁 | 本轨攻关中 |
| **Phase5 · P5-1…** | loader/训感知（软件） | **否** · 与 4.2 并行 |
| **GWT-0 / Phase6 仿真** | 协议批注 + `gwt_mvp_exam` | **否** |
| Phase7 P7-1 | 映射表草稿 | **否** |
| Phase7 P7-2/P7-3 | 跨板实跑/性能相关 | **STALL-P7-2/3** · 须 4.2 |
| Phase8 能效表 | — | **STALL-P8-EN** · 须 4.2+F2 |
| FPGA 加速话术/演示 | — | **STALL-DEMO-FPGA** |

## GWT-0 评审清单（待勾）

真源：`docs/GWT_工作区协议_V0.md`

- [ ] K=32 / k_active=8 / D=256 可接受为仿真默认
- [ ] 竞争写 top-k + 广播读语义 OK
- [ ] workspace ≠ M4 emit 文本
- [ ] 批「按 V0 开 GWT-1 仿真」

## Phase5 · P5-1 下一刀

1. 数据源写死：N-MNIST 或 MNIST→事件编码  
2. `scripts/phase5_event_loader.py` + smoke 测试  
3. `--smoke` → `runs/m1_perception/loader_smoke.json`  

## Phase4.2 下一刀（与 Phase5 并行）

- **P4.2-LAT**：单张 e2e ≤ **100 ms/张**（总裁已接受；当前 ≈306 s/张）  
- 其它业务指标：**单独定标**，不混进本门  
- 工程：见 STALL 登记 + F7 延迟一页

---

*陈正共 · ChenZhengGong*
