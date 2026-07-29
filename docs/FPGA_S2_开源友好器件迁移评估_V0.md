# F6 S2 · 开源友好器件/板卡迁移评估 V0

**作者**：陈正共 · ChenZhengGong  
**日期**：2026-07-28（修订：同日 **实测** 补证）  
**状态**：评估落盘 + **本机 openXC7 实测证据**（**未**板上加载；**未**改主路径）  
**关联**：`docs/plans/2026-07-28-fpga-sovereign-toolchain.md` · `docs/FPGA_工具链安全可控策略_V0.md`  
**证据**：`docs/phase4_poc_evidence/fpga_z2_openxc7_try.json`（软逻辑 PASS）· `fpga_z2_openxc7_try_carry.json`（加法器 P&R FAIL）

---

## 1. 为何需要 S2

| 已具备（S0/S1） | 本轮实测后仍缺 |
|-----------------|----------------|
| RTL 可 Verilator 仿真 | **LIF/带 CARRY4 的设计** 在本构建的 nextpnr-xilinx 上 **路由未过** |
| Yosys + 钉版本 Vivado 辅证 bit | **板上加载/PCAP/PS 协同** 未做 |
| — | 产品级闭环（复现、CI、整网）未建 |

现板 **PYNQ-Z2（xc7z020）** 继续作：Atlas 协同、双通证据、Vivado 辅证平台。  
S2 回答：**若要把「出 bit」也迁出 Vivado，候选是什么、代价是什么；Z2 本身能不能开源出 bit。**

---

## 2. 实测（禁止 pen）— xc7z020 + openXC7

**命令**：`python3 scripts/phase4_fpga_z2_openxc7_try.py --design soft --gate`  
**工具链（本机）**：Yosys 0.33 · openXC7/nextpnr-xilinx `stable-backports@62839b3` · 自建 `xc7frames2bit` · `prjxray-db` zynq7

| 阶段 | soft（LFSR，无 CARRY） | carry（加法计数） | 官方 artyz7-20 blinky（对照） |
|------|------------------------|-------------------|-------------------------------|
| synth_xilinx | PASS | PASS | PASS |
| chipdb xc7z020clg400-1 | PASS（缓存） | PASS | PASS |
| nextpnr-xilinx → fasm | **PASS** | **FAIL route** | **FAIL route**（同型 CARRY） |
| fasm2frames → xc7frames2bit | **PASS → `.bit` ~4.0 MB** | — | — |
| 板上加载 | 未做 | — | — |

**结论（机械）**：

1. **Z2 可以开源出 bit**（至少 PL 软逻辑 smoke）：`pass_full_open_bit=true`，证据见 JSON。  
2. **不能 pen 说「Zynq-7000 开源后端无闭环」**——闭环在 blinky 级已通。  
3. **加法器/CARRY4 路径当前阻塞**（本构建 nextpnr 路由失败；官方计数示例同样失败）。`lif_step` 含算术，**尚未**证明开源可实现。  
4. Vivado 钉版本仍是 **LIF/生产辅证** 默认，直到 CARRY/整网开源 P&R 绿 + 板上 gate。

复现 RTL：`fpga/openxc7_try/blinky_z2_soft.v` + `pynq_z2_leds.xdc`。  
大体积工具链在 `third_party/openxc7-try/`（已 gitignore）。

---

## 3. 候选对照（研究轨，已按实测修正）

| 候选 | 开源综合→bit | 资源量级 vs 现 LIF | 与 Atlas/现网 | 备注 |
|------|----------------|-------------------|---------------|------|
| **维持 Z2 + Vivado 辅** | ⚠ **smoke bit 已开源可出**；LIF/CARRY 仍闭源辅 | 已验证（~379 LUT LIF） | ✅ 现网双通 | **默认过渡**；开源补 CARRY/板上后再评估降级 Vivado |
| Lattice **ECP5** | ✅ Yosys+nextpnr-ecp5 成熟 | 中大 | 须重做板级 | 若 CARRY/整网在 Z2 开源长期不通，仍是迁移首选 |
| Lattice **iCE40** | ✅ | 偏小 | 弱 | 仅极简 PoC |
| Gowin 等 | ⚠ | 中 | 弱 | 跟踪 |

**并行整网（256 LIF）**在 Z2 已撞 LUT 墙；迁 ECP5 **不自动**解决架构问题。

---

## 4. 建议（研究轨默认）

1. **主推理/加速路径**：维持 **Atlas +（可选）Z2 PL**；信任根 **Verilator + RTL-CR**；**LIF bit 辅证仍 Vivado 2023.2**。  
2. **Z2 开源路径**：继续迭代 — 修 CARRY/P&R 或换工具链钉版本 → 再跑 `lif_step` → 板上 gate；脚本门禁可挂 `phase4_fpga_z2_openxc7_try.py --gate`。  
3. **S2 器件迁移 PoC 触发**（须总裁书面）：硬主权要求无 Vivado **且** Z2 开源在合理工期过不了 LIF/整网。触发后首选 **ECP5** 同构移植。  
4. **不触发采购**：不改 `NEURO-V1` 主器件绑定。

---

## 5. 架构真源挂钩（未改绑定）

现网说明书仍写 PYNQ-Z2 为 FPGA 样机载体。  
**本评估不修改该绑定**；仅登记：开源出 bit 在 Z2 上 **已 smoke 证明**，产品路径仍待 CARRY/LIF/板上。

---

## 6. 非目标

- 本 PR 不买板、不默认切换 bitstream 路径  
- 不解除 Phase8/STDP  
- 不宣称 Phase4.1 关口关闭  
- **不把「未板上验证的 .bit」写成生产就绪**

---

*陈正共 · 2026-07-28（实测修订）*
