# TR2 · Phase4 轻评审草案（Atlas / FPGA 推理 PoC）

> **负责人**：陈正共 · ChenZhengGong  
> **状态**：草案 · 待 VP/总裁轻评审勾选  
> **前置**：Phase1–3 已合 main · IPD/QA 研究轨裁剪已批 · PR #2 已合并

---

## 1. 评审目的

在 **不扩大 v1 仿真范围** 的前提下，启动 **v2 硬件推理 PoC**：验证 MNIST SNN 从 4090 训练产物到 **昇腾 Atlas 200DK A2** 或 **FPGA** 的可行导出/推理路径，为后续 N-MNIST / 边缘部署留接口。

---

## 2. 范围（In / Out）

| In（Phase4 v0） | Out（本阶段不做） |
|-----------------|-------------------|
| 固定 checkpoint：`runs/20260527T092534Z`（SNN 96.97%） | 小样本/自学习硬件验收 |
| **一条**硬件路径 PoC（Atlas **或** FPGA，见 §4 决策） | 产线部署、墙插功耗正式达标 |
| ONNX / 中间表示导出脚本 + 冒烟推理 | CHARTER 全量 N-MNIST 数据集迁移 |
| `docs/phase4_inference_poc_plan.md` 执行记录 | 多模型并行上板 |

---

## 3. 成功标准（PASS 定义）

| # | 标准 | 验证方式 |
|---|------|----------|
| S1 | 4090 上同一 checkpoint **eval-only 复现** ≥96% test acc | `run_phase1.sh --eval-only` 或等价 |
| S2 | 导出产物（ONNX 或厂商 IR）**文件可生成**，附 SHA256 | `scripts/phase4_export_onnx.py` 输出 `runs/phase4_export/` |
| S3 | 目标硬件上 **单次推理跑通**（不要求精度对齐仿真） | PoC 日志 + 截图/命令留档 |
| S4 | `neuro-ci` 绿 + Phase4 QA 记录初稿 | `qa-neuro-baseline-run.py --tier ci` |

精度对齐（仿真 vs 板端）列为 **WARN**，Phase4 v1 不强求 bit-exact。

---

## 4. 技术路线（待评审勾选）

**推荐默认：路径 A（Atlas 优先）**

| 路径 | 描述 | 优点 | 风险 |
|------|------|------|------|
| **A · Atlas 200DK** | snnTorch → ONNX → CANN/OM 推理 | 与现有 PyTorch 栈近；文档多 | SNN 算子 ONNX 覆盖不全 |
| **B · FPGA** | 量化脉冲累加 + HLS/Vitis | 与 CHARTER 长期一致 | 工期长、工具链重 |

**决策点（请勾选一项）**

- [x] **A** Atlas 优先（Phase4 v0 默认）  
- [ ] **B** FPGA 优先  
- [ ] **A+B** 并行（仅当资源允许）

SpikingJelly 迁移按 `cdt_v1_stack_alignment.md`：**Phase4 中后期**再评估，不阻塞 v0 PoC。

---

## 5. 里程碑

| ID | 内容 | 目标日 | 交付 |
|----|------|--------|------|
| M4-1 | TR2 本草案评审通过 | 2026-06-10 | 本文档签字栏 |
| M4-2 | ONNX 导出脚本 + 4090 复现 | 2026-06-12 | `scripts/phase4_export_onnx.py` |
| M4-3 | Atlas **或** FPGA 冒烟推理 | 2026-06-15 | `runs/phase4_poc/` 日志 · **2026-06-22 Atlas PASS** |
| M4-4 | Phase4 QA 记录 + 看板更新 | 2026-06-15 | `QA_验收记录_Phase4.md` |

---

## 6. 资源与依赖

- 硬件：4090（已有）· Atlas 200DK A2（已有）· FPGA 板（已有）  
- 软件：WSL · PyTorch · snnTorch · （Atlas）CANN 文档；（FPGA）Vitis 按需  
- 人：陈正共 PL；VP QA 追溯签字可后补，不阻塞 PoC 工程

---

## 7. 风险

| 风险 | 缓解 |
|------|------|
| SNN 算子无法直接 ONNX 导出 | 退化为「速率编码 ANN 近似」对照 PoC，文档标明 |
| Atlas 环境未装 CANN | 先完成导出 + CPU ONNXRuntime 冒烟 |
| 工期挤占 Phase3 维护 | Phase4 独立 `feature/phase4-*` 分支，合 main 仍走 PR + neuro-ci |

---

## 8. 评审签字（轻评审）

| 角色 | 意见 | 日期 |
|------|------|------|
| 陈正共（PL） | 路径 A · Atlas 优先 · M4-3 **PASS** | 2026-06-22 |
| VP（陈小五） | ☐ 同意 ☐ 修改后同意 ☐ 暂缓 | |
| 总裁 | ☐ 知情 ☐ 需拍板 | |

---

*陈正共 · ChenZhengGong · 2026-06-08*
