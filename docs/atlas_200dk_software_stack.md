# Atlas 200I DK A2 · 软件栈与推理样例

> 探测时间：2026-06-21 · 主机 **davinci-mini** · SSH `root@192.168.137.2`  
> **2026-06-22 更新**：三项验证（YOLO 推理 / Jupyter / ATC）均已完成。

---

## 结论（TL;DR）

| 层级 | 状态 | 说明 |
|------|------|------|
| NPU 硬件 / 驱动 | **可用** | `npu-smi info` · Health OK |
| CANN Runtime（ACL） | **可用** | `acl.init()` 成功，`libascendcl.so` 存在 |
| **OM 模型推理** | **已验证** | `yolo.om` / `yolov5s_custom.om` · `world_cup.jpg` 检出 3 目标 |
| **ATC 模型转换** | **已验证** | `yolov5s.onnx` → `yolov5s_custom.om`（input: **input_image**） |
| **Jupyter Notebook** | **已运行** | `http://192.168.137.2:8888/?token=atlas` |
| **PyTorch** | **已装** | torch **2.1.0** + torchvision **0.16.0**（离线 wheel） |
| MindSpore 训练 | **未装** | 可按需补装 |

---

## 已安装版本

| 组件 | 版本 / 路径 |
|------|-------------|
| OS | Ubuntu 22.04.3 LTS · aarch64 · kernel 5.10.0+ |
| NPU | Ascend **310B4** |
| 固件 / 驱动 | **23.0.rc2** / **6.2.2.0.b133** |
| CANN Toolkit | **7.0.RC1.3**（`7.0.0.8.220`） |
| 安装路径 | `/usr/local/Ascend/ascend-toolkit/latest` |
| mxVision | **5.0.RC2** |
| Python | 3.10.12（系统） |
| 内存 / 磁盘 | ~3.4 GiB RAM · `/` 117G（约 78G 可用） |

环境变量（推理前执行）：

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH
```

---

## 已实测：YOLOv5 真实图片推理（步骤 1）

脚本：`scripts/atlas_yolo_infer.py`（AclLite + numpy/cv2，无需 torch）

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH
cd /home/HwHiAiUser/samples/notebooks/01-yolov5
python3 atlas_yolo_infer.py --image world_cup.jpg --out /tmp/world_cup_detect.jpg
```

**结果（2026-06-22）**：

| 检测 | 置信度 |
|------|--------|
| sports_ball | 0.936 |
| person | 0.839 |
| person | 0.602 |

推理耗时 ~**46 ms**（`yolo.om`）。结果图：`docs/atlas_manual_figures/world_cup_detect.jpg`

---

## Jupyter Notebook（步骤 2）

板子无公网，依赖由 PC **离线 wheel** 灌入（`/tmp/atlas_wheels`）。

```bash
# 板子上启动（已在跑则可跳过）
/home/HwHiAiUser/samples/notebooks/atlas_start_notebook.sh
```

**访问**：`http://192.168.137.2:8888/?token=atlas`  
样例目录：`/home/HwHiAiUser/samples/notebooks/`（01-yolov5 … 09-speech-recognition）

> 注：安装的是 **Notebook 6.5.7**（非 JupyterLab）。Notebook 内视频样例可能还需 `skvideo`。

---

## ATC：ONNX → OM（步骤 3）

脚本：`scripts/atlas_atc_yolov5.sh`

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
cd /home/HwHiAiUser/samples/notebooks/01-yolov5
# 注意：ONNX 输入节点名是 input_image，不是 images
atc --model=yolov5s.onnx --framework=5 --output=yolov5s_custom \
  --input_format=NCHW --input_shape="input_image:1,3,640,640" \
  --soc_version=Ascend310B4
```

**结果**：`yolov5s_custom.om`（~15 MB），AclLite 推理与 `yolo.om` 检出一致。  
结果图：`docs/atlas_manual_figures/world_cup_atc_detect.jpg`

---

## 预置样例与可跑应用

### 1. Notebook 实验（Jupyter Lab）

目录：`/home/HwHiAiUser/samples/notebooks/`

| 目录 | 应用 |
|------|------|
| `01-yolov5` | 目标检测（含 **yolo.om**） |
| `02-ocr` | OCR |
| `03-resnet` | 图像分类 |
| `04-image-HDR-enhance` | HDR 增强 |
| `05-cartoonGAN_picture` | 卡通化 |
| `06-human_protein_map_classification` | 蛋白质图分类 |
| `07-Unet++` | 分割 |
| `08-portrait_pictures` | 人像 |
| `09-speech-recognition` | 语音识别 |

启动：用 `scripts/atlas_start_notebook.sh`（已绑定 **192.168.137.2:8888**，token=`atlas`）。  
Notebook `main.ipynb` 使用 `ais_bench.InferSession`；若缺包可改用 `atlas_yolo_infer.py`（AclLite）路径。

### 2. Model Adapter 预置 OM

目录：`/home/HwHiAiUser/samples/model-adapter-models/`

| 类型 | 路径 / 模型 |
|------|-------------|
| 分类 | `cls/edge_infer/mobilenetv3_100_bs1.om` |
| 检测 | `det/infer_project/output/yolov5s_bs1.om` |
| 分割 | `seg/edge_infer/model_bs1.om` |
| 关键点 | `keypoint/infer/models/fast_res50_256x192_aipp_rgb.om` |

含 `edge_infer` / `infer_project` 工程，适合 **OM + ACL** 部署，不依赖 Notebook。

### 3. mxVision

路径：`/usr/local/Ascend/mxVision-5.0.RC2/samples/mxVision/`

- C++ / Python pipeline 样例  
- `python/samples/main.py` + `run.sh`  
- 面向视觉 pipeline、流式推理

### 4. CANN 工具链

| 工具 | 状态 |
|------|------|
| `npu-smi` | 可用 |
| `atc` | 已安装（需按模型格式传参验证） |
| `acl` Python | 可用（需 `set_env.sh`） |
| `acllite` | 可用（需 PYTHONPATH） |
| `te` / `op_test_frame` | 可用 |
| `msame` / `ais-bench` | **未找到**（可按 CANN 文档单独安装） |

---

## Python 依赖现状

| 包 | 状态 |
|----|------|
| `numpy` | 1.21.5（系统）+ 2.2.6（torch 依赖） |
| `opencv-python` (cv2) | 4.5.4 |
| `torch` / `torchvision` | **2.1.0 / 0.16.0** |
| `notebook` | **6.5.7** |
| `ipywidgets` | **8.1.1** |
| `acl` / `te` / `acllite` | 有（CANN 自带 + PYTHONPATH） |
| `mindspore` / `ais_bench` | **未装** |

---

## 脚本索引

| 脚本 | 用途 |
|------|------|
| `scripts/atlas_yolo_infer.py` | 真实图片 YOLO OM 推理 |
| `scripts/atlas_atc_yolov5.sh` | ONNX → OM（ATC） |
| `scripts/atlas_start_notebook.sh` | 启动 Jupyter Notebook |

---

## 与类脑 / Phase4

- **冒烟**：SSH + `npu-smi` **已过**
- **推理链路**：AclLite + OM **已跑通**（含 ATC 自转换模型）
- **下一步**：类脑 Phase4 模型 ONNX → `atc` → 板端 `atlas_yolo_infer.py` 同类脚本推理

---

## 相关文档

- [连接与登录](./atlas_200dk_usb_connect.md)
- [昇腾样例中心](https://gitee.com/HUAWEI-ASCEND/samples)
- [Atlas 200I DK A2 资源页](https://www.hiascend.com/hardware/developer-kit-a2/resource)
