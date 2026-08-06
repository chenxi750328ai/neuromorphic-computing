## 2026-08-06
- **11:40 板待修→并行软件轨**：P5-1 `scripts/phase5_event_loader.py` smoke PASS（MNIST→rate，n=32,T=10）；GWT-0 `gwt0_protocol_gate.py --gate` PASS；分支 `feature/phase5-p5-1-gwt0-parallel`。4.2 上板暂停；STALL 保持；PR#28 仍待人 Approve。

## 2026-08-05
- **10:34 合规重合准备**：required review=1 已开；DEV/TEST IPD gate PASS；自 `402195f` 反回退恢复 F7 入链证据，开重合 PR（待 neuro-ci + 人审 Approve）。
- **09:48 总裁裁定回退**：PR [#22](https://github.com/chenxi750328ai/neuromorphic-computing/pull/22) 因 **TEST 未过先合入** 违反 IPD，已用 [#24](https://github.com/chenxi750328ai/neuromorphic-computing/pull/24) 回退（`908f356`）。F7 实现/证据仍在 `feature/phase4.1-f7-pl-fc`；**测试沟通验收后再合**。补 `neuro-pre-merge-ipd-gate.py` + PR 模板 + [CI/CD 审计](../docs/ops/2026-08-05-质量流程与CICD审计_PR22.md)。缺口：GitHub 无 required review；CI 不读 WO-TEST。Phase8 仍等 F2。
- **09:35 认错**：09:21 合入 / 09:27 TEST 才 PASS；后补不能洗白。

## 2026-08-04
- **19:42 F7 N=20 PASS**：`PASS_f7_pl_fc` · board_match_rate=**1.0** · pl_model=1.0 · acc_vs_label=0.95 · fc_on_pl/lif_on_pl · mac=mmio · wall≈102min。证据 `fpga_rb_fullnet_pl_fc_gate.json`。下一步 WO-DEV 复验/checker。**未代关 Phase4.1**（待 WO+PR）。
- **11:42 自驱唤醒执行**：推送 `feature/phase4.1-fpga-sovereign-s2`（`0e4cdb8`+`0f88064`）并开 **PR [#21](https://github.com/chenxi750328ai/neuromorphic-computing/pull/21)**（openXC7 LIF AXI 入链 G1–G8 + PYNQ 硬件狗）。本地 `goal_verify` 仍 **8/8**。**≠关口关闭**；合 main 待 neuro-ci。
- **11:18 自驱唤醒核盘**：PR [#14](https://github.com/chenxi750328ai/neuromorphic-computing/pull/14) **已合**（FPGA 双路线：R-A 单算子 PL 通 / R-B Z2 并行整网资源墙）。G-LAT [#13](https://github.com/chenxi750328ai/neuromorphic-computing/pull/13) 已合（r2 p50≈3.5ms）。
- **Phase8**：仍等总裁书面解除 F2；默认不开。TR2 VP / US-EN 可选不阻塞。
- **收工**：更新 `docs/每日计划.md` · 本文件 · `vcompany/data/neuromorphic-milestones.json` · wake consume。

## 2026-07-27
- **11:17 G-LAT r2（connection_reuse）**：分支 `feature/phase4.1-g-lat` · 部署/重启 Atlas daemon:9527 · WSL `phase4_distributed_bench.py --daemon-reuse-conn --vs-ort --samples 100` · 门禁 `--gate` **exit 0** → **G-ACC=1.0** · **G-LAT p50=3.501/p95=4.036 PASS** · **G-COMM ok** · **overall_ok=true** · 对照 r1 p50=5.513 → r2 3.501 · 证据 `docs/phase4_poc_evidence/spec_gate_report_daemon_n100_vs_ort_20260727_r2.json` + summary + `g_lat_r1_vs_r2_20260727.md` · **未开 PR**（G-LAT 过≠Phase4.1 关口关闭）。
- **10:48 外部 STDP MD 摄入 + 计划刷新**：读 `neu/docs` 新 MD《无目标函数、无监督条件下：STDP权重优化…》；落盘摄入笔记（部分 DOI 待核）；**不影响 G-LAT**；强化 Phase8 读出+弱引导、首版不做联邦/静默突触。G-LAT 计划补测试用例白话；新建 Phase8 文献刷新计划。下一工程刀仍是 G-LAT 连接复用→r2。

## 2026-07-24
- **15:05 G-LAT Task2 归因 r1**：稳态分段 p50 — preprocess 0.001 · atlas 1.679 · xfer_out 2.959 · **e2e 5.513 FAIL（+0.513ms）**；主因每帧 TCP 连接队列段；bench 代码无 sleep、ORT 单 session；**未做 r2 代码优化** · 证据 `docs/phase4_poc_evidence/g_lat_attribution_20260724_r1.md` · **未开 PR**。
- **14:54 G-LAT r1 复测**：分支 `feature/phase4.1-g-lat` · Atlas 192.168.137.2 ping/ssh OK · daemon TCP **9527** · WSL `phase4_distributed_bench.py` N=100 `--vs-ort` · 门禁 `phase4_spec_gate_report.py --gate` → **G-ACC=1.0** · **G-LAT p50=5.513/p95=9.339 FAIL** · **G-COMM ok** · **overall_ok=false** · 证据 `docs/phase4_poc_evidence/spec_gate_report_daemon_n100_vs_ort_20260724_r1.json` + `distributed_bench_daemon_n100_vs_ort_20260724_r1_summary.json` · **未开 PR** · 下一 **Task 2**。
- **14:52 纪律+G-LAT 计划**：澄清 PR#12≠门禁过关；`CONTRIBUTING.md` 增「计划先行（分支/PR）」；落盘 `docs/plans/2026-07-24-phase41-g-lat.md`（预定分支 `feature/phase4.1-g-lat`、拟 PR 标题、gstack 自评有条件 GO）；**未临时开 PR**。下一步按计划 Task 0–1 复测。
- **14:42 总裁勾选 §8/§10 + 合 PR#12**：Cursor 明示「同意 8 10，继续吧」→ 技术报告 R1–R5、B1–B3 全数按建议勾选并落盘签字；正文纠偏 E4（单步 LIF 上 PL 已做，勿再写未做）；TR2 总裁知情；PR [#12](https://github.com/chenxi750328ai/neuromorphic-computing/pull/12) **MERGED**（`743ecbc`）；milestones G0=PASS · phase4.1→90%；解除 `pause_agent_wake`。下一断点：**G-LAT**（daemon p50 略超 5ms）。**未写 Phase4 了结**。
- **10:19 BON 评审回收 · 统一修订**：两路 Opus 独立评审完成——业务内容评审判定「部分站得住脚」（process 纪律强、独立业务判断薄弱）；系统设计评审判定「方向对但需细化」（§2/§6 停留文献综述层，非可执行规格）。**已按两份评审做一次统一修订**（非分两次改）：`requirements_v2.md` 新增 §3.3 价值假设 V-H1/V-H2 + 止损判据 K1–K3、§4 修正商业化措辞尾巴 + 正面承认稀释效应、§5 场景优先级排序（标注"写PPT"与本项目 US-SL 结论矛盾，不推荐）、§6 新增优先级正面回答（Phase4.1 优先于本评审注意力）、§7 新增 G6；`NEURO-V1-架构设计说明书.md` 重画 §2.4 与 §1.4 自相矛盾的三轨合并示意图、新增 §2.5 落地绑定规格（拓扑绑定/tick↔ms映射/Δw量化/无监督读出打分）、§4 新增单人研发约束风险 + §4.1 单人可行性与 FPGA 资源预算（路径收窄决策）、§6 补验证契约（command+evidence+阈值）+ 3 道新增门禁（STDP收敛门/弱引导ablation门/RTL≡golden等价门）；`TR1v2` 新增 §7 BON 评审记录摘要 + C6 勾选项。三份文档均已留修订记录，评审过程未被跳过，可供总裁核对。
- **09:45 目标/系统设计刷新 · 重开 TR1v2**：总裁提供 3 份行业研究报告（赫布理论溯源、类脑技术路线/EDA 选型、技术难点攻坚），结合 Phase1–4.1 进展落盘三份文档：`NEURO-V1-架构设计说明书.md`（补齐此前缺失的系统设计真源，Phase8 候选架构=STDP+稳态可塑性+弱引导种群进化）、`requirements_v2.md`（目标刷新草案，**不改** v1 已拍板决议）、`TR1v2_技术路线深化评审_总裁评审.md`（**不推翻**原 TR1，**不改**Phase4.1 §8/§10/PR#12/TR2 人签断点，二者并行）。同步更新 GWT 文档 §4.6、README、项目看板链接。**纪律确认**：Stage B「更差/种子敏感」未改写；Phase8 未派工；报告理论推导数字（100代/周等）不作本项目验收指标。
- **09:09 自驱唤醒核盘**：相对 09:04 **无变化**（人签 ☐×21 / PR#12 OPEN·MERGEABLE / 陈东 growth 7d 未过）。`pause_agent_wake=true`。机尽 · 不代签不合 · wake consume。
- **09:06 整理+保存记忆**：近期记忆 / MEMORY / 恢复记忆落盘（agentfuture + 类脑仓）；日流水 `agentfuture/memory/2026-07-24.md`。
- **09:04 自驱唤醒核盘**：相对 07-23 **无变化**。技术报告 §8/§10 ☐×21；TR2 VP/总裁 ☐；PR [#12](https://github.com/chenxi750328ai/neuromorphic-computing/pull/12) OPEN·MERGEABLE·qa SUCCESS。陈东 ep=11 · growth 活跃日 3→**7d 未过**。**未代签、未合 PR**；未写「Phase4 了结」。机尽 · wake consume。

## 2026-07-23
- **15:31 自驱唤醒**：人签仍无变化。修小脑：① 标题含「等人/待人」不进 Agent wake；② `pause_agent_wake=true`（等人签期间整段不唤醒，解锁改 false）；③ `min_wake_interval_sec=7200`。收工 consume。
- **15:12 自驱唤醒核盘**：相对 15:08 **无变化**（人签 ☐ / PR#12 OPEN·MERGEABLE / 陈东 growth 7d 未过）。机尽 · 不代签不合 · wake consume。
- **15:08 自驱唤醒核盘**：P0 仍全为人签——§8/§10 ☐×21；TR2 VP/总裁 ☐；PR [#12](https://github.com/chenxi750328ai/neuromorphic-computing/pull/12) OPEN·MERGEABLE·qa SUCCESS。**未代签、未合 PR**。陈东 ep=11 · growth 活跃日仍 3→**7d 未过**。headline 未写了结。wake consume。
- **15:03 整理+保存记忆**：近期记忆/MEMORY/恢复记忆落盘。
- **14:35 看板对齐修复**：根因① 18766 `/data/neuro*` 读 integration 陈旧副本（无 Stage B/US）；② md-viewer 依赖 jsDelivr 超时「打不开」。已改 serve 转发 `VCOMPANY_DATA_ROOT`、本地 `vendor/marked.min.js`、看板增 Stage B×4 + 七件套进度表、Wave-1 ASCII 链 `Phase4.1_Wave1_progress_20260723.md`。
- **14:13 自驱唤醒核盘**：P0 全为人签——技术报告 §8/§10 勾选框仍 ☐（约 21 个未勾）；TR2 §8 VP/总裁栏仍 ☐；PR [#12](https://github.com/chenxi750328ai/neuromorphic-computing/pull/12) OPEN·MERGEABLE·qa SUCCESS。**未代签、未合 PR**。P1 陈东 SYS-M2：`learning-episodes.jsonl` **11** 条（≥10）· 活跃日仅 `06-23/07-14/07-22` → **growth 7d 未过**。纪律：禁止单点过关；未写「Phase4 已了结」。wake consume。
- **13:26 自驱唤醒核盘**：复读 Wave-1；Stage B×4 与 E4 证据在盘（`fpga_toolchain_gate.json` `chain_full_pl_ok=true` · `fpga_lif_pl_run.json` `golden_match=true` · bit/hwh/utilization 齐）。PR [#12](https://github.com/chenxi750328ai/neuromorphic-computing/pull/12) 仍 OPEN·MERGEABLE·neuro-ci SUCCESS。**未代签 §8/§10、未合 PR、未代签 TR2**；US-EN 仍等人裁定。focus 改为人签断点；E4/SYS-M5 移出 backlog。wake 已 consume。
- **E4 闭环（总裁授权）**：Vivado 2023.2 综合 `write_lif_bitstream.tcl` → `fpga/bitstreams/lif_step_overlay.{bit,hwh}`；PYNQ 烧 PL，脉冲序列 `[0,0,1,0,0,1,1,0,0,1]` **≡ golden**；`chain_full_pl_ok=true`。
- **进展报告**：[`docs/Phase4.1_Wave1_进展报告_20260723.md`](../docs/Phase4.1_Wave1_进展报告_20260723.md)——Stage B×4 **不依赖** FPGA；路径 B/E4 **依赖**并已用实测定稿。
- **设计文档刷新**：优势阶梯 §3.1、技术报告路径 B、`phase4_fpga_toolchain_V0.md`、milestones、看板 sync。
- **纪律**：未写「Phase4/愿景了结」；人签（§8/§10、PR#12、TR2）仍待。

## 2026-07-15
- **09:30 唤醒**：核盘无变化——无 Vivado、无 AMD `.bin`；P0 人签/合 PR#12 仍待人。

- **09:12 唤醒**：E4 仍断在 **AMD 官网账号/安装包**（我侧无密码）；脚本与 AXI/TCL 已就绪。PR #12 待人合；§8/§10、TR2 待人签。陈东 ep=10，SYS-M2 的 7 日稳定未验。

# 类脑计算项目 · 每日进展

## 2026-07-14
- **21:28 继续**：E4 仍卡 AMD 包；补 `lif_step_axi_lite.v` + 一键 Vivado TCL；陈东 LearnCycle×5 → **episodes=10**（SYS-M2 数量门槛过，7 日稳定未验）。
- **20:58 Vivado 安装**：WSL `/tools/Xilinx` 与安装脚本已就位；**AMD 官网包需登录下载**，盘上无现成 `.bin`。等 `XILINX_EMAIL`/`XILINX_PASSWORD` 或把 Unified Lin64.bin 丢到 `~/Downloads/xilinx-install/`。
- **18:34 唤醒**：全盘 Vivado 仍无；FPGA `chain_full_pl_ok=false`；Atlas/PYNQ ping 通；PR #12 OPEN qa SUCCESS。E4 等人给 Vivado 路径或批准安装。

- **自驱唤醒**：核盘 P0 — **FPGA 路径 B PR #7 早已合 main**（看板 focus 已改，不再当作待办）。  
- **技术报告**：补齐 [§10 Phase4.1 立项 B1–B3](../docs/Phase4_技术报告_总裁评审.md) + §8 增 R5；**未代总裁签字**。  
- **PR #12**：规格门禁报告 · neuro-ci **绿** · 待人合 — https://github.com/chenxi750328ai/neuromorphic-computing/pull/12  
- **阻塞**：Atlas `192.168.137.2` / PYNQ `192.168.137.3` ping 不通 → E2–E4 补数挂起。  
- **TR2**：PL 栏已签；VP/总裁栏仍空。  
- **纪律**：Phase4.1 未完成前不写「Phase4 已了结」。  
- **17:16 再唤醒**：P0 仍卡人签 + 合 PR#12 + 以太网；本轮无新代码。Agent 聊天请用英文链 [Phase4_president_tech_report.md](/home/cx/neuromorphic-computing/docs/Phase4_president_tech_report.md)。  
- **18:21 网通续作**：Atlas/PYNQ ping+ssh 通；`phase4_distributed_bench.py --daemon-port 9527 --vs-ort --samples 100` → `distributed_bench_daemon_n100_vs_ort.json`；**ort_match_rate=1.0**；规格门禁 overall **FAIL**（G-LAT p50 5.06>5.0；G-ACC/G-COMM 过）。E2：`comm_matrix_daemon_tcp_n100.json`。E4 未做（点灯≠上 PL）。

## 2026-06-22

- **真 SNN 上板**：`MnistSNNUnrolled` → `model_snn.onnx` → Atlas `mnist_snn.om` AclLite **PASS**（~3–16ms）。  
- **数值对齐**：ORT vs 板端脉冲计数 **bit-exact**（`snn_board_align.json` diff=0）。  
- **PR #5**：已合 main（`fe2ea78`）；问题记录见 `docs/phase4_snn_onboard_log.md`。  
- **FPGA 路径 B v1**：**PR #7 已合 main**（`67c178b`）。  
- **Phase4 技术报告**：[docs/Phase4_技术报告_总裁评审.md](../docs/Phase4_技术报告_总裁评审.md) — **待总裁 §8/§10 评审**。  
- **Phase4 v0**：单点 PoC 工程收工；**关口未关**（Phase4.1）。  

## 2026-06-22（早期）

- **总裁**：批准 IPD/QA 研究轨裁剪（`PRESIDENT: APPROVED`，批注 test）。  
- **VP**：陈小五 5 点全同意；**CI 不裁剪**；signoff 仍待 `VP_QA: PASS`。  
- **PR #2**：已合并 main（IPD/QA 文档 + Phase3 + `neuro-ci` 绿）。  
- **自驱**：类脑仓自有 hook/loop 脚本；`neuro-drive-loop.sh` 已切本仓。  
- **M4-2 实测**：S1 eval-only **96.97% PASS**（`runs/20260608T090726Z`）；SNN 直导 ONNX 失败（缺 onnx 包 / LIF 算子）；已加 `phase4_export_ann_surrogate.py` 兜底路径。  
- **小脑修复**：`stale_wake_sec=3600` 过期刷新；`neuro-consume-wake.py` 收工消费；loop 日志带时间戳。  
- **分支**：`feature/phase4-tr2-prep`（`main` @ PR #2）。  
- **下一步**：M4-2 导出留档 → M4-3 Atlas 冒烟。  

## 2026-06-06

- **增强实验**：`train_mnist_fewshot_aug.py`；5-shot 从 66.84% → **69.70%**。  
- **CDT 栈对齐**：`cdt_v1_stack_alignment.md`。  
- **GitHub**：已恢复 push。

## 2026-06-05

- **Phase3 SNN**：5-shot 微调 **89.23%**、10-shot **92.98%**。  
- **对照**：ANN 5-shot 微调 **96.32%**。  
- **看板**：Phase3 专块；燃尽 Phase3 done。

## 2026-06-04

- **Phase3 ANN**：小样本脚本 + 全量微调实验；`phase3_fewshot_results.md`。  
- **看板/燃尽**同步 Phase2。

## 2026-05-30

- **Phase2**：`train_mnist_ann.py` + `run_phase2.sh`；4090 首跑 **test acc 98.10%**（36s，10 epoch）。  
- **对比**：`docs/phase2_snn_vs_ann.md`（SNN 96.97% vs ANN 98.10%）。  
- **分支**：`feature/phase2-ann-baseline` 本地提交 e56e1b0，PR 待合并 `main`。  
- **自驱**：项目级 hook + `neuro-drive-loop.sh`；看板文档经 vcompany 18766 代理 `/docs/neuromorphic-computing/`。

## 2026-05-29

- **计划**：每日计划文档 `docs/每日计划.md`；看板增加「计划+完成」分栏、Phase1 训练说明。  
- **说明**：96.97% = 10 epoch **全部跑完**后的测试集准确率，不是没跑完。  
- **待办**：Phase2 ANN 脚本（计划 05-30）。

## 2026-05-28

- **TR1**：总裁拍板通过（纪要 `docs/会议纪要_TR1总裁拍板_20260528.md`）。  
- **Git**：独立仓 https://github.com/chenxi750328ai/neuromorphic-computing 首提 `957f6f2`。  
- **看板**：TR1 可勾选、CDT UTF-8 阅读页。  
- **待办**：Phase 2 ANN 基线；飞书 Webhook。

## 2026-05-27

- **Phase 1 首跑**：`train_mnist_snn.py` 10 epoch，**test acc 96.97%**（4090），输出 `runs/20260527T092534Z/metrics.json`。  
- **交付**：`scripts/run_phase1.sh`（venv + 训练一键）。  
- **看板**：http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html  
- **待办**：Git 策略确认后首次提交（message 含陈正共）；Phase 2 ANN 对照。

## 2026-05-13

- **评审**：已建 TR1 网页看板与材料清单。  
- **需求**：v1 已起草（MNIST + Phase1 SNN 仿真）。

---

## 2026-04-12

- **资料**：已建立项目目录 `neuromorphic-computing`；README 中列出 SNN 工具链、小样本/自学习、能效与多硬件方向关键词。  
- **需求**：`docs/requirements_v0.md` 对齐「训练 + 推理 + 小样本 + 自学习 + 低能耗」，部署不限定场景；工业场景为可选验收。  
- **自动化**：`scripts/daily_progress_report.py` 配置飞书 Webhook 后可定时推送本文件摘要。  
- **明日计划**：收敛 v1 基准任务与开放问题；补充 3～5 篇核心论文/文档链接到本段。

---

（以下按日期追加新小节，或编辑「当日」块后运行日报脚本。）
