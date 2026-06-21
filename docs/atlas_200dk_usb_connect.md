# Atlas 200I DK A2 · 连接与登录

> 板子：**davinci-mini** · Ubuntu 22.04 · NPU **310B4** · CANN **7.0.RC1.3** / 固件 **23.0.rc2**  
> 官方文档：[Type-C 登录](https://www.hiascend.com/document/detail/zh/Atlas200IDKA2DeveloperKit/23.0.RC2/Hardware%20Interfaces/hiug/hiug_0005.html) · [网口连接](https://www.hiascend.com/document/detail/zh/Atlas200IDKA2DeveloperKit/23.0.RC2/qs/qs_0011.html) · [串口登录](https://www.hiascend.com/document/detail/zh/Atlas200IDKA2DeveloperKit/23.0.RC2/Hardware%20Interfaces/hiug/hiug_0006.html)

---

## 网段对照（实测 · 2026-06）

| 接口 | 板子 IP | PC IP | 说明 |
|------|---------|-------|------|
| **eth1 网线直连**（推荐） | **192.168.137.2** | **192.168.137.101** | 本机 netplan 配置，**不是**文档常见的 .100 |
| **Type-C USB（RNDIS）** | **192.168.0.2**（usb0） | **192.168.0.101** | 须 Windows 装好 USB RNDIS6 |
| 掩码 | 255.255.255.0 | 同左 | **网关 / DNS 留空**（WiFi 负责上网） |

### 与官方文档的差异

昇腾文档常写 eth1 = **192.168.137.100**。本板 **`/etc/netplan/01-netcfg.yaml`** 实际为：

```yaml
eth1:
  addresses: [192.168.137.2/24]
usb0:
  addresses: [192.168.137.100/24]   # 137.100 配在 USB 口上
```

**SSH 请用：**

```bash
ssh root@192.168.137.2
# 密码 Mind@123
```

**不要**把 **192.168.137.2** 设到 PC 上（会与板子冲突）。

---

## 网线连接（当前主用）

> **原则**：WiFi 自动获取、负责上网；Realtek 以太网只连 Atlas，**不设网关**。

1. 网线：**PC Realtek 千兆口 ↔ Atlas eth1**（不是 eth0）
2. Realtek IPv4 手动：**192.168.137.101 / 24**，网关、DNS **留空**
3. 验证：

```powershell
ping 192.168.137.2
ping 8.8.8.8          # 外网仍应通（走 WiFi）
ssh root@192.168.137.2
```

4. WSL 内同样可达（经 Windows 转发）：

```bash
ssh root@192.168.137.2
```

### 一键脚本（只动 Realtek 口）

右键管理员运行：`scripts/atlas-eth-safe.ps1`（会 ping `.2` 与 `.100` 两个候选地址）

### 上网挂了怎么恢复

1. WLAN → IPv4 → 全部改回自动  
2. Realtek → IPv4 → 自动（或仅保留 137.101 且**网关留空**）  
3. `ipconfig /flushdns`

---

## 串口连接（调试 / 查 IP）

| 项目 | 值 |
|------|-----|
| 40Pin | Pin8=TX → TTL **RX**，Pin10=RX → TTL **TX**，Pin9=GND，**红线不接** |
| 波特率 | **115200** 8N1 |
| 登录 | **root** / **Mind@123** |
| 启动乱码 | 正常（U-Boot / 彩色 banner） |

Windows USB-TTL（PL2303）若出现 **PHASED OUT**，须换驱动 **Prolific 3.3.2.105**（`scripts/force-pl2303-legacy-admin.ps1`）。

串口探测脚本：`scripts/atlas-serial-probe.ps1`、`scripts/atlas-serial-login.ps1`

---

## Type-C USB（备用）

| 角色 | IP |
|------|-----|
| 板子 usb0 | 192.168.0.2 |
| PC | 192.168.0.101 |

### Windows RNDIS 驱动

设备管理器 → RNDIS → 更新驱动 → **Microsoft USB RNDIS6 适配器**（见官方 hiug_0005）。

脚本：`scripts/fix-atlas-rndis-admin.bat`

**相对网线的区别**：少占 RJ45、便携；但 Windows 驱动易踩坑、吞吐通常不如千兆 eth1。**开发调试优先 eth1。**

---

## 本机脚本索引

| 文件 | 用途 |
|------|------|
| `scripts/atlas-eth-safe.ps1` | 安全配置 Realtek 137.101 |
| `scripts/atlas-serial-probe.ps1` | 串口探测 / 登录 |
| `scripts/atlas-serial-login.ps1` | 串口登录并跑 `ip a` / `npu-smi` |
| `scripts/force-pl2303-legacy-admin.ps1` | PL2303 驱动切 3.3.2.105 |
| `scripts/fix-atlas-rndis-admin.bat` | RNDIS 修复 |

---

## 连接状态（2026-06-21）

| 通道 | 状态 |
|------|------|
| eth1 网线 SSH | **通** · `192.168.137.2` |
| 串口 COM7 | **通** · 115200 |
| `npu-smi` | **OK** · 310B4 |
| Type-C RNDIS | PC 侧未配（可选） |

软件栈与可跑样例见：[atlas_200dk_software_stack.md](./atlas_200dk_software_stack.md)
