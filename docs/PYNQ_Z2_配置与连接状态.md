# PYNQ-Z2 · 配置与连接状态

> **设备**：E-FPGA · Xilinx PYNQ-Z2  
> **负责人**：陈正共 · 硬件环境陈小六  
> **更新**：2026-06-22 · **已联调 · 四项验收 PASS**

---

## 1. 凭据与地址

| 项 | 值 |
|----|-----|
| **SSH** | `xilinx@192.168.137.3` |
| **密码** | `xilinx` |
| **串口** | **COM10** · **115200** · 8N1 |
| **Jupyter** | http://192.168.137.3:9090/lab |
| **PC 以太网** | `192.168.137.101/24` |
| **Atlas** | `192.168.137.2` |

**IP 已持久化**：`/etc/network/interfaces.d/eth0` → `192.168.137.3/24`（重启后保持，除非 SD 卡重置）。

---

## 2. 验收记录（2026-06-22）

| # | 项 | 结果 |
|---|-----|------|
| 1 | IP 持久化 | ✅ `/etc/network/interfaces.d/eth0` static 137.3 |
| 2 | pydantic / pynq | ✅ `pynq_venv.pth` + `XILINX_XRT=/usr` |
| 3 | Jupyter 网页 | ✅ `/lab` `/tree` HTTP 200 |
| 4 | Python 蓝灯 LD4 | ✅ `sudo python3 fpga_blue_led.py` |

---

## 3. 快速使用

### SSH

```bash
ssh xilinx@192.168.137.3
export XILINX_XRT=/usr
python3 -c "import pynq; print(pynq.__version__)"
```

### Jupyter（浏览器）

http://192.168.137.3:9090/lab  
**类脑点灯示例**：http://192.168.137.3:9090/lab/tree/neuromorphic/01_fpga_blue_led_demo.ipynb（Run All Cells）  
官方示例：`base/board/board_btns_leds.ipynb`

### 点亮蓝灯（LD4）

```bash
# 板上或 SSH
export XILINX_XRT=/usr
echo xilinx | sudo -S python3 /path/to/fpga_blue_led.py 5
```

> **说明**：加载 `base.bit` 需 root（写 SLCR/PL）。Jupyter 内核以 root 运行，notebook 内无需 sudo。

### 一键重装（从 PC/WSL 推脚本）

```bash
cd /home/cx/neuromorphic-computing
sshpass -p xilinx scp scripts/fpga_pynq_setup.sh scripts/fpga_blue_led.py scripts/fpga-pynq-eth0.interfaces xilinx@192.168.137.3:/home/xilinx/
sshpass -p xilinx ssh xilinx@192.168.137.3 'bash /home/xilinx/fpga_pynq_setup.sh'
```

### 串口兜底（IP 丢失时）

```powershell
powershell -File C:\Users\Public\fpga-serial-setip.ps1
```

---

## 4. 修复说明

| 问题 | 根因 | 处理 |
|------|------|------|
| `import pynq` 缺 pydantic | system python 未链 venv site-packages | `pynq_venv.pth` 指向 venv |
| `No Devices Found` | 未设 `XILINX_XRT` | `/etc/profile.d/pynq_xrt.sh` |
| XRT open 失败 | 用户不在 render 组 | `usermod -aG video,render xilinx` |
| Overlay 需 root | SLCR mmap | CLI 用 `sudo python3`；Jupyter 已 root |
| 板子无外网 pip | DNS 不可用 | 用镜像内 venv 包，勿在线 pip |

---

## 5. 脚本清单

| 文件 | 用途 |
|------|------|
| `scripts/fpga-pynq-eth0.interfaces` | 静态 IP 模板 |
| `scripts/fpga_pynq_setup.sh` | 板上四项一键配置 |
| `scripts/fpga_blue_led.py` | LD4 蓝灯 |
| `scripts/fpga_probe_network.py` | WSL 连通探测 |
| `scripts/fpga-serial-*.ps1` | Windows 串口 |

日志：`runs/phase4_poc/fpga_pynq_setup.log`

---

## 6. 同网拓扑

```
PC (137.101) ──┬── Atlas 200 DK (137.2)
               └── PYNQ-Z2 (137.3)
```

---

*陈正共 · ChenZhengGong*
