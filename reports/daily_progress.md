# 类脑计算项目 · 每日进展

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
