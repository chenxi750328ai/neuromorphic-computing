# F7 overlay v2 集成笔记（Phase4.2 · DMA + tick scheduler）

> **WO**: WO-DEV-NEURO-F7-PERF · **分支**: `feature/phase4.2-f7-perf-lat100`  
> **状态**: 离线草案 · **板 192.168.137.3 DOWN** · 未生成 v2 bitstream  
> **作者**: 陈正飞 · 2026-08-05

## v1 → v2 差异

| 项 | v1 (`f7_fullnet_pl_fc_overlay`) | v2（目标） |
|----|-----------------------------------|------------|
| PS↔PL | 6650 次/张 MMIO kick | **1 次** `tick_start` + DMA 流 |
| 调度 | PS Python 循环 | PL `fullnet_tick_scheduler.v` |
| 数据 | 权重经 MMIO 写 | AXI HP DMA → BRAM 双缓冲 |
| 延迟 | ≈306 s/张 | 目标 ≤100 ms/张 |

## 文件

| 路径 | 说明 |
|------|------|
| `fpga/rtl/fullnet_tick_scheduler.v` | PL tick FSM（fc1→lif1→fc2→lif2 × 25 tick） |
| `fpga/vivado/create_fullnet_pl_fc_overlay_v2.tcl` | Vivado BD 草案（HP0 + tick_sched 单元） |
| `fpga/sim/tb_fullnet_tick_scheduler.cpp` | Verilator pred≡golden 骨架 |
| `fpga/sim/Makefile.tick_scheduler` | 本地 `make run` |

## Verilator 骨架（离线可跑）

```bash
cd fpga/sim
make -f Makefile.tick_scheduler run
# 期望: TICK_SCHED_SIM ok ticks=25 neurons_per_tick=532 dma_beats_last=...
python3 -m pytest tests/test_f7_tick_scheduler_sim.py -q
```

## 上板前 checklist（板可达后）

1. 完成 TCL 中 TODO：AXI DMA + tick→mac/lif 握手
2. 生成 `f7_fullnet_pl_fc_overlay_v2.bit` + `.hwh`
3. PYNQ 加载 v2 overlay，跑 `scripts/phase4_fpga_rb_fullnet_pl_fc_perf.py`（**禁 `--skip-board`**）
4. 更新 `docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_perf.json`

## STALL

P4.2-LAT 未绿前 **STALL-DEMO-FPGA** / **STALL-4CLOSE-PERF** 保持。见 `docs/Phase4.2_FPGA整网性能_与STALL登记_V0.md`。
