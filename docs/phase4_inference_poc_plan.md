# Phase4 · 推理 PoC 执行计划

> 配套 [TR2_Phase4_轻评审草案](./TR2_Phase4_轻评审草案.md) · 默认路径：**Atlas 200DK A2 优先**

---

## 阶段 0：基线冻结（已完成）

- Checkpoint：`runs/20260527T092534Z/checkpoint.pt`（SNN test **96.97%**）
- 对照 ANN：`runs/20260530T010904Z_ann/`（可选，非 Phase4 阻塞）

---

## 阶段 1：导出（M4-2）

```bash
cd /home/cx/neuromorphic-computing
./scripts/run_phase1.sh --eval-only   # 确认 S1
python3 scripts/phase4_export_onnx.py --checkpoint runs/20260527T092534Z/checkpoint.pt
```

**产出目录**：`runs/phase4_export/`

| 文件 | 说明 |
|------|------|
| `model.onnx` | 导出模型（或失败日志 `export_notes.md`） |
| `export_manifest.json` | 输入 shape、opset、SHA256 |

---

## 阶段 2：CPU 冒烟（无板兜底）

```bash
python3 -m pip install onnxruntime  # 若未装
python3 scripts/phase4_smoke_onnx.py --model runs/phase4_export/model.onnx
```

通过标准：单 batch 前向无异常，输出 shape 与训练脚本一致。

---

## 阶段 3：Atlas 200DK（M4-3 · 路径 A）✅

1. CANN 7.0.RC1.3 + AclLite 环境就绪（`npu-smi` OK）。  
2. `model_ann_surrogate.onnx` → ATC `input:1,1,28,28` → `mnist_snn_surrogate.om`。  
3. AclLite 单次推理 **PASS**（~0.86ms，`logits (1,10)`）。  

**留档**：`runs/phase4_poc/atlas_smoke.log` · 脚本 `scripts/phase4_atlas_mnist_smoke.{py,sh}`

若 ONNX→OM 阻塞：在 QA 记录标 **WARN**，阶段 2 CPU 冒烟仍算 Phase4 v0 部分 PASS。

---

## 阶段 4：FPGA（可选 · 路径 B）

- 仅当 TR2 勾选 B 或 A+B 时执行。  
- 首步：定点化脉冲累加模块仿真（Vitis HLS 或现有 FPGA 流程），不接全网络。

---

## 收工检查清单

- [ ] `TR2_Phase4_轻评审草案.md` 签字栏更新（VP/总裁）  
- [x] `QA_验收记录_Phase4.md` §1–2 填 PASS/WARN  
- [x] `neuromorphic-milestones.json`：`phase4` → `active`  
- [x] `docs/每日计划.md` + `reports/daily_progress.md` 追加当日块  

---

*陈正共 · 2026-06-08*
