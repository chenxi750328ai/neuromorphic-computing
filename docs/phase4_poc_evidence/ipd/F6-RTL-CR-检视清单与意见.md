# F6 S0 · RTL 检视清单与意见（陈正共）

**范围**：`fpga/rtl/lif_step.v`、`fpga/rtl/lif_step_axi_lite.v`  
**检视日**：2026-07-28  
**仿真证据**：`docs/phase4_poc_evidence/fpga_lif_verilator_gate.json`（Verilator PASS）  
**结论**：**PASS_WITH_NOTE**（可进板级/Vivado 辅证；不豁免后续改 RTL 复跑 Verilator）

---

## 检视清单

| # | 项 | 结果 | 备注 |
|---|----|------|------|
| 1 | 复位极性与异步复位一致性 | PASS | `rst_n` / `s_axi_aresetn` 低有效异步复位 |
| 2 | Q16.16 定点与软件金标一致 | PASS | BETA=58982、THRESH=65536；Verilator vs golden 13 步 0 mismatch |
| 3 | 溢出/截断策略明确 | NOTE | `prod[63:0]` 仅取 `[47:16]`，高位未饱和钳位；正常输入范围内与 Python 一致 |
| 4 | FSM 无死锁/非法态 | PASS | 默认回 `st=0`；`done` 单周期脉冲 |
| 5 | `start` 采样窗口 | NOTE | `start` 仅在 `st==0` 采样；脉冲须 ≥1 clk；AXI 包装以 `start_pulse` 保证 |
| 6 | AXI-Lite 单 beat 握手 | PASS_WITH_NOTE | 简化从机：要求 aw/w 同拍就绪；无 outstanding；wstrb 忽略 |
| 7 | `done_sticky` 清读语义 | NOTE | 读 `0x0C` 清 sticky；主机须先读 STATUS 再读 MEM_OUT，避免丢 done |
| 8 | 复位后寄存器初值 | PASS | cur/mem/start 清零 |
| 9 | 可综合性（无仿真专用） | PASS | 无 `$display`/延时；适合 xc7z020 |
| 10 | 开源仿真可复现 | PASS | `scripts/phase4_fpga_lif_verilator_gate.py --gate` |

---

## Findings

1. **F-1（低）**：`lif_step` 乘法结果未做饱和；异常大 `mem_in` 时行为依赖二补码回绕。板上 M-lif 输入受 fc/权重约束，可接受；若扩动态范围须加钳位并复跑门禁。  
2. **F-2（中·协议）**：AXI-Lite 非完整从机（无 aw/w 分离、无错误响应）。现有 PYNQ MMIO 用法足够；若接通用互联须加固。  
3. **F-3（文档）**：寄存器图与实现一致（CTRL/CUR/MEM_IN/STATUS/MEM_OUT）；建议在 `fpga/README` 或策略文档交叉引用本清单。

---

## 信任根声明（对照 F6）

| 层 | 状态 |
|----|------|
| Verilator 开源仿真 | **主** · 本轮 PASS |
| 人工 RTL CR | **本文件** · PASS_WITH_NOTE |
| 板上/定点金标 | 既有 R-A/R-B 证据（辅） |
| Vivado synth/bit | **辅** · 不作唯一信任根 |

**签署**：陈正共（作者检视）· 待 QA 行记录 / VP 知悉  
**不宣称**：Phase4.1 关单；Phase8 仍默认阻断。
