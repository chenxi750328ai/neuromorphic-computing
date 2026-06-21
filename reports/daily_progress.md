# 类脑计算项目 · 每日进展

## 2026-06-22

- **真 SNN 上板**：`MnistSNNUnrolled` → `model_snn.onnx` → Atlas `mnist_snn.om` AclLite **PASS**（~3–16ms）。  
- **数值对齐**：ORT vs 板端脉冲计数 **bit-exact**（`snn_board_align.json` diff=0）。  
- **PR #5**：已合 main（`fe2ea78`）；问题记录见 `docs/phase4_snn_onboard_log.md`。  
- **Phase4 v0**：工程线 **收工**；剩 TR2/VP 签字。  

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
