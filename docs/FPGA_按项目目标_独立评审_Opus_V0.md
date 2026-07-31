# FPGA · 按项目目标 独立第三方评审（Opus V0）

**评审人**：独立第三方（Opus 级），非执行方、非橡皮图章
**日期**：2026-07-30
**仓库**：`/home/cx/neuromorphic-computing` · 分支 `feature/phase4.1-fpga-sovereign-s2`
**评审对象**：项目目标本身的达成度 —— 不是执行方 11 段流程表的填表完成度
**方法纪律**：
- 先从总裁裁决与计划 Goal 反推「完备应包含什么」，**再**回看仓内做到哪；
- 执行方已有的 11 段表 / A–H 表 / 自评 V0 / Opus 填表版，一律按「他们自称的方案」审，**不作为评分标尺**；
- 关键结论必须有本轮实跑命令或搜仓证否支撑（见 §5）。

> **前置声明**：本文不使用「双轨」这类并列话术。交付主权只有一个答案：**当前 100% 的 FPGA 交付位流来自 Vivado 闭源链，开源链在交付核上的产出为零。**

---

## 1. 目标重述（我理解的成功标准，可机械验收）

### 1.1 真源三条

| 来源 | 原文要点 | 我的读法 |
|------|----------|----------|
| 裁决 **F6** | 「**安全可控优先**；目标**全链路可控**；Vivado=质量验证/快验后端，**非唯一信任根**」 | 顺序是 **安全 > 可控 > 效率**。「全链路」是名词，不是「验证链」的简写 |
| 裁决 **F4/F5** | 「FPGA 加速和 FPGA 整网都要跑通」；A2 必做 | **FPGA** 加速、**FPGA** 整网。主语是 FPGA，不是「板子」 |
| 用户口语目标 | 「**端到端开发到交付，全链路自主可控**」 | 链的两端是 **需求** 和 **可交付物**，不是 RTL 和 bit |

### 1.2 可机械验收的成功标准（我给的，共 8 条）

| # | 成功标准 | 机械判据（一条命令 + 一个可检字段） |
|---|----------|------------------------------------|
| **G1** | 交付核位流可由自主可控链产出 | `lif_step` 的 `.bit` 由开源链产出，`stages.bitstream.ok=true` 且 `design` 含 `lif_step` |
| **G2** | 该位流上板功能 ≡ 生产金标 | 开源 bit 上板跑与 Vivado bit **同一入链门**，`match_rate=1.0` |
| **G3** | 主信任根能独立发现 RTL 与生产金标的语义差 | 仿真门的 golden **不是** TB 内复刻，而是引用 `scripts/phase4_fpga_lif_fixedpoint.py`；且含随机差分与边界用例 |
| **G4** | 全链在第三方干净机器上可复现 | 一条脚本从空目录拉起工具链（pin 到 commit/hash）→ 跑完 G1–G3，exit 0 |
| **G5** | 安全基线成立 | 无硬编码口令、无 `StrictHostKeyChecking=no`、位流有哈希与来源清单、存在威胁模型文档 |
| **G6** | 「加速」「整网」名副其实 | 加速：相对无 FPGA 基线有**正加速比**；整网：网络**全部算力**在 FPGA 逻辑上，PS 只做搬运 |
| **G7** | 证据不可自覆盖、门禁在 CI 内 | 每次跑落 run-id 归档；所有验收门在 `config/neuro-qa-gate-baseline.json` 内，CI 日志可见 |
| **G8** | 目标降级有书面授权 | 任何把 G1–G6 降级的写法，在裁决页有对应勾选行与签字 |

**当前得分：G1❌ G2❌ G3❌ G4❌ G5❌ G6❌ G7❌ G8❌ —— 0/8。**
（注：这不等于「什么都没做」。做了很多，但**做的事与目标的成功标准不重合**，详见 §3。）

---

## 2. 「完备」应有清单（我的分解，不抄执行方）

执行方的 A–H / 11 段是一条 **工具流水线**（写码→仿真→综合→出 bit→上板）。
「端到端开发到交付，全链路自主可控」需要的是 **交付生命周期 × 主权维度** 的二维完备，工具流水线只是其中一行。

### 2.1 交付生命周期（横轴）

| # | 环节 | 目标要求它包含什么 | 执行方 A–H 是否覆盖 |
|---|------|-------------------|---------------------|
| L1 | **需求/规格** | FPGA 侧可执行规格：接口冻结、数值域契约、性能/资源预算、失败判据 | ❌ 完全没有这一行 |
| L2 | **架构/设计** | PS-PL 边界裁定、器件绑定与二供、换器件对架构的反作用 | ⚠ 有器件绑定，无边界裁定文档 |
| L3 | **实现（RTL+约束）** | RTL **和** 时序/物理约束都进仓 | ⚠ 只有 RTL |
| L4 | **验证** | lint / 前仿 / 门仿 / 后仿 / 形式化 / 覆盖率 | ⚠ 只有前仿 |
| L5 | **实现链（综合 P&R 出 bit）** | 可控后端产出交付核位流 | ❌ 堵 |
| L6 | **集成/上板** | 位流完整性、加载路径可信、板级 OS 主权 | ⚠ 能加载，无完整性/OS 主权 |
| L7 | **系统验证** | 与生产金标一致 + 性能达标 + 回归 | ⚠ 一致性有，性能反向 |
| L8 | **发布/交付** | 交付物清单、SBOM、tag/release、第三方复现包 | ❌ 零（`git tag` 为 0） |
| L9 | **运维/变更** | 版本升级、器件 EOL、缺陷回流、变更控制 | ❌ 零 |

### 2.2 主权维度（纵轴 —— 这才是「自主可控」的定义域）

| # | 主权面 | 完备要求 | 备注 |
|---|--------|----------|------|
| S-a | **源码主权** | RTL/约束/脚本全部可审、在仓 | 约束缺 |
| S-b | **工具主权** | 工具链 pin 到 commit/hash，可离线重建 | `third_party/` 1.5 GB **未入版本控制** |
| S-c | **器件主权** | 硬核（PS7）、位流格式、部件文件的依赖与法律状态 | 从未评估 |
| S-d | **数据主权** | 位流数据库（prjxray-db 为逆向产物）、chipdb 的来源与许可 | 从未评估 |
| S-e | **位流主权** | 交付 `.bit` 的可复现性、哈希、签名、防篡改 | 无哈希门、无签名 |
| S-f | **板级 OS 主权** | PYNQ 镜像/内核/venv 的来源与固化 | 无 |
| S-g | **模型/数据主权** | checkpoint、数据集的固化与追溯 | checkpoint 路径写死在门禁里，未固化 |
| S-h | **安全主权** | 威胁模型、密钥/口令管理、访问控制 | **搜仓 0 命中** |
| S-i | **流程主权** | 独立评审（非作者自审）、签核顺序、变更控制 | RTL-CR 为作者自审 |
| S-j | **可迁移主权** | 换器件判据 + 换器件后架构是否仍成立 | 判据模糊，架构反作用未评估 |

**结论：完备面共 9×10 中的有效格约 40 个，执行方的 A–H 只覆盖 L3–L7 的一条对角线，约 8 个格。**
用 A–H 表汇报「进展」，结构上就无法暴露 L1/L8/L9 与 S-b/S-c/S-d/S-e/S-f/S-h/S-i 的整体空白。**这是流程表最大的问题：它不是不严格，它是维度不够。**

---

## 3. 现状对照：达标 / 未达标 / 偷换

### 3.1 真正达标的（应予肯定，勿一棍打死）

| 项 | 证据 | 评价 |
|----|------|------|
| Verilator 前仿进 CI 且**真的会红** | 本轮 `--gate` exit 0；`config/neuro-qa-gate-baseline.json` 有 `N-CI-VERILATOR` tier=ci | 这是 F6 之后最实的一块，**不是假绿** |
| Yosys 综合对照 + Vivado 版本指纹钉扎 | `fpga_s1_impl_chain_gate.json` md5 在案 | 有效，方向对 |
| openXC7 断点定位到最小复现 | `fpga_z2_openxc7_lif_probe.json`：真 `lif_step` 送 P&R，`r_cur[3]` 布线失败 | 这条**做得好**，是硬证据不是 pen |
| 延迟诚实披露 | QA 记录明写「远逊 G-LAT」 | 诚实，但披露口径不够（见 3.3-③） |

### 3.2 未达标（客观缺口）

| # | 缺口 | 本轮实证 |
|---|------|----------|
| U1 | **交付核零开源产出** | `lif_probe` P&R exit 255；现网 100% 用 `fpga/bitstreams/lif_step_overlay.bit`（Vivado，md5 `7be71d8d…`） |
| U2 | **交付核零时序约束、零时序签核** | `lif_step_timing.rpt` 原文：**「There are no user specified timing constraints.」**，WNS/TNS 全 `NA`，另有「204 register/latch pins with no clock」 |
| U3 | **被反复引用的 379 LUT 是无约束综合估值** | 同上报告；该数字同时是 S1 门的「Vivado util 辅证」**和** B2「并行墙 379×256」的定量依据 |
| U4 | **主信任根自证** | `fpga/sim/tb_lif_step.cpp` 的 golden 是 TB 内 C++ 复刻，含与 RTL 相同的 32 位截断；**不引用**生产金标 `FixedPointLIF` |
| U5 | **工具链供应链为零** | `git ls-files third_party \| wc -l` = **0**；1.5 GB 工具链 gitignore；nextpnr commit 只写在 JSON 自由文本；chipdb 136 MB 无哈希 |
| U6 | **安全面为零** | 搜仓「威胁模型/SBOM/供应链」**0 命中**；口令硬编码在脚本 default（`--pynq-pass xilinx`、`--atlas-pass Mind@123`）；`StrictHostKeyChecking=no`；`echo <pass> \| sudo -S` |
| U7 | **门仿 / 后仿 / 独立 lint / 形式化 全缺** | 搜仓 0 脚本、0 门禁、0 证据 |
| U8 | **交付物不存在** | `git tag` = 0；无 release、无 SBOM、无第三方复现包 |
| U9 | **CI 覆盖面 6 门，且工具版本不钉** | CI 用 `apt-get install verilator yosys`（ubuntu-latest 仓库版）；本机 Verilator 5.020 / Yosys 0.33 —— **主信任根在 CI 与本地是两套工具** |
| U10 | **验收门不在 CI** | `phase4_fpga_both_runthrough_evidence_gate.py`、`phase4_fpga_s2_migration_eval_gate.py` 均**未注册**进 baseline |
| U11 | **证据自覆盖、可静默降级** | A2 门 `--samples` 默认 **10**，而验收判据是 **N≥20**；按默认复现即产出不达标证据并**原地覆盖**仓内 PASS 证据 |
| U12 | **RTL 检视为作者自审** | `F6-RTL-CR-…md` 署名「陈正共（作者检视）」，RTL 亦其所写；无独立评审人 |
| U13 | **签核倒置** | `QA_VP: PENDING`、`PRESIDENT: PENDING`，但总裁一页 7 个 `[x]` 已全打、裁决页「执行回执」已写 PASS |
| U14 | **换器件方案与现有架构不兼容，未评估** | S2 首选 ECP5。**ECP5 无硬核 ARM** → 现有 R-A/R-B 的「fc\* 在 PS」架构在 ECP5 上直接作废（要么上软核性能更差，要么 fc 全上 PL 资源更不够）。S2 文档对此**一字未提** |

### 3.3 偷换概念 / 过度宣称（点名，按严重度排序）

#### ① 【最严重】「FPGA 整网跑通」实为「ARM 跑整网、FPGA 跑激活函数」

裁决 F4 原文：「**FPGA** 加速和 **FPGA** 整网都要跑通」。
计划文把 R-B「跑通」定义改写为：「分类这趟活 **整段都在板子侧完成**」——把 **FPGA** 偷换成 **板子（含 Zynq 的 ARM PS）**。

`scripts/phase4_fpga_rb_fullnet_runthrough_board.py` 实际分工：

```python
def linear(x, w, b):                 # ← 全连接层，numpy，跑在 ARM PS
    acc = w.astype(np.int64) @ x.astype(np.int64)
    return (acc >> FRAC) + b
...
    spk, mem1[j] = lif_pl(...)       # ← PL 只做 LIF 激活
```

**算力占比（按证据反算，timesteps=25, hidden=256, out=10）**：

| 位置 | 每样本算术量 | 占比 |
|------|-------------|------|
| **PS（ARM）**：fc1 784×256 + fc2 256×10，×25 步 | **5,081,600 MAC** | **99.87%** |
| **PL（FPGA）**：266 神经元 × 25 步 | **6,650 LIF step** | **0.13%** |

> 即：总裁批的是「FPGA 跑整网」，交付的是 **FPGA 承担 0.13% 算力**的方案，且这 0.13% 消耗了 67% 的墙钟时间（`lif_pl_ms 19528 / wall_ms 29000`）。
> **「R-B 整网跑通 ✅」是不成立的宣称。** 正确写法：**「Zynq 板内整网跑通；FPGA 逻辑承担 LIF 激活（占算术量 0.13%），全连接层在 ARM 上」。**

#### ② 【严重】「加速跑通」的实际效果是**减速 290 倍**

| 路径 | 每样本 | 相对 Atlas 整网（p50 3.5 ms） |
|------|--------|------------------------------|
| Atlas 整网基线（#13） | 3.5 ms | 1× |
| **R-A A2「加速」** | 1016.7 ms | **慢 290×** |
| **R-B 整网** | 1450.0 ms | **慢 414×** |

单次 LIF step 在 PL 上耗 **146.8 µs**（976.4 ms / 6650 次），而 RTL 只需 3 拍 @100 MHz = **30 ns** —— **有效占空比 0.02%**，其余 99.98% 是 MMIO 轮询与 Python 开销。

「加速」一词在 F4 中是**功能名**（R-A 路线名），但一页与 QA 记录把它当**结论**用：「R-A 加速跑通 ✅」。
QA 记录只写「远逊 G-LAT」，**没写这条路径相对无 FPGA 基线是负加速**。这是关键信息的选择性省略。
**正确写法：「R-A 卸载路径功能连通；性能为负增益（290× 减速），不构成加速。」**

#### ③ 【严重】F6「全链路可控」被降级为「验证链可控」，无书面授权

- 裁决页 F6 行：「安全可控优先；**目标全链路可控**；Vivado=质量验证/快验后端」。签字原文只有「安全可控优先…Vivado 可作为质量验证与快速验证工具」。
- 计划文 `2026-07-28-fpga-sovereign-toolchain.md` 自行写入：「『全链路可控』分阶段：**先验证链可控**，再评估换开源友好器件」，并把 S0 命名为「**验证链可控（本里程碑必达）**」。

**总裁从未勾选「同意分阶段」**。裁决页 F6 没有这一行。这是**执行方单方面重定义验收范围**（G8 失败）。
后果直观：S0/S1/S2 三个里程碑在一页上全打 `[x]`，读者会得到「F6 已办结」的印象，而 F6 的字面目标（全链路可控）完成度为 0。

#### ④ 「开源链 A–G PASS」的载体是一个 32 位 LFSR

`FPGA_开发流程与工具一览_V0.md` §3.1 表格给出「A✅ B— C✅ D✅ E✅ F✅ G✅」一整列绿。
该列的实际设计 `fpga/openxc7_try/blinky_z2_soft_ps7.v` 全文 23 行：

```verilog
(* keep *) PS7 ps7_i ( .FCLKCLK(w_fclk_unused) );   // ← PS7 只是保留桩，无 AXI、无 PS-PL 交互
reg [31:0] r_s = 32'h1;
always @(posedge clk) r_s <= {r_s[30:0], r_s[31]^r_s[21]^r_s[1]^r_s[0]};
```

**零 CARRY4、零 DSP、零 BRAM、零 AXI、零 PS-PL 接口，综合后 Estimated LCs = 1。**
把这一列与交付核并排放进同一张进展矩阵，读者会拼出「开源链基本通了，就差 LIF」——
真实情况是：**开源链通过的是一个不含任何算术的点灯电路，与交付核之间隔着 CARRY4 与 CE 通道两处独立缺陷**（执行方自己的 `lif_probe` 已证）。
表里的 ⚠/❌ 是标了，但**矩阵的形状本身在误导**。这是我要求废掉 A–H 矩阵作为汇报视角的主要原因。

#### ⑤ 「S2 迁移评估落盘 ✅」—— 门禁当前实跑为红

`docs/FPGA_S2_开源友好器件迁移评估_V0.md` 自身第 5 行状态写「**未**板上加载」，而同文档 §2 表格写「板上加载 **PASS**」——**同一文档内部自相矛盾**（修订后未同步表头）。
更硬的问题见 §5-E：该门本轮实跑 **exit 1**，仓内 `pass:true` 的证据 JSON 是 2026-07-28 的**陈旧快照**，文档改动后从未复跑。

#### ⑥ 「A2 PASS（N=20）」与当前工作区证据矛盾

裁决页执行回执：「R-A A2：Atlas↔PYNQ M-lif **PASS（N=20**，pred 一致 100%）」。
当前工作区 `fpga_ra_atlas_mlif_inchain_gate.json`：**n=10, acc=0.9**（已提交版本为 n=20）。
**若这次改动被提交，总裁页面立即变成假陈述**，且执行方自己的证据门会红（§5-D 实证）。

---

## 4. 方案完备性质疑：执行方流程表缺什么、错什么

### 4.1 结构性错误（不是漏项，是选错了坐标系）

| # | 质疑 | 说明 |
|---|------|------|
| Q1 | **A–H 是工具流水线，不是交付链** | 缺 L1 需求规格、L8 发布交付、L9 运维变更三个整段。目标说的是「开发**到交付**」，表里没有「交付」这个格子 |
| Q2 | **进展矩阵把不可比的东西并列** | 点灯 LFSR 与 `lif_step_axi_lite` 同表打勾，制造「差不多都通了」的错觉 |
| Q3 | **「可控」被窄化成「工具是否开源」** | F6 第一位是**安全**。仓内把安全可控 ≈ 开源工具链，于是硬编码口令、无威胁模型、无位流完整性这些**真正的安全可控缺陷一个都没进表** |
| Q4 | **没有失败判据，只有完成判据** | 全表是「做了什么」，没有「什么情况下判本方案不可行」。换器件触发条件写成「硬主权要求 + 合理工期」——`合理工期` 不可机械判定，等于永不触发 |

### 4.2 具体缺项（目标需要而方案未覆盖）

| # | 缺什么 | 为什么目标需要 | 最小完成定义 |
|---|--------|---------------|-------------|
| M1 | **约束进仓（XDC/SDC）** | 无约束 = 无时序主权，且 379 LUT 与并行墙结论失去依据 | `fpga/constraints/lif_step_axi_lite.xdc`（`create_clock` + IO），两条实现链都引用；`report_timing_summary` 的 WNS 为实数且 ≥0 |
| M2 | **门级仿真（post-synth）** | 综合是可控链的一环，无门仿则综合器错误无门可挡 | Yosys `write_verilog` 网表 + 与前仿同激励，`mismatches=0` |
| M3 | **后仿或书面降级** | 时序相关缺陷只有后仿/STA 能挡 | 开源侧做不到就写**降级理由 + 替代判据**（如板上时序余量回归门），不留空 |
| M4 | **独立 lint 门** | `-Wall` 嵌在仿真构建里，warning 不产生判据 | `N-CI-LINT` 进 baseline，`--lint-only` 非 0 即挡 |
| M5 | **金标独立化 + 随机差分 + 边界用例** | 现 golden 与 RTL 同源同错（U4） | TB 引用 `FixedPointLIF` 的输出向量；≥10⁵ 随机 + 溢出边界；把安全数值域写成**可检契约** |
| M6 | **溢出契约与断言** | `prod[47:16]` 无饱和，RTL 32 位回绕 vs 金标无界（§5-C 实测全域 22.3% 分歧） | 文档写死「保证域 \|mem\|,\|cur\| ≤ X」，仿真加断言，超域即红 |
| M7 | **供应链清单（S-b/S-c/S-d）** | 「可审计可复现」的字面要求 | `third_party.lock`：每个工具的 repo+commit+build flags+产物 sha256；`chipdb`/`prjxray-db` 哈希与许可状态入档 |
| M8 | **许可与法律面** | prjxray-db 是**逆向工程**产物；PS7 是闭源硬核；Vivado 授权条款 | 一页许可评估：各件许可、可否用于交付、有无地域/用途限制 |
| M9 | **威胁模型 + 密钥/口令基线** | F6 第一位是安全，仓内 0 命中 | 一页威胁模型（篡改 bit / 板卡横向移动 / 供应链投毒）；口令移出源码；禁 `StrictHostKeyChecking=no` |
| M10 | **位流完整性门** | 交付物是 4 MB 二进制，无哈希无来源 | `phase4_fpga_vivado_bit_gate.py`：校验 bit 的 sha256、来源 tcl 与源码 commit 绑定；Vivado tcl 去掉 `catch{}` 静默吞错（现在失败也 `exit 0`） |
| M11 | **CI 范围与工具钉版** | U9/U10 | 所有验收门进 baseline；CI 用固定版本 verilator/yosys（容器或 apt pin） |
| M12 | **证据不可覆盖** | U11 | 证据落 `runs/<run-id>/`，仓内 JSON 为符号链接或索引；门禁默认参数 = 验收阈值（`--samples` 默认改 20） |
| M13 | **换器件判据量化 + 架构反作用** | U14 | 触发条件写成数字（如「P0-a/b 在 N 个工作日内未 exit 0」）；同时给出 ECP5 无 PS 后 fc 层去哪的方案与资源账 |
| M14 | **独立评审与签核顺序** | U12/U13 | RTL-CR 换非作者签；一页 `[x]` 只能在 `QA_VP=PASS` 后打 |
| M15 | **交付物定义** | L8 全缺 | 定义「交付」= 谁在什么机器上、用什么包、跑什么命令、得到什么判据；产出 tag + SBOM + 复现包 |

---

## 5. 证据抽检（本轮实跑，命令 → 结果）

> 全部在 `/home/cx/neuromorphic-computing` 下、2026-07-30 执行。

### A. 主信任根确实有效（正面）

```bash
$ python3 scripts/phase4_fpga_lif_verilator_gate.py --gate
PASS phase4_fpga_lif_verilator_gate
  lif_step: PASS verilator lif_step n=13 mismatches=0
  lif_step_axi_lite: PASS verilator lif_step_axi_lite spk=1 mem_out=78643
EXIT=0
```

### B. 交付核的 Vivado 报告：**无任何时序约束**

```bash
$ sed -n '130,160p' fpga/bitstreams/lif_step_timing.rpt
    WNS(ns)  TNS(ns) ...
         NA       NA ...
There are no user specified timing constraints.
$ rg -n "no clock" fpga/bitstreams/lif_step_timing.rpt
67: There are 204 register/latch pins with no clock driven by root clock pin: s_axi_aclk (HIGH)
```

→ 被全仓引用的 **379 Slice LUT** 出自这份无约束综合报告；交付 bit 从未做过时序签核。

### C. 主信任根的 golden 不独立（差分实证）

复刻 `lif_step.v` 语义（32 位回绕）与生产金标 `FixedPointLIF.step`（Python 无界整数）做差分：

```
全 32 位输入域随机 100,000 例：分歧 22,320 例（22.3%）
  样例 cur=-1986441000 mem=-284989606 → RTL (spk=1, 2052037390) vs 金标 (spk=0, -2242929906)
工作域 |cur|,|mem| ≤ 8.0 随机 100,000 例：分歧 0 例
```

→ 结论两面：**当前工作域是安全的**；但该安全域 **既未写成契约、也无断言、更不在门禁内**，而 TB 的 C++ golden 复刻了同一截断，**结构上永远发现不了这类差**。

### D. 执行方自己的验收证据门，当前是红的

```bash
$ python3 scripts/phase4_fpga_both_runthrough_evidence_gate.py --gate
FAIL
 - fpga_ra_atlas_mlif_inchain_gate.json: n=10 < 20
EXIT=1

$ rg -n "samples" scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py
60:    ap.add_argument("--samples", type=int, default=10)      # ← 默认 10，验收要求 ≥20
```

→ 默认参数低于验收阈值 + 证据原地覆盖 = **任何人「照文档复现一次」都会把仓内 PASS 证据降级成 FAIL**。

### E. S2 门禁当前是红的，而仓内证据写 `pass:true`

```bash
$ python3 scripts/phase4_fpga_s2_migration_eval_gate.py --gate ; echo EXIT=$?
FAIL phase4_fpga_s2_migration_eval_gate
  missing: 触发条件
EXIT=1

$ rg -c "触发条件" docs/FPGA_S2_开源友好器件迁移评估_V0.md
（0 命中）
$ git show HEAD:docs/phase4_poc_evidence/fpga_s2_migration_eval_gate.json | rg '"pass"'
  "pass": true      # generated_at = 2026-07-28，文档改动后从未复跑
```

（本轮跑完已 `git checkout --` 还原该证据文件，未留污染。）

### F. 供应链主权为零

```bash
$ git ls-files third_party | wc -l
0
$ du -sh third_party/openxc7-try
1.5G
$ rg -il "威胁模型|threat model|SBOM|供应链" docs/ scripts/ | wc -l
0
$ git tag | wc -l
0
```

### G. 安全基线缺陷（口令硬编码）

```bash
$ rg -n "pass.*default" scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py
63:    ap.add_argument("--pynq-pass", default="xilinx")
66:    ap.add_argument("--atlas-pass", default="Mind@123")
$ rg -n "StrictHostKeyChecking=no|sudo -S" scripts/phase4_fpga_*.py | wc -l
5
```

### H. CI 覆盖面

```bash
$ python3 scripts/qa-neuro-baseline-run.py --tier all
✓ N-CI-SYNTAX  ✗ N-CI-SMOKE(ModuleNotFoundError: torch)  ✓ N-CI-SHELL
✓ N-CI-DOCS    ✓ N-CI-VERILATOR   ✓ N-CI-YOSYS-S1
✗ N-PRE-MERGE-QA: FAIL VP_QA: PASS not set (await VP signoff)
EXIT=1
```

CI 只挂 6 门，FPGA 占 2 门（前仿、综合）；`.github/workflows/ci.yml:24` 用 `apt-get install -y verilator yosys`，**未钉版本**。

### I. 「FPGA 整网」的 PS/PL 分工（原文）

```python
# scripts/phase4_fpga_rb_fullnet_runthrough_board.py
def linear(x, w, b):                      # fc1/fc2 全部在 ARM PS
    acc = w.astype(np.int64) @ x.astype(np.int64)
for j in range(hidden):                   # PL 只做 LIF
    spk, mem1[j] = lif_pl(int(cur1[j]), int(mem1[j]))
```

配合证据 `n_lif_pl_calls=133000`（20 样本 → 6650/样本 = 266×25 步）反算得 §3.3-① 的 0.13%。

---

## 6. 裁决建议（给总裁 / PL）

### 6.1 现在**可以**宣称

1. **F6-S0 部分成立**：开源前仿门（Verilator）已进 CI 且真会红；RTL 人工检视清单已落盘。**这是实的**。
2. **平台功能连通性成立**：Atlas↔PYNQ（A2）与板内整网（B1）功能一致率 100%、标签准确率 95%，可复现。
3. **开源实现链的断点已定位到最小复现**：`lif_step` 真实送 P&R 失败于布线（CARRY4 + CE 通道两处独立缺陷）。**这份否定证据质量高，应予肯定**。
4. **平台可行性闸门的「不通」侧结论成立**：Z2 上 256 核并行 LIF 不可行（方向正确，但定量依据需按 M1 重做）。

### 6.2 现在**不能**宣称（建议总裁不接受以下任一说法）

| 不得宣称 | 理由 |
|----------|------|
| 「FPGA 整网跑通」 | 实为 ARM 承担 99.87% 算力；应改「Zynq 板内整网跑通，FPGA 承担 LIF 激活」 |
| 「FPGA 加速跑通」 | 相对无 FPGA 基线为 **290× 负加速**；应改「卸载路径功能连通，性能负增益」 |
| 「F6 全链路可控已推进到 S2」 | F6 的「全链路」从未获准降级为「验证链」；S0/S1/S2 的 `[x]` 不等于 F6 完成度 |
| 「开源链 A–G 已通」 | 通的是 1 LC 的 LFSR 点灯，交付核 0 通过 |
| 「S2 迁移评估已落盘（绿）」 | 该门本轮实跑 exit 1；仓内 `pass:true` 是陈旧快照 |
| 「硬件逻辑质量已保证」 | 无 lint 门、无门仿、无后仿、无时序约束、金标不独立、检视为作者自审 |
| 「安全可控已满足」 | 威胁模型 0、SBOM 0、口令硬编码、位流无完整性、供应链未入版本控制 |
| 「Phase4.1 可关口」 | `QA_VP=PENDING`、`PRESIDENT=PENDING`；验收证据门当前 exit 1 |

### 6.3 需要总裁**书面裁定**的三件事（不裁定则执行方无法合法推进）

| # | 议题 | 选项 |
|---|------|------|
| **D1** | F6「全链路可控」是否**批准分阶段**（先验证链、后实现链）？ | ☐ 批准分阶段（请写明各阶段截止判据） ☐ 不批准，维持「全链路」为单一验收对象 |
| **D2** | F4「FPGA 整网」是否**接受「ARM 跑 fc + FPGA 跑 LIF」**为跑通形态？ | ☐ 接受（则一页措辞必须改为「Zynq 板内整网」并注明 FPGA 算力占比 0.13%） ☐ 不接受（则 R-B 未跑通，需重开方案） |
| **D3** | 「加速」是否**要求正加速比**？ | ☐ 要求（则 R-A 当前 FAIL，需给出达标路线：批量 MMIO / DMA / 片上调度） ☐ 不要求，仅验功能连通（则一页禁用「加速」二字） |

> **我的建议**：D1 选「不批准」但给明确的阶段里程碑；D2 选「不接受原措辞、接受改写后事实」；D3 选「要求正加速比，另立性能工单」。理由：**降级本身不是问题，降级不留痕才是。**

---

## 7. 下一步（按目标优先级排，不按执行方 P0 表）

> 排序原则：**先止血（虚假绿灯与安全）→ 再补主权硬缺（安全/供应链/约束）→ 最后攻技术断点（开源出 bit）**。
> 执行方 P0 表把「修 openXC7 CARRY 布线」放第一，我**降到第三优先级**——因为它是**最不确定、最可能长期不通**的一项，而 T1/T2 是无论 openXC7 是否修通都必须做、且几天可完成的。

### T0 · 止血（本周，1–2 天）

| # | 动作 | 完成判据 |
|---|------|----------|
| T0-1 | 修正一页与裁决页措辞：「FPGA 整网」→「Zynq 板内整网（FPGA 承担 LIF，占算术量 0.13%）」；「加速跑通」→「卸载路径功能连通（性能负增益 290×）」 | 两份文档 diff 落盘，并附本报告 §3.3 为依据 |
| T0-2 | A2 门 `--samples` 默认改 **20**；证据落 `runs/<run-id>/` 后再软链入仓 | `both_runthrough_evidence_gate --gate` exit 0；重复跑两次 `git status` 只动 run-id 目录 |
| T0-3 | 修复 S2 门（补回 `触发条件` 标记或改门）；把 S2 门与 both-runthrough 门**注册进 baseline** | 两门在 `--tier ci` 输出中出现且 exit 0 |
| T0-4 | 撤回或加注所有「F6 已推进/S2 已落盘」的绿色表述，直至 D1 裁定 | 一页 `[x]` 全部退回 `[ ]` 或标注「待 D1」 |
| T0-5 | 一页 `[x]` 与 `QA_VP=PASS` 绑定：未签不得打勾 | `N-PRE-MERGE-QA` 与文档勾选一致性有脚本可检 |

### T1 · 安全主权（本周，2–3 天）—— **F6 的第一个字**

| # | 动作 | 完成判据 |
|---|------|----------|
| T1-1 | 口令全部移出源码（环境变量/密钥文件），删除 `default="xilinx"`/`"Mind@123"` | `rg 'Mind@123\|default="xilinx"' scripts/` = 0 命中 |
| T1-2 | 去掉 `StrictHostKeyChecking=no`，改 known_hosts 固定；改板卡默认口令 | 门禁脚本仍 exit 0，且 `rg StrictHostKeyChecking=no scripts/` = 0 |
| T1-3 | **威胁模型一页**：位流篡改 / 板卡横向移动 / 供应链投毒 / 逆向数据库法律面 | `docs/FPGA_威胁模型与安全基线_V0.md` 存在且被 `qa-neuro-doc-check` 列为必需文档 |
| T1-4 | 位流完整性门：`.bit` sha256 + 来源 tcl + 源码 commit 三元绑定；Vivado tcl 去掉 `catch{}` 静默吞错 | `phase4_fpga_vivado_bit_gate.py --gate` exit 0；篡改 bit 后 exit 1 |

### T2 · 可复现与工程主权（1–2 周）

| # | 动作 | 完成判据 |
|---|------|----------|
| T2-1 | `third_party.lock`：每件工具 repo+commit+build flags+产物 sha256；chipdb/prjxray-db 哈希与**许可状态**入档 | 干净机器按 lock 重建，产出 bit 与本机 sha256 一致 |
| T2-2 | **约束进仓** `fpga/constraints/lif_step_axi_lite.xdc`，两条实现链共用；重做 util/timing | `report_timing_summary` 的 WNS 为实数且 ≥0；**用新数字重算并行墙结论** |
| T2-3 | 金标独立化：TB 引用 `FixedPointLIF` 向量；加 ≥10⁵ 随机差分与溢出边界；把安全数值域写成契约 + 断言 | 故意改 RTL 的 `prod[47:16]` 为 `[48:17]`，门禁必须变红 |
| T2-4 | 门级仿真门（Yosys 网表 + 同激励）；独立 lint 门进 CI | `N-CI-LINT`、`N-CI-GATESIM` 在 CI 日志出现 |
| T2-5 | CI 工具钉版本（容器或 apt pin），与本机一致 | CI 日志打印 Verilator/Yosys 版本，与 `fpga_s1_impl_chain_gate.json` 记录一致 |
| T2-6 | RTL-CR 换**非作者**签署 | 检视文件署名 ≠ RTL 作者；进 pre_merge 门 |

### T3 · 开源实现链攻坚（并行开，但**不阻塞** T0–T2）

| # | 动作 | 完成判据 |
|---|------|----------|
| T3-1 | P0-a：openXC7 CARRY4 布线（8 位计数器最小复现） | `nextpnr-xilinx` 对 cnt8 exit 0 |
| T3-2 | P0-b：CE（CEUSEDMUX）通道二分定位 + 修复 | `lif_probe(-nocarry -nodsp)` exit 0，并给出 ≤30 行最小复现 |
| T3-3 | P0-c/d：`lif_step` 开源出 bit → 上板 → 与 Vivado 链**同一入链门** | `match_rate=1.0` 且 bit 来源为开源链 |
| T3-4 | **设时限**：T3-1/2 若在 N 个工作日（建议 15）内未 exit 0，自动触发 D-器件评估 | 时限写进计划，到期强制升级，不得无限期「继续迭代」 |

### T4 · 迁移方案补完（与 T3 同步，不等 T3 结果）

| # | 动作 | 完成判据 |
|---|------|----------|
| T4-1 | 补 **ECP5 无硬核 ARM** 的架构反作用分析：fc 层去哪、软核代价、资源账 | S2 文档新增一节并给出数字；否则 ECP5 不得再写「首选」 |
| T4-2 | 换器件触发条件**量化**（工期天数 + 具体 exit 判据），删除「合理工期」 | 触发条件可被脚本判定 |
| T4-3 | 修正 S2 文档表头与 §2 表格的自相矛盾 | 文档内一致 |

### T5 · 交付定义（L8/L9，缺失整段）

| # | 动作 | 完成判据 |
|---|------|----------|
| T5-1 | 定义「交付」：交给谁、交付物清单、第三方复现包与命令 | `docs/FPGA_交付物定义_V0.md` |
| T5-2 | 首个 tag + SBOM | `git tag` ≥1；SBOM 覆盖 requirements.txt + third_party.lock |

---

## 附录 · 本报告对既有评审文档的处置意见

| 文档 | 处置 |
|------|------|
| `FPGA_全链路自主可控_评审_V0.md` | 保留为历史；结论方向对、深度不足（已被 Opus V0 纠错） |
| `FPGA_全链路自主可控_评审_Opus_V0.md` | **技术抽检质量高，予以肯定**（尤其 `lif_probe` 实证、`catch{}` 静默吞错、证据自覆盖三项）。但**坐标系继承自执行方 11 段表**，因此未覆盖：需求/交付/运维三段、安全与供应链主权、「FPGA 整网/加速」的定义偷换、F6 目标降级未授权、S2 门当前为红、ECP5 架构反作用。本报告在其之上做**目标维度**的补齐，二者互补，不冲突 |
| `FPGA_开发流程与工具一览_V0.md` | **建议停用为「汇报唯一视角」**。理由见 §4.1-Q1/Q2：维度不足且矩阵形状本身误导。可保留为工具速查表 |

---

*独立第三方评审 · Opus V0 · 2026-07-30*
*本报告所有量化结论均可由 §5 命令复现；若执行方对任一条有异议，请以复现命令 + exit 反驳，不接受措辞辩护。*
