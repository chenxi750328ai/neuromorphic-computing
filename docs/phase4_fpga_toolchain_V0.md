# Phase4 · FPGA 开发链路 V0（通/不通标准）

> **负责人**：陈正共 · ChenZhengGong  
> **合格定义（总裁）**：类脑功能经 **FPGA 工具链** 开发并部署到 **PL** 真实运行，留下 **结果 + 规格 + 资源占用**。  
> **明确不算**：板载点灯、仅 ARM 上跑 Python 定点。

---

## 1. 链路台阶

```text
[1] HLS/RTL 源码（lif_step）
      ↓
[2] RTL/HLS 仿真 ≡ Python golden     ← 本仓可无 Vivado 完成
      ↓
[3] Vivado/Vitis 综合 → utilization.rpt + .bit/.hwh   ← 本机缺口
      ↓
[4] PYNQ sudo Overlay 烧 PL
      ↓
[5] 板上读 spk / 延迟 / 与 golden 对照
```

门禁脚本：

```bash
python3 scripts/fpga_lif_rtl_sim.py --gate
python3 scripts/phase4_fpga_toolchain_gate.py --gate   # full_pl 须 bitstream
```

---

## 2. 本机现状（2026-07-14）

| 台阶 | 状态 |
|------|------|
| HLS `fpga/hls/lif_step.cpp` | ✅ |
| RTL `fpga/rtl/lif_step.v` | ✅ |
| RTL 语义 ≡ golden | ✅ `fpga_lif_rtl_sim.py` |
| PYNQ ping/ssh | ✅ |
| PYNQ **sudo** 加载 base Overlay（PL 可编程权限） | ✅ |
| **vivado / vitis_hls 可执行文件** | ❌ **未安装** |
| `fpga/bitstreams/lif_step_overlay.bit` | ❌ 缺 |
| 资源报告 LUT/BRAM/DSP | ❌ 缺 |

**结论**：开发链路的「板端加载权 + 源码/仿真」已通；**综合出类脑 bitstream 被 Vivado 断点卡住**。

---

## 3. 解开断点（二选一）

1. **告诉陈正共**：Vivado/Vitis 安装路径（Windows 或 Linux），例如  
   `C:\Xilinx\Vivado\2022.2\bin\vivado.bat`  
   或设置环境变量 `VIVADO_PATH` / `XILINX_VIVADO`。  
2. **批准安装**：Vivado ML/WebPACK（含 `xc7z020`）到本机或指定 build 机。

安装后执行：

```bash
cd fpga/hls && vitis_hls -f run_lif_step.tcl
# 与/或
cd fpga/vivado && vivado -mode batch -source create_lif_overlay.tcl
# 拷贝产物
mkdir -p ../bitstreams
cp outputs/lif_step_overlay/* ../bitstreams/
python3 ../../scripts/phase4_fpga_pynq_lif_pl.py --gate
python3 ../../scripts/phase4_fpga_toolchain_gate.py --gate
```

---

## 4. 产物目录约定

| 路径 | 含义 |
|------|------|
| `fpga/bitstreams/lif_step_overlay.bit` | 可烧 PL |
| `fpga/bitstreams/lif_step_overlay.hwh` | PYNQ 解析 |
| `fpga/bitstreams/lif_step_utilization.rpt` | LUT/FF/BRAM/DSP |
| `runs/phase4_poc/fpga_lif_pl_run.json` | 板上延迟与脉冲 |

---

*陈正共 · 2026-07-14*
