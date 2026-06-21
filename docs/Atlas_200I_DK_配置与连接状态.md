# Atlas 200I DK A2 · 配置、连接与状态

> **设备 ID**：E-ATLAS（见 [设备台账_V1](../02-org/设备台账_V1.md)）  
> **用途**：类脑 Phase4 · NPU 推理 PoC（M4-3）  
> **最后更新**：2026-06-22  
> **维护**：陈正共 / 类脑 PL

---

## 1. 登录凭据（真源）

| 方式 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| **SSH** | `root` | `Mind@123` | 默认出厂密码，**生产环境请改密** |
| **串口** | `root` | `Mind@123` | 115200 8N1 |
| **Jupyter** | — | token=`atlas` | 无单独用户名，见 §4.3 |

### SSH 示例

```bash
# PC / WSL（网线 eth1 已通时）
ssh root@192.168.137.2
# 密码：Mind@123
```

---

## 2. 硬件与软件配置

| 项目 | 值 |
|------|-----|
| 型号 | **Atlas 200I DK A2**（昇腾开发者套件） |
| 主机名 | `davinci-mini` |
| 操作系统 | Ubuntu **22.04.3** LTS · aarch64 · kernel **5.10.0+** |
| NPU | Ascend **310B4** |
| 固件 / 驱动 | **23.0.rc2** / **6.2.2.0.b133** |
| CANN Toolkit | **7.0.RC1.3**（`/usr/local/Ascend/ascend-toolkit/latest`） |
| mxVision | **5.0.RC2** |
| Python | 3.10.12 · torch **2.1.0** · notebook **6.5.7** |
| 内存 | ~**3.4 GiB** |
| 磁盘 `/` | ~**117 GiB**（约 78 GiB 可用） |
| 连接 PC | HOME1 · Win11 + WSL2 · Realtek 千兆 + WiFi |

---

## 3. 网络与 IP（本板实测）

> 与昇腾官方文档差异：**eth1 = 192.168.137.2**（非文档常见的 .100）；**137.100 配在 usb0**。

| 接口 | 板子 IP | PC IP | 网关/DNS | 用途 |
|------|---------|-------|----------|------|
| **eth1**（网线，推荐） | **192.168.137.2** | **192.168.137.101** | **留空** | SSH、推理、Jupyter |
| **usb0**（Type-C RNDIS） | 192.168.0.2 | 192.168.0.101 | 留空 | 备用（PC 侧 RNDIS 未配） |
| **eth0** | DHCP / 169.254.x | — | — | 接路由器上网口，非 PC 直连 |
| **串口** | — | COM7（PL2303） | — | 调试 / 查 IP |

netplan 真源（板子 `/etc/netplan/01-netcfg.yaml`）：

```yaml
eth1:
  addresses: [192.168.137.2/24]
usb0:
  addresses: [192.168.137.100/24]
```

---

## 4. 连接方式

### 4.1 网线 + SSH（主用）

1. 网线：**PC Realtek ↔ Atlas eth1**（不是 eth0）
2. PC 以太网 IPv4：**192.168.137.101 / 24**，**网关、DNS 留空**
3. WiFi 保持自动获取（负责 PC 上网）
4. 验证：

```powershell
ping 192.168.137.2
ssh root@192.168.137.2
```

一键脚本（PC 管理员）：`neuromorphic-computing/scripts/atlas-eth-safe.ps1`

### 4.2 串口（调试）

| 项目 | 值 |
|------|-----|
| 40Pin | Pin8=TX→TTL RX，Pin10=RX→TTL TX，Pin9=GND，**红线不接** |
| 波特率 | **115200** 8N1 |
| Windows | COM7 · 驱动 **Prolific 3.3.2.105**（非 3.9.x） |

上电启动阶段出现乱码属正常；稳定后应见 `davinci-mini login:`。

### 4.3 Jupyter Notebook

| 项目 | 值 |
|------|-----|
| URL | **http://192.168.137.2:8888/?token=atlas** |
| 样例目录 | `/home/HwHiAiUser/samples/notebooks/` |
| 启动 | `/home/HwHiAiUser/samples/notebooks/atlas_start_notebook.sh` |

### 4.4 Type-C USB（备用）

需 Windows 手动安装 **Microsoft USB RNDIS6**；板子 **192.168.0.2**，PC **192.168.0.101**。  
相对网线：便携，但驱动易踩坑；**开发优先 eth1**。

详见：[atlas_200dk_usb_connect.md](./atlas_200dk_usb_connect.md)

---

## 5. 当前状态（2026-06-22）

| 检查项 | 状态 | 备注 |
|--------|------|------|
| eth1 网线 SSH | **通** | `root@192.168.137.2` |
| 串口 COM7 | **通** | 115200 |
| `npu-smi info` | **OK** | 310B4 · Health OK |
| YOLO OM 推理 | **已验证** | `world_cup.jpg` · 3 目标 · ~46 ms |
| ATC ONNX→OM | **已验证** | `yolov5s_custom.om` · input=`input_image` |
| Jupyter :8888 | **运行中** | token=`atlas` |
| Type-C RNDIS | 未配 | PC 侧可选 |
| 板子公网 | **无** | pip/apt 需 PC 离线 wheel |

### 机读验收命令

```bash
ssh root@192.168.137.2 'npu-smi info | head -8'
ssh root@192.168.137.2 'python3 -m notebook list'
ping -c 2 192.168.137.2
```

---

## 6. 推理与工具脚本

| 脚本 | 路径 | 用途 |
|------|------|------|
| YOLO 图片推理 | `neuromorphic-computing/scripts/atlas_yolo_infer.py` | AclLite + OM |
| ATC 转换 | `neuromorphic-computing/scripts/atlas_atc_yolov5.sh` | ONNX → OM |
| 启动 Jupyter | `neuromorphic-computing/scripts/atlas_start_notebook.sh` | :8888 |
| 以太网安全配 IP | `neuromorphic-computing/scripts/atlas-eth-safe.ps1` | 只动 Realtek |

软件栈详情：[atlas_200dk_software_stack.md](./atlas_200dk_software_stack.md)

---

## 7. 相关链接

| 文档 | 说明 |
|------|------|
| [atlas_200dk_usb_connect.md](./atlas_200dk_usb_connect.md) | 网线 / 串口 / Type-C 细项 |
| [atlas_200dk_software_stack.md](./atlas_200dk_software_stack.md) | CANN、样例、推理验证 |
| [TR2 Phase4 轻评审草案](./TR2_Phase4_轻评审草案.md) | M4-3 里程碑 |
| [昇腾官方资源](https://www.hiascend.com/hardware/developer-kit-a2/resource) | 驱动与文档 |

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-06-22 | 初版：凭据、配置、eth1=.2、三项推理验证完成 |
| 2026-06-21 | 网线/串口/Jupyter/ATC 联调通过 |
