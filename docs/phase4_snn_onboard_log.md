# Phase4 · SNN 真模型上板问题记录

> **负责人**：陈正共 · ChenZhengGong  
> **checkpoint**：`runs/20260527T092534Z/checkpoint.pt`（test **96.97%**，timesteps=25）  
> **真源脚本**：`scripts/phase4_export_snn_unrolled.py` · `scripts/phase4_deploy_snn_atlas.py`

---

## 问题 1：snnTorch LIF 无法直导 ONNX

| 项 | 内容 |
|----|------|
| **现象** | `phase4_export_onnx.py` 对 `MnistSNNOnnx` trace 失败 |
| **根因** | `snn.Leaky` 带膜电位状态、`spike_grad` 自定义 autograd；ONNX 不支持 |
| **曾用兜底** | `model_ann_surrogate.onnx`（ReLU MLP）— **非 SNN** |
| **解法** | `MnistSNNUnrolled`：25 步 LIF **静态展开**为 `Linear + Greater + Mul + Add` |
| **验证** | PyTorch vs 展开图 max diff **0**；test acc **96.97%** 不变 |

---

## 问题 2：训练 timesteps 与导出不一致

| 项 | 内容 |
|----|------|
| **现象** | 旧导出默认 `timesteps=10`，训练为 **25** |
| **影响** | 精度/脉冲计数与 checkpoint 不一致 |
| **解法** | 导出脚本默认 `--timesteps 25`，与 `config.json` 对齐 |

---

## 问题 3：缺少 onnx / onnxruntime

| 项 | 内容 |
|----|------|
| **现象** | WSL `.venv` 初装无 `onnx` 包 |
| **解法** | `.venv/bin/pip install onnx onnxruntime` |
| **验证** | ORT vs PyTorch max diff **0**，pred match **100%** |

---

## 问题 4：Atlas ATC 耗时长

| 项 | 内容 |
|----|------|
| **现象** | 25 步展开图 ONNX ~844KB，ATC 编译约 **6–8 分钟** |
| **解法** | 一次编译留档 `mnist_snn.om`（~1.67MB）；冒烟可跳过重复 ATC |
| **产物** | 板端 `/tmp/phase4_snn/mnist_snn.om` |

---

## 问题 5：ATC 输入节点名

| 项 | 内容 |
|----|------|
| **现象** | 与 YOLO 不同，本模型 ONNX 输入名为 **`input`**（非 `images`） |
| **解法** | `--input_shape="input:1,1,28,28"` |

---

## 问题 6：板端 vs ORT 数值对齐

| 项 | 内容 |
|----|------|
| **方法** | 固定 seed=42 输入 → ORT(CPU) vs Atlas AclLite |
| **结果** | `max_abs_diff=0.0`，脉冲计数 **bit-exact** |
| **留档** | `runs/phase4_poc/snn_board_align.json` |

---

## 上板结果（PASS）

| 步骤 | 命令/产物 | 结果 |
|------|-----------|------|
| 导出 | `phase4_export_snn_unrolled.py` → `model_snn.onnx` | ✅ |
| ATC | `phase4_atlas_snn_smoke.sh` → `mnist_snn.om` | ✅ |
| 推理 | AclLite `spike_counts (1,10)` | ✅ ~3–16ms |
| 对齐 | `phase4_compare_snn_board.py` | ✅ diff=0 |

**Atlas 冒烟日志示例**：

```
PASS ok infer_ms=16.44 spike_counts_shape=(1, 10) pred=[5]
```

---

## 复现命令

```bash
cd /home/cx/neuromorphic-computing
.venv/bin/pip install onnx onnxruntime
.venv/bin/python scripts/phase4_export_snn_unrolled.py \
  --checkpoint runs/20260527T092534Z/checkpoint.pt
.venv/bin/python scripts/phase4_deploy_snn_atlas.py
.venv/bin/python scripts/phase4_compare_snn_board.py
```

板端仅推理（OM 已存在）：

```bash
ssh root@192.168.137.2
source /usr/local/Ascend/ascend-toolkit/set_env.sh
export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH
python3 /tmp/phase4_snn/phase4_atlas_snn_smoke.py --model /tmp/phase4_snn/mnist_snn.om
```

---

*2026-06-22 · 陈正共 · ChenZhengGong*
