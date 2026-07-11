# GWT-MVP · 测试方案 V0

> **测试对象**：Phase6 GWT-MVP 4090 仿真（workspace 总线 + M1–M4 stub）  
> **作者**：陈正齐（ag-chenzhengqi）  
> **关联工单**：WO-TEST-NEURO-GWT-MVP-01 · 依赖 WO-DEV-NEURO-GWT-MVP-01  
> **设计真源**：`docs/GWT_愿景与阶段依赖_V1.md` §4.4 · `docs/GWT_工作区协议_V0.md`  
> **配套**：[GWT_MVP_测试用例_V0.md](./GWT_MVP_测试用例_V0.md)  
> **CHECKLIST**：`vcompany/data/role-standards/checklists/test-v1.json`

---

## 1. 文档信息

| 项 | 内容 |
|----|------|
| 测试对象 | GWT-1 / GWT-2（Phase6 · 4090 仿真） |
| 版本 | V0 |
| 作者 | 陈正齐（ag-chenzhengqi） |
| 关联工单 | WO-TEST-NEURO-GWT-MVP-01 |
| 开发设计引用 | `scripts/gwt_workspace.py` · `scripts/gwt/modules/` · `scripts/gwt_mvp_exam.py` |
| DEV 基线 | `feature/neuro-gwt-mvp` · commit `d91c30c` |

---

## 2. 业界测试规范 CHECKLIST（必填）

| 规范 ID | 处置 | 证据章节 | 理由 | 评审确认 |
|---------|------|----------|------|----------|
| Q-TST-001 | 适用（方案落盘） | §1–§7 | 本文件即方案交付 | 待 REV |
| Q-TST-002 | 适用（用例落盘） | 配套用例 V0 | TC-GWT-* 已映射 verifyId | 待 REV |
| Q-TST-003 | **机械 exec 探针** | §4.2 · §6 | neuro 仓以 **pytest + exam gate** 替代 `m0-test-exec-gate`；命令与 WO `verification[]` 一字不差 | 待 checker |
| TST-TRACE-01 | 适用 | 用例 §3 | 每条 P0 含 OR/FT/SR/AR-Ref | 待 REV |
| TST-LIVE-01 | **反作弊 lint** | §6.3 | `wo-verify-command-lint.py --gate`；禁止 `test -f` / `; true` 代 PASS | 待 checker |
| TST-FAIL-01 | N/A（MVP stub） | — | 无 forbidden 负路径门禁；GWT-3/硬件不在本 WO | — |

---

## 3. 测试范围与目标

### 3.1 在范围内

| 范围 | 说明 |
|------|------|
| GWT-1 | M1 → workspace → M4 单向 1 tick（`gwt_mvp_exam.py --stage 1`） |
| GWT-2 | M1–M4 竞争写 · 广播读 · T≥8 global tick（`--stage 2 --gate`） |
| Workspace 总线 | K/D/k_active 默认、merge top-k、snapshot 深拷贝 |
| 模块 stub | M1 感知 · M2 关联 · M3 执行 · M4 输出 |
| pytest 单测 | `tests/test_gwt_workspace.py` · `tests/test_gwt_modules.py` |
| Q-TST-003 exec | WO `GWT-TST-01` pytest 命令机械复跑 |
| TST-LIVE-01 | WO `GWT-TST-03` verification 反作弊 lint |

### 3.2 在范围外

| 排除项 | 理由 |
|--------|------|
| Phase4.1 / Atlas / FPGA / PYNQ | 本 WO pathScope 仅仿真文档与 pytest |
| GWT-3 陈东 CL 探针 | 依赖 GWT-2 + CL-1，另开 WO |
| Phase7 异构 payload 跨板 | 协议 §5 仅登记，不测 daemon 链 |
| 硬件能效 / 墙插 | Phase8 能力 |
| MNIST SNN 25-tick 单体 | 非 GWT workspace 架构（愿景 §1.3） |

### 3.3 测试目标（可衡量）

| ID | 目标 | PASS 信号 |
|----|------|-----------|
| GWT-1 | 1 tick 感知→工作区→输出管线可跑 | `gwt_mvp_exam.py --stage 1 --gate` exit 0 |
| GWT-2 | 8 tick 四模块竞争写且 M1–M4 均有写日志 | `--stage 2 --gate --workspace-doc docs/GWT_工作区协议_V0.md` exit 0 |
| Q-TST-003 | 每条 P0 用例有 shell/pytest 命令 | `GWT-TST-01` pytest exit 0 |
| TST-LIVE-01 | WO verification 无作弊命令 | `GWT-TST-03` lint exit 0 |

---

## 4. 测试策略

| 层级 | 策略 | 工具/环境 | 负责人 |
|------|------|-----------|--------|
| AR · 单元 | workspace merge / snapshot / 模块 local_step | pytest | 陈正齐 |
| SR · 集成 | stage1 管线 · 8 tick global_tick | pytest + exam | 陈正齐 |
| FT · 特性 | GWT-1 / GWT-2 端到端 exam gate | `gwt_mvp_exam.py` | 陈正齐 |
| 工单验收 | WO verification 三件套 | checker `wo-verify` | vc-wo-checker |

### 4.1 GWT-1 / GWT-2 验收链

```text
GWT-0 协议 doc ──► DEV 实现 (d91c30c)
                      │
         ┌────────────┼────────────┐
         ▼            ▼            ▼
    pytest AR    exam stage1   exam stage2
    (GWT-TST-01)  (DEV GWT-DEV-01) (GWT-TST-02 / GWT-DEV-02)
```

### 4.2 Q-TST-003 exec 探针（neuro 仓适配）

M0 栈使用 `m0-test-exec-gate.py`；**本 WO 不适用**。exec 探针真源：

```bash
cd /home/cx/neuromorphic-computing && python3 -m pytest tests/test_gwt_workspace.py tests/test_gwt_modules.py -q --tb=short
```

对应 WO `GWT-TST-01`；报告登记于 `vcompany/data/reports/neuro-gwt-mvp-test-report.json`。

---

## 5. 测试环境与数据

| 环境 | 用途 | 依赖 | 真源 |
|------|------|------|------|
| WSL2 · Python 3 | pytest / exam | numpy | `neuromorphic-computing` 仓 |
| 4090 仿真（逻辑） | global tick 算子 | 无 GPU 硬依赖 | MVP stub 纯 CPU |
| 固定随机种子 | exam stage2 可复现 | seed=7（exam 内） | `gwt_mvp_exam.py` |
| 工作区协议 doc | stage2 前置检查 | 文件存在 | `docs/GWT_工作区协议_V0.md` |

---

## 6. 进入/退出准则

| 阶段 | 进入条件 | 退出条件 |
|------|----------|----------|
| 方案评审 | DEV WO `GWT-DEV-01~04` 全绿 | 本方案 V0 落盘 |
| 用例评审 | 方案 V0 评审通过 | 用例 V0 落盘 · TC 映射 verifyId |
| 执行 | checker 派发 exec 节点 | `GWT-TST-01~02` exit 0 · report 填 verdict |
| 报告 | 执行完成 | `neuro-gwt-mvp-test-report.json` overallVerdict=PASS/FAIL |
| 关单 | report PASS + checker verify | `WO-TEST-NEURO-GWT-MVP-01` done |

### 6.1 WO verification 命令表（checker 真源）

| verifyId | qualityGoalId | command | expect |
|----------|---------------|---------|--------|
| GWT-TST-01 | Q-TST-003 | `cd /home/cx/neuromorphic-computing && python3 -m pytest tests/test_gwt_workspace.py tests/test_gwt_modules.py -q --tb=short` | exit 0 |
| GWT-TST-02 | Q-TST-003 | `cd /home/cx/neuromorphic-computing && python3 scripts/gwt_mvp_exam.py --stage 2 --gate --workspace-doc docs/GWT_工作区协议_V0.md` | exit 0 |
| GWT-TST-03 | TST-LIVE-01 | `python3 scripts/wo-verify-command-lint.py --wo data/work-orders/WO-TEST-NEURO-GWT-MVP-01.json --gate` | exit 0 |

### 6.2 红线（禁止 PASS 依据）

- 不得以 `needs_wake` / 纯 `test -f` / `echo OK` 作为 exec PASS  
- 不得以 DEV 摘要代替 checker 复跑  
- 不得扩 scope 到 Phase4.1 硬件或 GWT-3

---

## 7. 风险与应对

| 风险 | 影响 | 应对 |
|------|------|------|
| GWT-0 协议未正式评审 | stage2 仅检查 doc 存在 | 记录 WARN；不阻 GWT-TST-02 |
| stub 模块非真实 SNN | 分数/emit 仅 smoke | 本 WO 验架构管线，不测 acc KPI |
| neuro 与 vcompany 双仓 | report 在 vcompany | pathScope 已登记 `data/reports/` |
| Phase4.1 G0 未签字 | mgmt 软前置 | DEV 已 hotfix 验真；TEST 跟随 DEV 基线 |

---

## 8. 进度与资源

| 里程碑 | 交付 |
|--------|------|
| V0 方案/用例落盘 | 本文件 + `GWT_MVP_测试用例_V0.md` |
| 骨架报告 | `vcompany/data/reports/neuro-gwt-mvp-test-report.json` |
| checker exec | `GWT-TST-01~03` verify 证据 |

---

## 9. 追溯

| OR | FT | SR | AR | 测试方案章节 |
|----|----|----|-----|--------------|
| GWT 愿景 §1.2 工程化 GWT | GWT-1 | 工作区协议 §2–3 | `gwt_workspace.py` | §3.1 · §4 |
| GWT 愿景 §4.4 Phase6 | GWT-2 | 工作区协议 §3 tick 生命周期 | `gwt_mvp_exam.py` | §3.1 · §6.1 |
| WO-MGMT-NEURO-GWT-01 子单 TEST | Q-TST-003 | — | `tests/test_gwt_*.py` | §4.2 |
| test-v1 TST-LIVE-01 | — | — | `wo-verify-command-lint.py` | §6.1 |

---

*2026-07-11 · 陈正齐 · WO-TEST-NEURO-GWT-MVP-01*
