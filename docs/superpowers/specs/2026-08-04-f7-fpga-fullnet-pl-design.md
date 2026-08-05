# F7 · FPGA 整网通（Phase4.1 过关）设计

> **日期**：2026-08-04  
> **负责人**：陈正共 · ChenZhengGong  
> **总裁裁定**：方案 **3**——不管内部拆法，**板上 pred ≡ 金标** 即过关；内部默认实现走「ARM 只搬数，FPGA 算 fc+LIF」。  
> **关口**：F7 绿之前 **不得** 宣称 Phase4.1 关闭；Phase8 仍等 F2。

---

## 1. 目标（人话）

把现网 MNIST SNN（784→256→10，25 tick，Q16.16）的**整网前向计算**放到 FPGA 上跑通：

- 输入一张图（定点）→ 板上给出类别  
- 与主机金标 `FixedPointSNN` **预测一致**  
- **禁止**再用「ARM 上 Python 做矩阵乘 + FPGA 只做神经元」冒充过关（旧 R-B TMD）

---

## 2. 验收（唯一硬门）

| 项 | 阈值 |
|----|------|
| 样本数 N | ≥ 20（测试集顺序抽样，与现 B1 门一致可） |
| pred ≡ host 金标 | ≥ 98% |
| vs 标签准确率 | ≥ 90%（辅助，非替代金标） |
| 证据 JSON | `docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_gate.json` |
| 门禁 | `python3 scripts/phase4_fpga_rb_fullnet_pl_fc_gate.py --gate` → exit 0 |
| 显式字段 | `fc_on_pl=true` · `lif_on_pl=true` · `ps_role` ∈ {`load_dma_orchestrate`,`load_start_read`} |
| 反例 | 旧 `PASS_rb_tmd` / `fpga_rb_fullnet_runthrough_gate.json` **不得**当 F7 |

性能（延迟）**本关不卡**；另立账。

---

## 3. 默认实现（方案 3 下的推荐内部）

```
ARM（小电脑）              FPGA（逻辑）
─────────────              ────────────
装权重/图到内存  ──DMA/搬──►  流式 MAC（fc1/fc2）
踢 start / 读 pred          复用 lif_step（分时）
                            调度：每 tick
                              fc1→LIF×256→fc2→LIF×10
```

- **分时**：1 个 MAC + 1 个 LIF，轮流扫神经元；不做 256 核并行。  
- **权重**：Q16.16 全量 ≈795KiB > 片上 BRAM → **内存流式**喂 MAC（允许 ARM 编排搬数）。  
- **金标**：`scripts/phase4_fpga_snn_fixedpoint.py` · checkpoint `runs/20260527T092534Z/checkpoint.pt`。  
- **比特流**：优先 Vivado overlay（现网已通）；openXC7 不阻塞 F7 首绿。

### 非目标

- 正加速比 / 打赢 Atlas  
- 256 并行 LIF  
- Phase8 / 自学习  
- 改网络结构或改精度冒充（若改精度须重钉金标并书面记录）

---

## 4. 交付切片（工程顺序）

1. **MAC RTL** ≡ `linear_fp`（Verilator 单行点积）  
2. **调度 + 挂 lif_step**（仿真整网 pred≡金标，可先 N 小）  
3. **Vivado overlay + util**（证明 LUT/BRAM/DSP 拟合 Z2）  
4. **板上门禁脚本**（PS 角色写死为搬数/编排；fc 禁止 numpy）  
5. 更新一页 F7 勾选 + milestones（仍勿写 4.1 了结直至 gate 绿）

分支建议：`feature/phase4.1-f7-pl-fc`。

---

## 5. 风险

| 风险 | 处置 |
|------|------|
| 流式 MMIO 太慢 | 功能先绿；性能另工单 |
| AXI/DMA 复杂 | 可先「按行灌权重窗口」PoC，再换 DMA |
| openXC7 出不了整网 bit | F7 首绿允许 Vivado 辅后端（F6 另账） |

---

## 6. 批准栏

| # | 项 | 状态 |
|---|-----|------|
| P3 | 验收形态：方案 3（只看 pred≡金标） | ☑ 总裁 2026-08-04 |
| D-impl | 内部默认：ARM 搬数 + FPGA 分时 fc+LIF | ☑ IPD 执行 + 方案3（2026-08-04） |
| D-branch | 新开 `feature/phase4.1-f7-pl-fc` 开工 | ☑ 建单后由 DEV 检出 |

---

*陈正共 · 规格待审 · 未获 D-impl 确认前不写 RTL*
