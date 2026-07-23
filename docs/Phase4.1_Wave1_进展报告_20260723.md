# Phase4.1 / Wave-1 进展报告（详细）

> **负责人**：陈正共 · ChenZhengGong  
> **日期**：2026-07-23  
> **性质**：诚实进展 · 有数才填 · **禁止**写成「Phase4 / 愿景已了结」  
> **看板入口**：http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html  
> **计划真源**：[优势验证阶梯与专用硬件规格_V1.md](./优势验证阶梯与专用硬件规格_V1.md)  
> **关联**：[`fpga_lif_pl_run.json`](../runs/phase4_poc/fpga_lif_pl_run.json) · [`fpga_toolchain_gate.json`](../runs/phase4_poc/fpga_toolchain_gate.json)

---

## 0. 先答：本报告是否依赖 FPGA 测试结果？

| 报告章节 | 是否依赖 FPGA 综合/上板 | 说明 |
|----------|-------------------------|------|
| **§1 Stage B 用户规格填表**（EDGE / OPC / 能耗代理） | **不依赖** | 证据在 Atlas / WSL 跑数与本地规则探针；FPGA 不改变这 4 条判决 |
| **§2 路径 B / E4 工具链**（类脑算子上 PL） | **依赖** | 合格定义=综合出 `.bit` + 烧 PL + 资源报告；点灯不算 |
| **§3 人签/合 PR** | **不依赖** | 技术报告 §8/§10、PR#12、TR2 |

**结论**：Stage B「优劣势出数」报告可以独立交付；**路径 B 闭环段落必须以 FPGA 实测为准**。本文两段都写，且 FPGA 段已用 2026-07-23 实际上板结果定稿。

---

## 1. Stage B · 用户规格填表（计数 = 4）

> 口径：场景 ID + 方案臂 + 强对照；「更差」也算进度。代理意义 ≠ 产品定型。

| # | 场景 × 规格 | 测得清？ | 相对对照 | 证据（摘要） | 诚实边界 |
|---|-------------|---------|----------|--------------|----------|
| 1 | SCN-EDGE-CAM × **US-IDLE** | 是 | **种子敏感 / 非稳健**（曾判「更好」后降级） | 3 种子 synth：2/3 安全；[`adv_edge_cam_multiseed_holdout_20260722T130939Z.json`](../runs/phase4_poc/adv_edge_cam_multiseed_holdout_20260722T130939Z.json) | 合成分布内；real_v1 更差 |
| 2 | SCN-EDGE-CAM × **US-ACC** | 是 | **种子敏感 / 非稳健**（曾判持平后降级） | 同上；3 种子仅 1/3 双臂安全 | 同上 |
| 3 | SCN-OPC × **US-IN** | 是 | **更好（代理）** | Q3 本地读盘 vs LLM 费用代理；[`adv_adapt_opc_q3_20260722T153250.json`](../runs/phase4_poc/adv_adapt_opc_q3_20260722T153250.json) | 未真实打 API；窄题 |
| 4 | SCN-OPC × **US-SL** | 是 | **更差** | Q6–Q8 新任务均需改代码；Q9 开放域 NL 静默错；N=3 复现「首次适应更差」 | 非产品；开放域远弱于 LLM |

### 1.1 未进 Stage B 计数（已出数但不够格）

| 项 | 结果 | 为何不计入 |
|----|------|------------|
| **US-EN** 紧循环 SNN vs ANN（Atlas） | 单位推理能耗 SNN ≈ ANN×**4.5** → 更差；稳态功率口径反而 SNN 略低 | 未绑 SCN-* 场景三元；两口径方向相反须并列；[`adv_pow_snn_vs_ann_comparison_20260722T192500Z.json`](../runs/phase4_poc/adv_pow_snn_vs_ann_comparison_20260722T192500Z.json) |
| **US-EN** 间歇/长 burst 四组 | 全部 **测不清**（板级 `npu-smi` 噪声） | 测不清 ≠ 优势 |
| **SNN-PoC** synth 多种子 | 3/3 holdout recall=1.0/FPR=0.0 | 是 EDGE 算法臂稳健性，**不是** US-IDLE/US-ACC 判决器结论的翻转 |

### 1.2 机做侧已尽、等人/等语义

1. 技术报告 §8 / §10、PR#12 合入、TR2 签字  
2. US-EN「运动触发→紧循环满载」混合协议（改变场景合同）须总裁/TR 拍板后才能上板改语义  
3. 外接功率计（可选）以抬高 US-EN 可测性  

---

## 2. 路径 B / E4 · FPGA 类脑算子上 PL（本轮定稿）

### 2.1 合格定义（总裁口径，未改）

```text
RTL/HLS → Vivado 综合 → .bit/.hwh + 资源报告 → PYNQ 烧 PL → 板上读脉冲/延迟
点灯 / 仅 ARM Python 定点 ≠ PASS
```

### 2.2 本轮做了什么（2026-07-23 · 总裁授权综合+上板）

| 步骤 | 结果 | 产物 |
|------|------|------|
| 修 TCL 包装路径 | 旧 `create_lif_overlay.tcl` BD wrapper 路径错误 → 新增 [`write_lif_bitstream.tcl`](../fpga/vivado/write_lif_bitstream.tcl) | 日志 `fpga/vivado/logs/write_lif_bitstream.*` |
| Vivado 2023.2 综合/实现 | **PASS** · part `xc7z020clg400-1` | [`lif_step_overlay.bit`](../fpga/bitstreams/lif_step_overlay.bit) · [`.hwh`](../fpga/bitstreams/lif_step_overlay.hwh) |
| 资源（AXI-Lite 核单独 synth） | LUT **379** / FF **204** / BRAM 0 / DSP 0（0.71% LUT） | [`lif_step_utilization.rpt`](../fpga/bitstreams/lif_step_utilization.rpt) |
| 资源（完整 overlay place） | LUT **737** / FF **663** / BRAM 0 / DSP 0（1.39% LUT） | [`lif_step_overlay_utilization_placed.rpt`](../fpga/bitstreams/lif_step_overlay_utilization_placed.rpt) |
| PYNQ 烧 PL + MMIO 步进 | **PASS** · IP `lif_step_0` @ `0x40000000` | [`fpga_lif_pl_run.json`](../runs/phase4_poc/fpga_lif_pl_run.json) |
| 与 Q16.16 golden 对照 | 脉冲序列 **逐位一致** `[0,0,1,0,0,1,1,0,0,1]`（total=4） | 同上 · `golden_match=true` |
| 工具链门禁 | **`chain_full_pl_ok=true`** | [`fpga_toolchain_gate.json`](../runs/phase4_poc/fpga_toolchain_gate.json) |

**板上序列墙钟**：约 1.66 ms / 10 步（含 MMIO 轮询；非峰值吞吐主张）。

### 2.3 这证明了什么 / 没证明什么

| 证明了 | 没有证明 |
|--------|----------|
| Cursor→Vivado→bitstream→PYNQ PL 的**类脑单步 LIF** 开发链路打通 | 全网 MNIST 分类已在 FPGA 实时跑通 |
| 数字代理上 LIF 语义与定点 golden 一致 | 真近存 / 事件核 / 产品级低功耗 |
| 点灯与「类脑上 PL」已可机械区分（门禁不再被点灯冒充） | Phase4 / 愿景关口关闭 |

---

## 3. 与旧叙事的纠偏

| 旧说法 | 更正 |
|--------|------|
| 「Vivado 未装 / 无 AMD 账号」长期写在每日计划 | 盘上 **2026-07-17** 已有 `/tools/Xilinx/Vivado/2023.2`；此前缺的是 **综合产物与上板证据**，不是「永远没装」 |
| 「路径 B 已完成」（看板曾写 Phase4 100%） | Phase4 **v0 单点 PoC** 可算完；**E4 类脑上 PL** 至本报告日期才首次闭环 |
| 「bitstreams 空 = 你点灯是假的」 | **不是**。点灯是板通；空目录只表示类脑 overlay 未落盘——现已补上 |

---

## 4. 建议总裁/TR 下一步（只需人，机器推不动）

1. 勾选技术报告 §8 / §10；合入 PR#12；TR2 签字  
2. 决定 US-EN 混合协议是否批准试跑（或采购外接功率计）  
3. （可选）要求把 `lif_step_overlay.bit` 纳入 CI 产物策略（大文件 / LFS / 仅门禁检查存在性）

---

## 5. 链接（看板 / 设计文档）

| 项 | 路径 |
|----|------|
| 本报告 | `docs/Phase4.1_Wave1_进展报告_20260723.md` |
| 计划真源 | `docs/优势验证阶梯与专用硬件规格_V1.md` |
| FPGA 工具链规格 | `docs/phase4_fpga_toolchain_V0.md` |
| 路径 B 说明 | `docs/phase4_fpga_path_b.md` |
| Phase4 技术报告 | `docs/Phase4_技术报告_总裁评审.md` |
| TR1 网页看板 | http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html |
| 本报告（看板阅读器） | http://127.0.0.1:18766/dashboard/md-viewer.html?src=%2Fdocs%2Fneuromorphic-computing%2FPhase4.1_Wave1_%E8%BF%9B%E5%B1%95%E6%8A%A5%E5%91%8A_20260723.md&from=neuro |

*陈正共 · ChenZhengGong · 2026-07-23*
