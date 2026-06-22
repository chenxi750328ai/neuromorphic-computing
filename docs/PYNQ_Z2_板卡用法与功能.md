# PYNQ-Z2 板卡用法与功能介绍

> **设备**：Xilinx PYNQ-Z2（E-FPGA）  
> **镜像**：PynqLinux 3.0（Ubuntu 22.04 衍生）  
> **类脑项目角色**：Phase4 **路径 B** — 边缘脉冲累加 / 低功耗推理探索  
> **连接真源**：[PYNQ_Z2_配置与连接状态.md](./PYNQ_Z2_配置与连接状态.md)

---

## 1. 这块板是什么？

PYNQ-Z2 是一块 **Zynq-7000** 异构 SoC 开发板：

| 部分 | 芯片 | 能做什么 |
|------|------|----------|
| **PS（处理系统）** | 双核 ARM Cortex-A9 | 跑 Linux、Python、Jupyter |
| **PL（可编程逻辑）** | Artix-7 FPGA | 加载 bitstream，做自定义硬件加速 |

**PYNQ** = Python + Zynq：用 Python 加载 FPGA 设计（overlay），通过 API 控制板载外设，无需手写 Verilog 即可做原型。

与 **Atlas 200 DK** 对比：

| | Atlas 200 DK | PYNQ-Z2 |
|---|--------------|---------|
| 算力类型 | 昇腾 NPU（ANN/SNN OM） | FPGA 可定制逻辑 |
| 强项 | 快速把 ONNX/OM 跑起来 | 脉冲累加、事件驱动、极低延迟 IO |
| 类脑 Phase4 | **路径 A**（已完成真 SNN 上板） | **路径 B**（定点 LIF / HLS 试点） |

---

## 2. 板载资源一览

### 2.1 指示灯与按键

| 外设 | 编号 | 说明 |
|------|------|------|
| 绿色 LED | LD0–LD3 | 4 颗单色 LED |
| RGB LED | LD4、LD5 | 三色，颜色用 3-bit 编码（1=蓝，2=绿，4=红） |
| 按键 | BTN0–BTN3 | 4 个物理按钮 |
| 拨码开关 | SW0、SW1 | 2 位输入 |

### 2.2 扩展接口

| 接口 | 用途 |
|------|------|
| **PMOD** ×2 | pmod 传感器/执行器（Grove 等） |
| **Arduino** 盾 | Arduino 兼容扩展 |
| **Raspberry Pi** 帽 | RPi HAT 兼容 |
| **HDMI** 入/出 | 视频采集与显示（base overlay） |
| **音频** | 耳机孔 + 板载麦克风 |

### 2.3 软件栈

```
浏览器 Jupyter Lab (:9090)
    ↓
Python 3.10 + pynq 3.1（venv）
    ↓
XRT + base.bit（overlay）
    ↓
PL：GPIO / HDMI / MicroBlaze IOP / …
```

---

## 3. 三种使用方式

### 方式 A：Jupyter 网页（推荐入门）

1. 浏览器打开：http://192.168.137.3:9090/lab  
2. 左侧打开 **`neuromorphic/01_fpga_blue_led_demo.ipynb`**（类脑点灯示例）  
3. 菜单 **Run → Run All Cells**  
4. 观察 **LD4 蓝灯** 与 RGB 变色

Jupyter 内核以 root 运行，可直接 `BaseOverlay("base.bit")`，无需 sudo。

### 方式 B：SSH + Python 脚本

```bash
ssh xilinx@192.168.137.3
export XILINX_XRT=/usr
echo xilinx | sudo -S python3 fpga_blue_led.py 5
```

CLI 加载 overlay 需要 sudo（写 SLCR/PL 寄存器）。

### 方式 C：串口兜底

网口 IP 丢失时，用 COM10 @ 115200 登录，或跑 `fpga-serial-setip.ps1` 恢复 `192.168.137.3`。

---

## 4. 核心概念

### 4.1 Base Overlay

出厂预装 **`base.bit`**，映射板载 GPIO、HDMI、音频等到 Python 对象：

```python
from pynq.overlays.base import BaseOverlay
base = BaseOverlay("base.bit")

base.leds[0].on()              # 绿灯 LD0
base.rgbleds[4].write(1)       # LD4 蓝色（bit0）
base.buttons[0].read()         # 读 BTN0
```

### 4.2 Overlay 与类脑的关系

全量 SNN 上 FPGA 需要 HLS/Vitis 综合；Phase4 路径 B **首步不做全网络**，而是：

1. **定点 LIF 单步** — 与仿真 `MnistSNNUnrolled` 对齐  
2. **脉冲累加计数** — 对应推理输出 `spk_sum`  
3. **板上 Python 演示** — 有脉冲时闪蓝灯（事件驱动原型）

详见 [phase4_fpga_path_b.md](./phase4_fpga_path_b.md)。

---

## 5. 常用 Notebook 路径

| 路径 | 内容 |
|------|------|
| `neuromorphic/01_fpga_blue_led_demo.ipynb` | **类脑定制** · 蓝灯 + RGB 循环 |
| `base/board/board_btns_leds.ipynb` | 官方 · 按键控制 LED/RGB |
| `getting_started/1_jupyter_notebooks.ipynb` | 官方 · Jupyter 入门 |
| `getting_started/4_base_overlay_iop.ipynb` | 官方 · overlay 与 IOP |

---

## 6. 网络与同网设备

```
PC (192.168.137.101)
  ├── Atlas 200 DK (192.168.137.2)  ← Phase4 路径 A · 真 SNN OM
  └── PYNQ-Z2      (192.168.137.3)  ← Phase4 路径 B · 脉冲累加 PoC
```

| 项 | 值 |
|----|-----|
| SSH | `xilinx@192.168.137.3` / `xilinx` |
| Jupyter | http://192.168.137.3:9090/lab |
| 串口 | COM10 · 115200 |

IP 已持久化至 `/etc/network/interfaces.d/eth0`。

---

## 7. 故障排查

| 现象 | 处理 |
|------|------|
| ping 不通 | 串口改 IP 或查 `fpga-serial-setip.ps1` |
| `import pynq` 失败 | 确认 `pynq_venv.pth` 存在；`export XILINX_XRT=/usr` |
| `No Devices Found` | 设 `XILINX_XRT=/usr`；用户需在 `render` 组 |
| Overlay 报 Root permissions | CLI 用 `sudo python3`；Jupyter 内无此问题 |
| 板子 pip 失败 | 无外网，用镜像内 venv 包 |

---

## 8. 仓库脚本索引

| 脚本 | 用途 |
|------|------|
| `scripts/fpga_blue_led.py` | SSH 蓝灯 |
| `scripts/fpga_pynq_setup.sh` | 一键配置 IP + Python + 冒烟 |
| `scripts/phase4_fpga_lif_fixedpoint.py` | 定点 LIF 参考实现 + 对齐验证 |
| `scripts/phase4_fpga_pynq_spike_demo.py` | 板上脉冲累加 + 闪灯 |
| `scripts/fpga_deploy_notebooks.sh` | 推送 Jupyter 示例到板子 |

---

*陈正共 · ChenZhengGong*
