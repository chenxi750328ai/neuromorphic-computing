# Phase4 技术报告 · 总裁评审

> **项目**：类脑计算 · neuromorphic-computing  
> **负责人**：陈正共 · ChenZhengGong  
> **编制日期**：2026-06-22  
> **读者**：总裁 · 陈小五-VP（QA 追溯）  
> **关联**：[TR2 轻评审草案](./TR2_Phase4_轻评审草案.md) · [QA 验收记录](./QA_验收记录_Phase4.md) · [上板问题记录](./phase4_snn_onboard_log.md) · [FPGA 路径 B](./phase4_fpga_path_b.md)  
> **合入记录**：PR #5（真 SNN Atlas）· **PR #7**（FPGA 路径 B v1）已合 **main** @ `67c178b`

---

## 1. 总裁一页摘要

| 项 | 结论 |
|----|------|
| **Phase4 目标** | 验证训练好的 MNIST SNN（96.97%）能否迁移到 **边缘 AI 芯片（Atlas）** 与 **可编程逻辑（FPGA）** |
| **路径 A · Atlas** | ✅ **PASS** — 真 SNN OM 上板，ORT vs 板端脉冲计数 **bit-exact**（diff=0） |
| **路径 B · FPGA** | ⚠ **部分** — WSL 定点对齐 ✅；**点灯 ≠ 类脑上 PL**；HLS 综合部署+资源数据 **未做** |
| **CI** | `neuro-ci` 全绿（含 PR #7） |
| **未做（不阻塞 v0）** | Vitis HLS 综合上 PL · 全量 MNIST 板上实时分类 · N-MNIST / 产线部署 |
| **Phase4 关口** | **未关闭** — 单点 PASS ≠ Phase4 PASS；须 Phase4.1 规格对照后场景化结论（见 §10） |
| **请总裁评审** | §8（PoC / 路径）+ **§10 B1–B3**（Phase4.1 立项） |

**一句话**：Atlas 上 **真 SNN bit-exact 已跑通**；FPGA 侧目前只有 **WSL 定点对照 + 点灯**——**点灯不能算类脑上 FPGA**；要 Vitis/HLS 综合烧 PL、出规格与资源占用才算路径 B 打通。Phase4.1 关口未关。

---

## 2. 背景与范围

### 2.1 输入真源

| 项 | 值 |
|----|-----|
| Checkpoint | `runs/20260527T092534Z/checkpoint.pt` |
| 训练精度 | test **96.97%**（10 epoch 完整跑完） |
| 时间步 | **25**（与训练 config 一致） |
| 模型 | `MnistSNN` → 导出为 `MnistSNNUnrolled`（25 步 LIF 静态展开） |

### 2.2 In / Out（与 TR2 一致）

| In | Out |
|----|-----|
| 固定 checkpoint 4090 复现 | 小样本/自学习硬件验收 |
| Atlas **或** FPGA 至少一条冒烟 | 产线部署、墙插功耗正式达标 |
| ONNX/中间表示 + 推理脚本 + 日志 | CHARTER 全量 N-MNIST 迁移 |
| 文档 + CI 绿 | 多模型并行上板 |

---

## 3. 路径 A · Atlas 200DK（主推）

### 3.1 技术路线

```text
MnistSNNUnrolled（25×LIF 展开为 Linear/Greater/Mul/Add）
  → model_snn.onnx（~844KB）
  → ATC → mnist_snn.om（~1.67MB）
  → Atlas AclLite 推理 → spike_counts (1,10)
```

**关键工程决策**：snnTorch `Leaky` 无法直导 ONNX → 采用 **时间展开图**，PyTorch 与展开图 max diff **0**，精度不变。

### 3.2 验收数据

| 指标 | 结果 | 留档 |
|------|------|------|
| S1 · 4090 eval-only | **96.97%** PASS | `runs/20260608T090726Z/metrics.json` |
| S2 · SNN ONNX 导出 | PASS | `runs/phase4_export/snn_manifest.json` |
| S3 · Atlas 推理延迟 | **~3–16 ms** | `runs/phase4_poc/atlas_snn_smoke.log` |
| ORT vs Atlas 对齐 | **max_abs_diff=0.0** bit-exact | `runs/phase4_poc/snn_board_align.json` |
| 合 main | PR #5 | `fe2ea78` |

### 3.3 主要问题与解法（摘要）

详见 [phase4_snn_onboard_log.md](./phase4_snn_onboard_log.md)：

1. LIF 直导 ONNX 失败 → 展开图  
2. timesteps 10 vs 25 不一致 → 导出默认 25  
3. 缺 onnx 包 → venv 安装  
4. ATC 输入节点名 `input`（非 `images`）  
5. ATC 编译约 6–8 分钟 → 产物留档复用  

---

## 4. 路径 B · FPGA PYNQ-Z2（补充）

### 4.1 为什么做 FPGA（相对 Atlas）

| 维度 | Atlas | FPGA |
|------|-------|------|
| 已验证 | 真 SNN NPU 推理 | 定点参考 + 事件 IO 演示 |
| 优势 | 吞吐、工具链 | 自定义神经元、亚毫秒 IO、稀疏事件 |
| 类脑长线 | 边缘 AI 部署 | 脉冲累加、传感器直驱、可塑逻辑 |

路径 A 回答「SNN 能否上 AI 芯片」；路径 B 回答「脉冲算子能否以定点、事件方式落在可编程逻辑」。

### 4.2 技术路线（v1 实际交付 · 诚实账）

```text
checkpoint → MnistSNNUnrolled
  → [WSL] phase4_fpga_snn_fixedpoint.py   # 全网络 Q16.16（软件定点，非板上 PL）
  → [WSL] phase4_fpga_tri_compare.py      # ORT / Atlas / 定点 三路对照
  → [PYNQ] phase4_fpga_pynq_spike_demo.py # 板上点灯/事件闪灯（板载演示能力）
  → [HLS] fpga/hls/lif_step.cpp           # 单步 LIF 参考源码（尚未综合烧板）
```

**总裁口径（必须分清）**：

| 说法 | 是否成立 |
|------|----------|
| WSL 上定点算法与 Atlas 分类一致 | ✅ 有 JSON |
| PYNQ **点灯** | ✅ 板通了，但是 **板自带/通用演示**，**不能**代表「Cursor→FPGA 工具链已打通、类脑功能已上 FPGA」 |
| 类脑算子经 **Vitis/HLS 综合 → 烧 PL → 板上真实跑推理**，并留下延迟/精度/**资源占用（LUT/BRAM/DSP）** | ❌ **未做** —— 这才是路径 B「开发能力打通」的合格定义 |

### 4.3 验收数据

| 指标 | 结果 | 留档 |
|------|------|------|
| B5 · 定点 vs float 分类一致（WSL） | **100%** pred match；acc **97.27%**/512 | `runs/phase4_poc/fpga_fixedpoint_snn.json` |
| B6 · 定点 vs Atlas 分类一致（WSL） | **100%**（8 样本探针） | `runs/phase4_poc/fpga_tri_compare.json` |
| 板上点灯/闪灯 | PASS · **≠ 类脑功能上 PL** | `fpga_board_spike_demo.json` |
| HLS 综合上 PL + 规格/资源数据 | ❌ 未交付 | `fpga/hls/lif_step.cpp` 仅源码 |
| 合 main | **PR #7**（含上表如实范围） | `67c178b` |

### 4.4 定点要点

单步 LIF（与 snnTorch subtract reset 对齐）：

```text
mem = beta * mem + cur - reset * threshold
spk = (mem >= threshold) ? 1 : 0
spk_sum += spk   → 25 步后 argmax
```

**工程修复**：Q16.16 下 spk=1 在全连接输入中须缩放为 **65536**，非整数 1。

---

## 5. 双路径对照总表

| 验收项 | 路径 A Atlas | 路径 B FPGA | 总裁关注点 |
|--------|--------------|-------------|------------|
| **真 SNN 语义** | ✅ OM 真图 | ⚠ 仅 WSL 定点；**未**上 PL 真跑 | A 可部署；B 工具链未打通 |
| 数值可信度 | bit-exact | WSL pred 一致（探针） | 板上无类脑规格数据 |
| 延迟 / 资源 | 3–16 ms | **无** PL 延迟/LUT/BRAM/DSP | B 合格线未达标 |
| 工具链 | ATC 可用 | HLS **未**综合烧板 | 点灯不算打通 |
| CI | neuro-ci 绿 | 同左 | 可复现 |

---

## 6. 风险与诚实边界

| 风险 | 现状 | 缓解 |
|------|------|------|
| SNN 算子 ONNX 覆盖不全 | 已用展开图绕过 | 文档标明；非通用自动导出 |
| Atlas CANN 环境依赖 | 板端已冒烟 | 连接文档 + device-lab 巡检 |
| FPGA 全网络未上 PL | v1=WSL 定点 + **点灯演示** | **点灯≠类脑上 FPGA**；合格线=工具链综合部署+规格/资源数据 |
| 精度对齐非全局 bit-exact | Atlas ORT↔板 bit-exact；FPGA 为 pred 一致 | QA 表区分 S3 / S3c |
| VP QA 签字 | 待补 `VP_QA: PASS` | 不阻塞总裁技术评审 |

---

## 6.1 名词白话（§10 用）

| 词 | 人话 |
|----|------|
| **双跳** | 一次推理要跨 **两段网络路径**：① 开发机（WSL）→ Atlas；②（若启用）Atlas → FPGA 再回来。现在常说的 daemon 实验，多半只做了 **第一段**（WSL↔Atlas），还没把 FPGA 嵌进第二条腿。 |
| **daemon（守护进程）** | 板上先开一个 **常驻小服务**，一直听端口；开发机以后每来一张图就 **发请求**，不必「每张图再 SSH 登录一次」。好处是把通信从秒级压到毫秒级；**它只证明编排方式**，不证明分工定稿，更不证明 FPGA 已上 PL。 |

对比：

```text
旧丑法（逐帧 SSH）:  每张图 = 新建 SSH + 拷文件 + 跑完退出   → 很慢（秒级）
daemon（常驻）:      板上服务一直开着，每张图只发一包数据   → 快（毫秒级）
```

---

## 7. 复现命令（审计用）

```bash
cd /home/cx/neuromorphic-computing
git checkout main && git pull   # 含 PR #7

# 路径 A
.venv/bin/python3 scripts/phase4_export_snn_unrolled.py
.venv/bin/python3 scripts/phase4_compare_snn_board.py

# 路径 B
.venv/bin/python3 scripts/phase4_fpga_snn_fixedpoint.py
.venv/bin/python3 scripts/phase4_fpga_tri_compare.py
python3 scripts/phase4_fpga_pynq_spike_demo.py --host 192.168.137.3

# CI
python3 scripts/qa-neuro-baseline-run.py --tier ci
```

---

## 8. 总裁评审栏 · PoC / TR2（请勾选）

| # | 议题 | 选项 |
|---|------|------|
| R1 | **认可 Phase4 v0 单点 PoC 工程收工**（路径 A PR#5 + 路径 B PR#7） | ☐ 同意 ☐ 修改后同意 ☐ 暂缓 |
| R2 | **单点层面路径优先级**：Atlas 主部署 · FPGA 补充探索（**非正式分工定稿**） | ☐ 同意 ☐ 调整：____ |
| R3 | **暂不同意关 Phase4 关口**（纪律：须先过 Phase4.1；见 §10） | ☐ 同意「先不关」 ☐ 坚持关口：____ |
| R4 | **TR2 轻评审**（同 [TR2 草案](./TR2_Phase4_轻评审草案.md) §8） | ☐ 知情 ☐ 需拍板 |
| R5 | **批准进入 / 继续 Phase4.1**（链路优先 · 规格裁判 · 路线不预锁） | ☐ 同意 ☐ 修改后同意 ☐ 暂缓 |

**总裁签字（§8）**：________________ · 日期：________

**批注**：

---

## 9. 附录 · 文档索引

| 文档 | 用途 |
|------|------|
| [phase4_inference_poc_plan.md](./phase4_inference_poc_plan.md) | PoC 计划 |
| [phase4_snn_onboard_log.md](./phase4_snn_onboard_log.md) | Atlas 问题与解法 |
| [phase4_fpga_path_b.md](./phase4_fpga_path_b.md) | FPGA 4R 与交付物 |
| [phase4_distributed_inference_V1.md](./phase4_distributed_inference_V1.md) | Phase4.1 链路案 · B1–B3 |
| [Phase4.1_探索规格与补数议程_V0.md](./Phase4.1_探索规格与补数议程_V0.md) | 全链路规格尺子 + E2–E4 |
| [QA_验收记录_Phase4.md](./QA_验收记录_Phase4.md) | VP QA 追溯 |
| [治理_Git合并审计.md](./治理_Git合并审计.md) | 合并审计 |

---

## 10. Phase4.1 · 分布式链路立项（待总裁拍板 B1–B3）

> **真源细则**：[phase4_distributed_inference_V1.md §7](./phase4_distributed_inference_V1.md) · [探索规格 V0](./Phase4.1_探索规格与补数议程_V0.md)  
> **纪律**：Atlas/FPGA/WSL 各自 PASS ≠ Phase4 PASS；链路优先：bench → 瓶颈 → 修订分工 → 再 bench。

### 10.1 工程现状（2026-07-14 · 非关口宣称）

| 项 | 状态 |
|----|------|
| FPGA 路径 B commit+PR | **已合** PR [#7](https://github.com/chenxi750328ai/neuromorphic-computing/pull/7) |
| G1 SSH / daemon bench | 有数（ssh 不可用；daemon N=100 p50≈2.5ms / p95≈5.1ms） |
| G3 瓶颈报告 + 分工 v0→v1 | 已出稿 |
| 规格门禁报告脚本 | PR [#12](https://github.com/chenxi750328ai/neuromorphic-computing/pull/12) OPEN · neuro-ci 绿 |
| 历史 daemon vs 标签 | G-ACC **未过**（暖机后 ~97.89%）；须网通后 **vs ORT** 重测 |
| Atlas `192.168.137.2` / PYNQ `.3` | **ping 不通** → E2/E3/E4 硬件补数 blocked |

### 10.2 立项勾选（B1–B3）

| # | 议题 | 陈正共建议 | 总裁 |
|---|------|------------|------|
| **B1** | 是否同意 **链路优先、分工由瓶颈驱动**（禁止单点过关）？ | **同意** | ☐ 同意 ☐ 修改：____ ☐ 暂缓 |
| **B2** | 端到端 PoC 线是否采纳探索规格 **G-LAT**（中位≤5 ms · 95 分位≤10 ms，可改）？ | **采纳为暂定尺子** | ☐ 同意 ☐ 调整：____ ☐ 暂缓 |
| **B3** | 是否同意继续 bench/分支迭代，且 **不得**因双跳 daemon 单独关闭 Phase4.1？ | **同意继续 · 不关** | ☐ 同意 ☐ 修改：____ ☐ 暂缓 |

**总裁签字（§10 / Phase4.1）**：________________ · 日期：________

**批注**：

---

*陈正共 · ChenZhengGong · 2026-06-22 初稿 · 2026-07-14 补 §10 Phase4.1 立项栏*
