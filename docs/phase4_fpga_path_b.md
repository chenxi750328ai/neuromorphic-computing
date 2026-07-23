# Phase4 路径 B · FPGA 在类脑项目中的作用与实施

> **设备**：PYNQ-Z2（E-FPGA）  
> **与路径 A 关系**：Atlas 已完成真 SNN OM 上板（PR #5）；FPGA 补 **事件驱动 / 定点 / 可定制逻辑** 长线能力  
> **TR2 决策**：默认路径 A；路径 B 为 **A+B 补充**，不阻塞 Atlas 收工

---

## 1. 4R 简版

### purposeStack（优先级）

1. **验收**：路径 B 首步 PoC 可脚本复现、有日志留档  
2. **不浪费**：复用已联调 PYNQ，不接全网络 HLS  
3. **派发速度**：板上 Python 演示 + WSL 定点对齐，一轮可交付

### chain（主链）

```
4090 SNN checkpoint (96.97%)
  → MnistSNNUnrolled 展开图（25 步 LIF）
  → [WSL] phase4_fpga_snn_fixedpoint.py 全网络 Q16.16
  → [WSL] phase4_fpga_tri_compare.py ORT/Atlas/定点 三路对照
  → [PYNQ] phase4_fpga_pynq_spike_demo.py 脉冲闪灯（≠类脑上PL）
  → [RTL] fpga/rtl/lif_step*.v + write_lif_bitstream.tcl
  → [PYNQ] phase4_fpga_pynq_lif_pl.py  **E4 PASS 2026-07-23**
  → runs/phase4_poc/fpga_lif_pl_run.json · fpga_toolchain_gate.json
```

> 详细：[Phase4.1_Wave1_进展报告_20260723.md](./Phase4.1_Wave1_进展报告_20260723.md) · [phase4_fpga_toolchain_V0.md](./phase4_fpga_toolchain_V0.md)
### owners

| 站 | 责任人 | PASS 信号 |
|----|--------|-----------|
| 板卡连通 | 陈小六 / 陈正共 | SSH + Jupyter 200 |
| 定点参考 | 陈正共 | `max_diff == 0` on toy vectors |
| 板上演示 | 陈正共 | `FPGA_SPIKE_DEMO_OK` in log |
| QA 留档 | 陈小五 VP | `QA_验收记录_Phase4.md` S3c |

### gates

| 门禁 | 命令 |
|------|------|
| 板通 | `python3 scripts/fpga_probe_network.py --ip 192.168.137.3` |
| 定点 | `.venv/bin/python3 scripts/phase4_fpga_snn_fixedpoint.py` |
| 三路对照 | `.venv/bin/python3 scripts/phase4_fpga_tri_compare.py` |
| 板上 | `python3 scripts/phase4_fpga_pynq_spike_demo.py --host 192.168.137.3` |

### gaps（本轮新发现）

- 全量 MNIST 定点推理需 PL 或长时间 ARM 算力，**超出 v0**  
- Vitis HLS 未装在本机 WSL，首步用 **Python 定点 + 板上事件闪灯** 代替 RTL  
- CLI overlay 需 sudo；Jupyter 示例给用户演示

### next

- 可选：单层 256→10 定点累加在 PL（HLS）  
- 与 Atlas `spk_sum` 抽样对比（WARN 级，非 bit-exact）

---

## 2. 为什么需要 FPGA？（相对 Atlas）

| 维度 | Atlas（路径 A） | FPGA（路径 B） |
|------|-----------------|----------------|
| **已完成** | 真 SNN OM、ORT diff=0 | 板卡联调、base overlay |
| **优势** | NPU 吞吐、工具链成熟 | 自定义神经元、亚毫秒 IO、功耗可塑 |
| **类脑契合** | 仿真→OM 迁移 | **脉冲累加**、稀疏事件、传感器直驱 |
| **CHARTER 长线** | 边缘推理部署 | 神经形态硬件协处理、FINN/Spiking 定制 |

路径 A 回答：「SNN 能不能上专用 AI 芯片？」  
路径 B 回答：「脉冲推理的核心算子，能不能在可编程逻辑里以定点、事件方式落地？」

---

## 3. 技术映射（仿真 → FPGA）

`MnistSNNUnrolled` 单步 LIF（与 snnTorch subtract reset 对齐）：

```
mem  = beta * mem + cur - reset * threshold
spk  = (mem >= threshold) ? 1 : 0
spk_sum += spk   # 25 步累加后 argmax → 分类
```

- **定点脉冲须按 Q16.16 缩放**：spk=1 在全连接输入中应为 `65536`，非整数 `1`（已修）

### next

- `vitis_hls -f fpga/hls/run_lif_step.tcl` 综合 LIF IP 上 PL  
- 定点推理搬上 PYNQ ARM（单张 MNIST 实时分类 + 闪灯）

---

## 3. 技术映射（仿真 → FPGA）

`MnistSNNUnrolled` 单步 LIF（与 snnTorch subtract reset 对齐）：

```
mem  = beta * mem + cur - reset * threshold
spk  = (mem >= threshold) ? 1 : 0
spk_sum += spk   # 25 步累加后 argmax → 分类
```

**v0**：单神经元定点 + 板上闪灯  
**v1（本轮）**：**全网络 Q16.16** 在 WSL 跑通，512 样本 **97.27% acc**，与 float **100% pred 一致**  
**v2（待做）**：HLS `lif_step` + fc 乘加 IP 上 PL

---

## 4. 已实施交付物

| 产物 | 说明 |
|------|------|
| `scripts/phase4_fpga_lif_fixedpoint.py` | 单步 LIF toy 对齐 |
| `scripts/phase4_fpga_snn_fixedpoint.py` | **全网络**定点推理 reference |
| `scripts/phase4_fpga_tri_compare.py` | ORT / Atlas / 定点 三路对照 |
| `scripts/phase4_fpga_pynq_spike_demo.py` | 板上脉冲闪灯 |
| `fpga/hls/lif_step.cpp` | HLS 单步 LIF 核 |
| `notebooks/fpga/01_fpga_blue_led_demo.ipynb` | Jupyter 点灯 |
| `runs/phase4_poc/fpga_fixedpoint_snn.json` | 定点全网络验收 |
| `runs/phase4_poc/fpga_tri_compare.json` | 三路对照（fixed↔Atlas pred **100%**） |

---

## 5. 验收标准（路径 B v1）

| # | 标准 | 状态 |
|---|------|------|
| B1–B4 | 联调 / Jupyter / 闪灯 | ✅ |
| B5 | 全网络 Q16.16 vs float pred ≥95% | ✅ **100%** · acc **97.27%**/512 |
| B6 | 定点 vs Atlas 分类 pred 一致 | ✅ **100%**（8 样本探针） |
| B7 | HLS IP 综合上 PL | ⏳ 需 Vitis 环境 |

---

*陈正共 · ChenZhengGong · 2026-06-22*
