# FPGA 全链路自主可控 · 评审 Opus V0（逐段实跑验证版）

**评审人**：Opus 级工具链/自主可控交付评审 · 身份语境 陈正共项目
**日期**：2026-07-30
**仓库**：`/home/cx/neuromorphic-computing` · 分支 `feature/phase4.1-fpga-sovereign-s2`
**基线**：`docs/FPGA_全链路自主可控_评审_V0.md`（本文对其纠错并补齐）
**方法**：11 段流程**逐段实跑**或**搜仓证否**；每段给出命令 → exit → 证据 → 状态。凡未跑到的写明 SKIP 原因，不许 pen。

图例：**OK**＝自主可控工具本轮实测闭环 · **弱**＝有能力但无硬门/无证据 · **缺**＝全仓搜证不存在 · **堵**＝实测失败 · **靠闭源**＝交付在走但主权不在我方

---

## 1. 总判

| 问题 | 结论 |
|------|------|
| 全链路自主可控是否已交付？ | **否** |
| 一句话主断点 | **本机 openXC7 构建布不通任何含 `CARRY4` 的网表——最小复现是一个 8 位计数器（2×CARRY4）**，而交付核 `lif_step` 综合出 12×CARRY4＋2×DSP48E1，因此开源链根本到不了 `lif_step.bit` |
| 上一版说法是否成立 | 方向成立、**深度不足**：V0 把断点写成「带 CARRY 的网表过不了」，但没有最小复现、没有对照实验，也**没有真正把 `lif_step` 送进过 P&R** |
| 本轮新增的坏消息 | 即使修好 CARRY，`lif_step` **还有第二道坎**：`-nocarry -nodsp` 后仍在 `CEUSEDMUX_OUT`（FF 时钟使能通道）布线失败 |
| 现网 LIF 交付 | **靠 Vivado 2023.2 出 bit**；本轮 Atlas↔PYNQ 入链实跑 PASS（`match_rate=1.0`, `acc=0.9`），**功能主权在、工具主权不在** |
| 点灯级开源全链 | **本轮实测通**（Yosys→nextpnr→fasm→bit→上板 PASS），**不能**记为 LIF 交付 |

---

## 2. 逐段验证表（11 段 + 闭源旁路，一行不缺）

> 所有命令均在 `/home/cx/neuromorphic-computing` 下、2026-07-30 本轮实跑。

| # | 阶段 | 验证动作（实际命令/检查） | 实际结果 | 状态 | 证据 |
|---|------|---------------------------|----------|------|------|
| 1 | 写源码（RTL/约束在仓可审计） | `Read fpga/rtl/lif_step.v`；`git ls-files fpga/vivado/`；`find -name "*.xdc" -o -name "*.sdc"` | RTL 在仓、可读、53 行；`fpga/vivado/` 仅 `create_lif_overlay.tcl` 入库（工程 scratch 已 gitignore，正确）。**但人工可审计约束只有 `fpga/openxc7_try/pynq_z2_leds.xdc`（点灯用）；交付核 `lif_step_axi_lite` 无任何在仓 XDC/时序约束**，全部依赖 Vivado BD 自动生成的 IP XDC | **弱** | `fpga/rtl/lif_step.v`、`fpga/rtl/lif_step_axi_lite.v`、`fpga/vivado/create_lif_overlay.tcl`、`.gitignore:1,14` |
| 2 | 金标/单元测试 | `python3 scripts/phase4_fpga_lif_fixedpoint.py` | **exit 0**；`all_match=True`，4 组场景（single_spike/burst/subthreshold/mnist_like）全 PASS | **OK** | `runs/phase4_poc/fpga_spike_accum.json` |
| 3 | 自动 Lint（独立门） | `rg -n "Wall\|lint\|verible\|--lint-only" scripts/phase4_fpga_lif_verilator_gate.py`；`ls scripts/ \| rg -i "lint\|verible"`；`rg -n lint .github/workflows/ci.yml` | 全仓**无独立 lint 脚本、无 Verible/slang、CI 无 lint 步骤**；唯一 lint 效力是 `phase4_fpga_lif_verilator_gate.py:30` 的 `-Wall` 编译开关（嵌在仿真构建里，warning 不构成失败判据） | **缺**（能力弱存在，硬门不存在） | 搜仓 0 命中；`scripts/phase4_fpga_lif_verilator_gate.py:30` |
| 4 | 前仿 RTL（Verilator） | `python3 scripts/phase4_fpga_lif_verilator_gate.py --gate` | **exit 0**；`lif_step n=13 mismatches=0`、`lif_step_axi_lite spk=1 mem_out=78643`；Verilator 5.020 | **OK** | `docs/phase4_poc_evidence/fpga_lif_verilator_gate.json`（本轮重写） |
| 5 | 人工检视 RTL-CR | `find -iname "*RTL*CR*"` | 清单存在：`docs/phase4_poc_evidence/ipd/F6-RTL-CR-检视清单与意见.md`；**但不进 CI、无签核状态字段、无与 commit 的绑定** | **弱** | 同左路径 |
| 6 | 综合 Yosys（+Vivado 辅） | `python3 scripts/phase4_fpga_s1_impl_chain_gate.py --gate`；`source /tools/Xilinx/Vivado/2023.2/settings64.sh && vivado -version` | **exit 0**；Yosys 0.33 通用网表 cells=2522；Vivado 钉版 2023.2 + md5 指纹在案；`vivado -version` **exit 0** 本机可用 | **OK**（Yosys 主，Vivado 辅） | `docs/phase4_poc_evidence/fpga_s1_impl_chain_gate.json`（本轮重写） |
| 7 | 门仿（综合后门级仿真） | `rg -in "write_verilog\|post_synth\|gate_sim\|gatelevel\|iverilog" --glob '!third_party/**' --glob '!docs/**' -l` | **0 命中**（除评审文档自身提到该词）。无网表回写、无 iverilog/Verilator 门级 testbench、无门禁脚本、无证据 JSON | **缺** | 搜仓 0 命中 |
| 8 | 开源 P&R → 出 bit（openXC7） | ① `python3 scripts/phase4_fpga_z2_openxc7_try.py --design soft_ps7 --gate`<br>② `--design carry --gate`<br>③ **新增**：把真 `lif_step` 包成 5 脚 wrapper 送 nextpnr | ① **exit 0**，`OPEN_BITSTREAM_OK full_bit=True`（synth/chipdb/pnr/frames/bitstream 全 PASS）<br>② **exit 1**，`pnr exit 255`：`Failed to route arc 1 of net '$auto$alumacc...replace_alu$1614.Y[0]', SLICE_X112Y105/A1`<br>③ 综合 **exit 0**（26×CARRY4 + 2×DSP48E1），**pnr exit 255**：`Failed to route arc 1 of net 'r_cur[3]' → SLICE_X108Y104/A1` | **堵**（点灯 OK，交付核不通） | `fpga_z2_openxc7_try.json`（soft_ps7 PASS）、`fpga_z2_openxc7_try_carry.json`（FAIL）、**`fpga_z2_openxc7_lif_probe.json`（新增，LIF 首次真跑 P&R）**、`fpga/openxc7_try/lif_probe_z2.v` |
| 8b | 闭源旁路出 bit（Vivado） | `vivado -version`；`ls -l fpga/bitstreams/`；`md5sum lif_step_overlay.bit`；读 `create_lif_overlay.tcl` | Vivado 2023.2 可用；`lif_step_overlay.bit` 4045676 B 已入库（md5 `7be71d8d…`），现网在用。**未复跑全流程**（SKIP 原因：完整 BD+impl >10min 且 `_vivado_lif_overlay/` 工程目录已存在会与 `-force` 重建冲突，属破坏性操作）。**审计发现：tcl 的 BD+bitstream 整段包在 `catch{}` 里，失败只打印 `BD_BITSTREAM_SKIP` 并 `exit 0`——闭源旁路本身没有硬失败门** | **靠闭源**（且无硬门） | `fpga/vivado/create_lif_overlay.tcl:31,71-74`、`fpga/bitstreams/lif_step_overlay.{bit,hwh,rpt}` |
| 9 | 后仿（布线后/SDF 反标） | `rg -in "\bsdf\b\|read_sdf\|sdf_annotate\|post.?route" --glob '!third_party/**' --glob '!docs/**' -l` | **0 命中**。仅有 Vivado `lif_step_timing.rpt`（静态时序报告 ≠ 后仿） | **缺** | 搜仓 0 命中；`fpga/bitstreams/lif_step_timing.rpt` |
| 10 | 上板加载 | `ping -c2 192.168.137.3`（**exit 0**，1.3ms）→ `python3 scripts/phase4_fpga_z2_openxc7_board_load.py --gate` | **exit 0**，`BOARD_LOAD_OK load_ok=True`；ping/scp_bit/scp_loader/download 全 PASS；`dmesg` 实证 `writing blinky_openxc7.bin to Xilinx Zynq FPGA Manager`（本轮新时间戳 `[944152.306511]`） | **OK**（加载工具链自主可控；但加载的是**开源点灯 bit**） | `docs/phase4_poc_evidence/fpga_z2_openxc7_board_load.json`（本轮重写） |
| 11 | 板上实测 / 入链交付 | `.venv/bin/python3 scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py --gate --samples 10`（Atlas `192.168.137.2` ping **exit 0**） | **exit 0**，`{"verdict":"PASS_ra_atlas_fpga_mlif","match_rate":1.0,"acc":0.9}`。**注意：所用 PL 位流是 `fpga/bitstreams/lif_step_overlay.bit`（Vivado 产物）** | **靠闭源 bit 下 OK** | `docs/phase4_poc_evidence/fpga_ra_atlas_mlif_inchain_gate.json`（本轮重写） |
| CI | 门禁挂载面 | 读 `.github/workflows/ci.yml`；`.venv/bin/python3 scripts/qa-neuro-baseline-run.py --tier ci` | **exit 0**，CI tier 实跑 6 门：`N-CI-SYNTAX / SMOKE / SHELL / DOCS / VERILATOR / YOSYS-S1`。**FPGA 只挂 2 门（前仿+综合）**；lint / 门仿 / 后仿 / openXC7 出 bit / 上板 / 入链**均不在 CI** | **弱** | `.github/workflows/ci.yml:24,27`、`config/neuro-qa-gate-baseline.json`、`scripts/qa-neuro-baseline-run.py:110-116` |

**一句话读表**：11 段里 **OK 4 段**（金标、前仿、综合、上板工具）、**弱 4 段**（源码约束、检视、CI 覆盖、闭源旁路无门）、**缺 3 段**（独立 lint、门仿、后仿）、**堵 1 段**（开源出 LIF bit）——堵的这段就是主权交付的唯一硬断点。

---

## 3. 对自评 V0 的纠错与遗漏

| # | V0 原文 | 本轮实测判定 | 处理 |
|---|---------|--------------|------|
| C1 | 「第 8 步：开源 P&R 对带硬件加法（CARRY）的网表过不了」 | **方向对，深度不足**。V0 只有 blinky-carry 一个数据点，读者会误以为是设计规模/拥塞问题。本轮把宽度从 8 位到 20 位全跑一遍（2/3/4/5 个 CARRY4）**全部失败**，且 `-nocarry` 同一 8 位计数器**布线成功 exit 0** | **升级为最小复现 + 对照实验**（见 §5） |
| C2 | 表中第 8 行「堵（LIF）」，证据只给 `fpga_z2_openxc7_try_carry.json` | **`lif_step` 从未真正进过 P&R**。V0 用 blinky-carry 代打，属推断不属实证 | **本轮补实证**：新建 `fpga/openxc7_try/lif_probe_z2.v`（5 脚 wrapper 包真 `lif_step`），三种子（default/2/7）+ 两路由器（router2/router1）+ 三综合选项全部失败，证据落 `fpga_z2_openxc7_lif_probe.json` |
| C3 | 隐含「打通 CARRY 即可出 LIF bit」（P0 完成定义） | **不成立**。`-nocarry -nodsp` 后 `lif_probe` 仍失败于 `SLICE_X84Y133/CEUSEDMUX_OUT`（FF 时钟使能通道）——**至少两处独立缺陷** | **P0 拆成 P0-a / P0-b**（见 §4） |
| C4 | 第 1 行「写源码 OK」 | **过宽**。交付核无在仓可审计 XDC/时序约束，约束主权在 Vivado BD 自动生成物里 | 降级为 **弱**，新增 P2 项 |
| C5 | 第 8′ 行「靠闭源」但未指出旁路本身无门 | `create_lif_overlay.tcl` 把 BD+bitstream 包在 `catch{}`，失败打印 `BD_BITSTREAM_SKIP` 后 `exit 0`——**闭源链失败会静默通过** | 新增 P1 项：给闭源旁路加硬失败 + bit 哈希门 |
| C6 | 第 3 行 Lint「弱」 | 表述偏软。实测**独立 lint 门 0 个、CI lint 步骤 0 个**，`-Wall` 只是编译开关不产生判据 | 改判 **缺** |
| C7 | §7「`fpga_toolchain_gate.json` 旧 false，勿当总闸」 | 处理太软。该文件 `generated_at=2026-07-14`、`chain_full_pl_ok=false`、`blocker="本机未找到 vivado"`——与今日 `vivado -version exit 0`、入链 PASS **直接矛盾**，留着必然再绊审计 | 升级为机械动作：**重跑或加 `stale:true` 归档**，纳入 P1 |
| C8 | §7「PR#20 OPEN」 | 属实，`gh pr list` 确认 #20 `feature/phase4.1-fpga-sovereign-s2` OPEN | 维持 |
| **F1** | （V0 未提） | **证据文件互相覆盖缺陷**：`phase4_fpga_z2_openxc7_try.py` 的 `--out` 默认恒为 `fpga_z2_openxc7_try.json`，与 `--design` 无关。本轮跑 `--design carry` 时**实测把 soft_ps7 的 PASS 证据覆盖成 carry 的 FAIL**，已通过显式 `--out` 回填修复。这是证据可信度问题：任何人按文档顺序跑一遍，仓里的「PASS 证据」就变成 FAIL | 新增 P1 项：`--out` 按 design 派生 |
| **F2** | （V0 未提） | `lif_step` 除 CARRY4 外还综合出 **2×DSP48E1**（`$signed(BETA)*$signed(mem_in)`）。nextpnr-xilinx 的 DSP48 支持是**第三个未验证风险面**，本轮因先卡在布线未能触及 | 纳入 §5 待验清单 |

---

## 4. P0–P4 与机械完成定义

> 机械完成定义 = 一条可复制的命令 + 一个可检的 exit/JSON 字段。不接受「评估完成」「基本可用」。

| 优先级 | 动作 | 机械完成定义（必须逐字可检） |
|--------|------|------------------------------|
| **P0-a** | 修通 openXC7 **CARRY4 布线** | `yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top blinky; write_json /tmp/cnt8.json" /tmp/cnt8.v` 后 `nextpnr-xilinx … --json /tmp/cnt8.json --fasm …` **exit 0**，且产出 `.bit` 上板 LED 按 8 位计数节奏可见 |
| **P0-b** | 修通 **CE（CEUSEDMUX）通道**布线 | `nextpnr-xilinx` 对 `lif_probe.json`（`-nocarry -nodsp` 版）**exit 0**；先给出 ≤30 行的最小复现（本轮 11×FDRE 的 CE 用例 exit 0，说明触发条件更窄，需二分） |
| **P0-c** | **`lif_step` 开源出 bit** | `python3 scripts/phase4_fpga_z2_openxc7_try.py --design lif --gate` **exit 0** 且 JSON `stages.bitstream.ok=true`、`design` 含 `lif_step` |
| **P0-d** | 该开源 bit **上板 + 脉冲≡金标** | `phase4_fpga_z2_openxc7_board_load.py --bit <lif开源bit> --gate` exit 0 **且** 用与 Vivado 链同一判据的入链门 `verdict=PASS_*` + `match_rate=1.0` |
| **P1** | 闭源旁路加硬门 | `create_lif_overlay.tcl` 去掉 `catch{}` 静默吞错（或失败 `exit 1`）；新增 `scripts/phase4_fpga_vivado_bit_gate.py --gate`，校验 `lif_step_overlay.bit` md5 与 `.rpt` 一致性，exit 0/1 |
| **P1** | 证据覆盖缺陷 | `phase4_fpga_z2_openxc7_try.py` 的 `--out` 默认改为 `fpga_z2_openxc7_try_{design}.json`；跑三次 design 后 `git status` 只动对应三个文件 |
| **P1** | `fpga_toolchain_gate.json` 去矛盾 | 重跑该门（Vivado 已在本机）使 `chain_full_pl_ok=true`，或写入 `"stale": true, "superseded_by": [...]` |
| **P2** | 交付核**约束进仓** | 新增 `fpga/constraints/lif_step_axi_lite.xdc`（时钟周期 + 必要 IO），Vivado/开源两条链都引用它；`git ls-files fpga/constraints` 非空 |
| **P2** | 建**门仿**门禁 | `scripts/phase4_fpga_gate_sim_gate.py --gate` exit 0：Yosys `write_verilog` 网表 + Verilator/iverilog 跑与前仿同一激励，`mismatches=0` 写 JSON |
| **P3** | 独立 **lint** 门进 CI | `scripts/phase4_fpga_lint_gate.py --gate`（Verilator `--lint-only -Wall` 或 Verible）exit 非 0 即挡；`config/neuro-qa-gate-baseline.json` 新增 `N-CI-LINT` tier=ci，CI 日志出现该行 |
| **P4** | **后仿** | 能做则 SDF 反标门；开源受限做不了则写**书面降级理由 + 替代判据**（如板上时序回归门），并在本表标注「已降级·有理由」而非留空 |
| 备胎 | 仅当 P0-a/b 在合理工期内失败 → 总裁批 **ECP5/开源友好器件** | 另立项，不与 P0 平行空转 |

---

## 5. CARRY / P&R 根因假设 + 下一步验证（不空喊换板）

### 5.1 本轮实测的事实链（全部可复现）

| 实验 | 设计 | 综合结果 | nextpnr exit | 失败签名 |
|------|------|----------|--------------|----------|
| E1 | blinky soft_ps7（SRL 计时，0 CARRY4） | ok | **0** | — 出 bit 成功、上板成功 |
| E2 | 8 位计数器 `-abc9` | 2×CARRY4 | 255 | `…replace_alu$1614.Y[0]` → `SLICE_X112Y92/**A1**` |
| E3 | 12 位计数器 | 3×CARRY4 | 255 | 同签名 → `SLICE_X112Y97/**A1**` |
| E4 | 16 位计数器 | 4×CARRY4 | 255 | 同签名 → `SLICE_X112Y105/**A1**` |
| E5 | 20 位计数器 | 5×CARRY4 | 255 | 同签名 → `SLICE_X112Y103/**A1**` |
| **E6** | **8 位计数器 `-nocarry`** | **0×CARRY4** | **0** | **布通** |
| E7 | `lif_probe`（真 `lif_step`）默认 | 26×CARRY4 + 2×DSP48E1 | 255 | `r_cur[3]` → `SLICE_X108Y104/**A1**` |
| E8 | 同上 `--seed 2` | 同上 | 255 | `r_cur[3]` → `SLICE_X108Y104/**A1**` |
| E9 | 同上 `--seed 7` | 同上 | 255 | `…reintegrate$6746.A[1]` → `SLICE_X106Y142/**A1**` |
| E10 | 同上 `--router router1` | 同上 | 255 | **不同错误类**：`Found two arcs with same sink wire SITEWIRE/SLICE_X108Y108/**A1**` |
| E11 | 同上 `-nowidelut` / 无 `-abc9` | 26×CARRY4 | 255 | 同 A1 签名（**综合选项不是变量**） |
| E12 | 同上 `-nocarry -nodsp` | 0×CARRY4，251×LUT6 | 255 | **签名变了**：`… → SLICE_X84Y133/CEUSEDMUX_OUT` |
| E13 | 11×FDRE + CE + `-nocarry` | 0×CARRY4 | **0** | 布通（说明 CE 缺陷触发条件比 E12 更窄） |

### 5.2 根因假设（按证据强度排序）

**H1（主假设，E2–E6 直接支撑）**：本机 `nextpnr-xilinx`（openXC7 stable-backports @62839b3）+ `prjxray-db` chipdb 对 **CARRY4 簇周边 SLICE 输入 site-wire（观测到的沉点 100% 是 `A1`）的建模缺失或 pip 缺失**，导致进位链上的 LUT 输出无法接到相邻 SLICE 的 A1 输入。
依据：① 2 个 CARRY4 就失败，谈不上拥塞；② `-nocarry` 同设计立刻布通；③ 换种子、换宽度、换综合选项、换 router 全部失败，**唯一变量是 CARRY4 是否存在**；④ router1 报的是「两条弧共用同一 sink site-wire A1」——这是**打包/site-pin 绑定冲突**，属 arch 建模问题而非布线拥塞。
**排除项**：不是板子问题（E1 同板同 chipdb 出 bit 且上板 PASS）、不是设计太大（8 位计数器）、不是随机性（三种子同结果）。

**H2（次假设，E12/E13 支撑）**：FF 时钟使能通道（`CEUSEDMUX`）在特定打包形态下同样存在 site-wire 缺陷。E13 的简单 CE 用例布通，说明触发条件更窄（可能与 CE 网扇出、或 CE 与 SRL/LUTRAM 共 SLICE 有关），**必须二分定位**。

**H3（未触及风险）**：`DSP48E1`（`lif_step` 有 2 个）在 nextpnr-xilinx 上的支持成熟度未验证——本轮因先卡在 H1/H2 未能触及。

### 5.3 下一步验证步骤（机械、按序、每步有判据）

| 步 | 动作 | 判据 |
|----|------|------|
| V1 | 用 E2 的 8 位计数器作**最小复现包**（Verilog + json + xdc + 命令），提交上游 issue 并本地留档 | 复现包在 `fpga/openxc7_try/repro/`，一条命令重现 exit 255 |
| V2 | 换 **chipdb 生成源**：用当前 `third_party/openxc7-try/prjxray-db` 重建 `xc7z020clg400-1.bin`，对比现有 136149868 B 的产物哈希 | 哈希不同 → 说明现 chipdb 与 db 版本不一致，重跑 E2 看是否解锁 |
| V3 | 升级 `nextpnr-xilinx` 到较新 commit / openXC7 官方 release，重跑 E2 | E2 exit 0 → H1 确认为版本缺陷，直接推进 P0-c |
| V4 | 若 V3 仍失败，用 `--write` 导出 placement，检查失败 arc 两端 bel 的**物理合法性**（同 SLICE？跨列？），并在 chipdb 里查 `A1` 对应 pip 是否存在 | 明确落到「db 缺 pip」还是「packer 绑错 bel」 |
| V5 | 换器件对照：同一 8 位计数器在 **xc7a35t**（prjxray 覆盖最好的 Artix）上跑 nextpnr | 若 a35t 布通 → 缺陷限于 z020/zynq db，**这才是「换器件」的证据前提**，而不是先喊换板 |
| V6 | H2 二分：从 E13（通）逐步向 E12（不通）加特征（CE 扇出、SRL 共存、LUT6 密度），定位最小触发 | 得到 ≤30 行 CE 最小复现 |
| V7 | H3：单独把 `lif_step` 的乘法段（`-nocarry` 保 DSP）送 P&R | 得到 DSP48E1 支持的独立结论 |

**注意**：V5 之前**不得**以「换 ECP5/换板」作为结论；当前证据只支持「这套 openXC7 构建有缺陷」，不支持「Zynq 不可开源出 bit」。

---

## 6. 禁止项（口径纪律）

1. **合 PR ≠ 关口关闭**。PR #20 合入只代表点灯级开源链证据进 main，`lif_step` 开源 bit 仍为 0。关口关闭的唯一条件是 P0-a~P0-d 全绿。
2. **混合过渡 ≠ 主权交付**。「Verilator 前仿开源 + Vivado 出 LIF bit」可以作为过渡态交付**功能**，但任何文档、汇报、看板**不得**写成「全链路自主可控已交付」。当前正确表述：*功能已交付，工具主权未交付，断点在第 8 段*。
3. **不得用点灯 bit 冒充交付核**。`blinky_soft_ps7.bit` 上板 PASS 只证明工具链形状存在，与 `lif_step` 无关。
4. **不得用静态时序报告冒充后仿**，不得用编译 `-Wall` 冒充 lint 门，不得用 Verilator 冒充形式化。
5. **不得让证据自相覆盖**（见 §3 F1）。任何 gate 脚本的默认 `--out` 必须与其输入变体一一对应。

---

## 附录 A · 本轮实跑命令与 exit（可逐条复现）

```bash
cd /home/cx/neuromorphic-computing
python3 scripts/phase4_fpga_lif_fixedpoint.py                                  # exit 0
python3 scripts/phase4_fpga_lif_verilator_gate.py --gate                       # exit 0
python3 scripts/phase4_fpga_s1_impl_chain_gate.py --gate                       # exit 0
python3 scripts/phase4_fpga_z2_openxc7_try.py --design soft_ps7 --gate         # exit 0  (full_bit=True)
python3 scripts/phase4_fpga_z2_openxc7_try.py --design carry --gate \
        --out docs/phase4_poc_evidence/fpga_z2_openxc7_try_carry.json          # exit 1  (pnr 255)
ping -c 2 -W 2 192.168.137.3                                                   # exit 0
python3 scripts/phase4_fpga_z2_openxc7_board_load.py --gate                    # exit 0
ping -c 2 -W 2 192.168.137.2                                                   # exit 0  (Atlas)
.venv/bin/python3 scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py --gate --samples 10   # exit 0
.venv/bin/python3 scripts/qa-neuro-baseline-run.py --tier ci                   # exit 0  (6 gates)
source /tools/Xilinx/Vivado/2023.2/settings64.sh && vivado -version            # exit 0

# lif_step 真跑 P&R（本轮新增）
yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top blinky; write_json fpga/openxc7_try/build/lif_probe.json" \
      fpga/openxc7_try/lif_probe_z2.v fpga/rtl/lif_step.v                      # exit 0  (26 CARRY4 + 2 DSP48E1)
third_party/openxc7-try/nextpnr-xilinx/build/nextpnr-xilinx \
  --chipdb third_party/openxc7-try/chipdb/xc7z020clg400-1.bin \
  --xdc fpga/openxc7_try/pynq_z2_leds.xdc \
  --json fpga/openxc7_try/build/lif_probe.json --fasm /tmp/lif_probe.fasm      # exit 255 → A1 site-wire

# 最小复现（8 位计数器）与对照
#   -abc9   → 2×CARRY4 → nextpnr exit 255
#   -nocarry→ 0×CARRY4 → nextpnr exit 0
```

**未跑项与 SKIP 理由（如实记录）**
- Vivado 全流程复跑（8b）：`_vivado_lif_overlay/` 已存在，`create_project -force` 属破坏性重建且耗时 >10 min，本轮以 `vivado -version` + 在库 bit + 入链 PASS 三重旁证替代。
- 门仿 / 后仿（7/9）：**无脚本可跑**——SKIP 原因即结论本身（缺）。
- 开源 LIF bit 上板（P0-d）：**无 bit 可上板**，因第 8 段堵。

## 附录 B · 本轮新增/变更文件

| 文件 | 性质 |
|------|------|
| `docs/FPGA_全链路自主可控_评审_Opus_V0.md` | 新增（本文） |
| `docs/phase4_poc_evidence/fpga_z2_openxc7_lif_probe.json` | 新增 · `lif_step` 首次真跑 P&R 的失败证据 |
| `fpga/openxc7_try/lif_probe_z2.v` | 新增 · 5 脚 wrapper，诊断用，**非交付核** |
| `docs/phase4_poc_evidence/fpga_lif_verilator_gate.json` | 本轮重跑刷新 |
| `docs/phase4_poc_evidence/fpga_s1_impl_chain_gate.json` | 本轮重跑刷新 |
| `docs/phase4_poc_evidence/fpga_z2_openxc7_try.json` | 本轮重跑刷新（并修复被 carry 覆盖） |
| `docs/phase4_poc_evidence/fpga_z2_openxc7_try_carry.json` | 本轮重跑刷新 |
| `docs/phase4_poc_evidence/fpga_z2_openxc7_board_load.json` | 本轮重跑刷新（实机） |
| `docs/phase4_poc_evidence/fpga_ra_atlas_mlif_inchain_gate.json` | 本轮重跑刷新（实机 Atlas↔PYNQ） |

---

*本文为 `FPGA_全链路自主可控_评审_V0.md` 的实测升级版：V0 的结论方向保留，断点定位从「CARRY 过不了」细化到「2 个 CARRY4 即失败 + A1 site-wire 签名 + CE 通道第二缺陷」，并首次给出 `lif_step` 本体的 P&R 实证。*
