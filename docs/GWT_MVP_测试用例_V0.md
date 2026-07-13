# GWT-MVP · 测试用例 V0

> **WO**：WO-TEST-NEURO-GWT-MVP-01  
> **方案**：[GWT_MVP_测试方案_V0.md](./GWT_MVP_测试方案_V0.md)  
> **设计真源**：`docs/GWT_愿景与阶段依赖_V1.md` §4.4 · `docs/GWT_工作区协议_V0.md` §2–3  
> **DEV 基线**：`feature/neuro-gwt-mvp` · commit `d91c30c`  
> **作者**：陈正齐（ag-chenzhengqi）

---

## 0. 与开发设计对齐声明

| 检查项 | 结论 |
|--------|------|
| PASS 依据 | pytest exit 0 / exam `--gate` exit 0 / lint exit 0 |
| 竞争写 k_active | 与协议 §1 默认 K=32、k_active=8 一致（单测可缩维） |
| GWT-2 T≥8 | `test_global_tick_multi_module` 与 exam `--ticks 8` 对齐 |
| 范围外 | Phase4.1 硬件 · GWT-3 CL · Phase7 跨板 **不测** |

---

## 1. 文档信息

| 项 | 内容 |
|----|------|
| 模块 | gwt-mvp / Phase6 仿真 |
| 版本 | V0 |

---

## 2. P0 用例

### TC-GWT-01 · workspace 竞争写尊重 k_active

| 项 | 内容 |
|----|------|
| 标题 | merge 取 top-k_active 候选入槽 |
| 层级 | AR |
| **OR-Ref** | GWT 愿景 §1.2 竞争接入 |
| **FT-Ref** | GWT-2 |
| **SR-Ref** | 工作区协议 §2.3 竞争写算法 |
| **AR-Ref** | `scripts/gwt_workspace.py` · `Workspace.merge` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | numpy 可用；`scripts/` 在 PYTHONPATH |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 -m pytest tests/test_gwt_workspace.py::test_merge_respects_k_active -q --tb=short` |
| **预期结果** | exit 0；写入日志数 = k_active=3；`ws.tick == 1` |
| 自动化 | 是 · `tests/test_gwt_workspace.py` |
| verifyId | GWT-TST-01（聚合 pytest 套件） |
| 状态 | 未测 |

### TC-GWT-02 · snapshot 广播深拷贝

| 项 | 内容 |
|----|------|
| 标题 | broadcast 快照修改不影响原 W |
| 层级 | AR |
| **OR-Ref** | GWT 愿景 §1.2 广播读取 |
| **FT-Ref** | GWT-2 |
| **SR-Ref** | 工作区协议 §2.4 广播读 |
| **AR-Ref** | `scripts/gwt_workspace.py` · `Workspace.snapshot` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | workspace 已实例化 |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 -m pytest tests/test_gwt_workspace.py::test_snapshot_is_copy tests/test_gwt_workspace.py::test_broadcast_read_only -q --tb=short` |
| **预期结果** | exit 0；修改 snap.W 不改变原 `ws.W`；`active_count >= 1` |
| 自动化 | 是 · `tests/test_gwt_workspace.py` |
| verifyId | GWT-TST-01 |
| 状态 | 未测 |

### TC-GWT-03 · M1 产出写候选

| 项 | 内容 |
|----|------|
| 标题 | M1 local_step 返回 WriteCandidate |
| 层级 | AR |
| **OR-Ref** | GWT 愿景 §2 M1 感知模块 |
| **FT-Ref** | GWT-1 |
| **SR-Ref** | 工作区协议 §4 M1 职责 |
| **AR-Ref** | `scripts/gwt/modules/m1_perception.py` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | M1 stub 可 import |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 -m pytest tests/test_gwt_modules.py::test_m1_produces_candidate -q --tb=short` |
| **预期结果** | exit 0；`cand.module_id == "M1"` |
| 自动化 | 是 · `tests/test_gwt_modules.py` |
| verifyId | GWT-TST-01 |
| 状态 | 未测 |

### TC-GWT-04 · GWT-1 stage1 管线

| 项 | 内容 |
|----|------|
| 标题 | M1→workspace→M4 单向 1 tick |
| 层级 | FT |
| **OR-Ref** | GWT 愿景 §4.4 GWT-1 |
| **FT-Ref** | GWT-1 |
| **SR-Ref** | 工作区协议 §3 tick 生命周期（单步） |
| **AR-Ref** | `scripts/gwt_mvp_exam.py` · `run_stage1` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | M1/M4 stub 可用 |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 -m pytest tests/test_gwt_modules.py::test_stage1_pipeline -q --tb=short` |
| **预期结果** | exit 0；`emit.class_id >= 0` |
| 自动化 | 是 · `tests/test_gwt_modules.py` |
| verifyId | GWT-TST-01 |
| 状态 | 未测 |

### TC-GWT-05 · GWT-2 多模块 8 tick

| 项 | 内容 |
|----|------|
| 标题 | M1–M4 global_tick ×8 |
| 层级 | FT |
| **OR-Ref** | GWT 愿景 §4.4 GWT-2 |
| **FT-Ref** | GWT-2 |
| **SR-Ref** | 工作区协议 §3 · T≥8 |
| **AR-Ref** | `scripts/gwt_workspace.py` · `run_global_tick` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | 四模块 stub 可 import |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 -m pytest tests/test_gwt_modules.py::test_global_tick_multi_module -q --tb=short` |
| **预期结果** | exit 0；`ws.tick == 8`；`ws.active_count >= 1` |
| 自动化 | 是 · `tests/test_gwt_modules.py` |
| verifyId | GWT-TST-01 |
| 状态 | 未测 |

### TC-GWT-06 · Q-TST-003 pytest exec 探针（套件）

| 项 | 内容 |
|----|------|
| 标题 | GWT pytest 机械执行（WO GWT-TST-01） |
| 层级 | FT |
| **OR-Ref** | WO-MGMT-NEURO-GWT-01 TEST 子单 |
| **FT-Ref** | Q-TST-003 |
| **SR-Ref** | test-v1 §Q-TST-003 |
| **AR-Ref** | `tests/test_gwt_workspace.py` · `tests/test_gwt_modules.py` |
| 优先级 | P0 |
| 类型 | 回归 |
| 前置条件 | DEV commit `d91c30c` 或更新绿基线 |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 -m pytest tests/test_gwt_workspace.py tests/test_gwt_modules.py -q --tb=short` |
| **预期结果** | exit 0；6 passed |
| 自动化 | 是 · WO verification 命令一字不差 |
| verifyId | **GWT-TST-01** |
| 状态 | 未测 |

### TC-GWT-07 · GWT-2 exam 端到端复跑

| 项 | 内容 |
|----|------|
| 标题 | exam stage2 gate 复跑（WO GWT-TST-02） |
| 层级 | FT |
| **OR-Ref** | GWT 愿景 §4.4 GWT-2 |
| **FT-Ref** | GWT-2 |
| **SR-Ref** | 工作区协议 §3 · §6 |
| **AR-Ref** | `scripts/gwt_mvp_exam.py` |
| 优先级 | P0 |
| 类型 | 功能 |
| 前置条件 | `docs/GWT_工作区协议_V0.md` 存在 |
| **步骤** | 1. `cd /home/cx/neuromorphic-computing` 2. `python3 scripts/gwt_mvp_exam.py --stage 2 --gate --workspace-doc docs/GWT_工作区协议_V0.md` |
| **预期结果** | exit 0；输出含 `GWT stage 2: PASS`；`workspace_tick: 8`；`modules_written` 含 M1–M4 |
| 自动化 | 是 · WO verification 命令一字不差 |
| verifyId | **GWT-TST-02** |
| 状态 | 未测 |

### TC-GWT-08 · TST-LIVE-01 反作弊 lint

| 项 | 内容 |
|----|------|
| 标题 | WO verification 命令反作弊（WO GWT-TST-03） |
| 层级 | SR |
| **OR-Ref** | test-v1 TST-LIVE-01 |
| **FT-Ref** | — |
| **SR-Ref** | `wo-verify-command-lint.py` |
| **AR-Ref** | `vcompany/data/work-orders/WO-TEST-NEURO-GWT-MVP-01.json` |
| 优先级 | P0 |
| 类型 | 安全/纪律 |
| 前置条件 | vcompany 仓可访问 |
| **步骤** | 1. `cd /home/cx/vcompany` 2. `python3 scripts/wo-verify-command-lint.py --wo data/work-orders/WO-TEST-NEURO-GWT-MVP-01.json --gate` |
| **预期结果** | exit 0；JSON `ok: true`；`issues` 为空 |
| 自动化 | 是 · WO verification 命令一字不差 |
| verifyId | **GWT-TST-03** |
| 状态 | 未测 |

---

## 3. 追溯矩阵

| 用例 ID | OR | FT | SR | AR | verifyId |
|---------|----|----|----|-----|----------|
| TC-GWT-01 | 愿景 §1.2 | GWT-2 | 协议 §2.3 | gwt_workspace.merge | GWT-TST-01 |
| TC-GWT-02 | 愿景 §1.2 | GWT-2 | 协议 §2.4 | gwt_workspace.snapshot | GWT-TST-01 |
| TC-GWT-03 | 愿景 §2 | GWT-1 | 协议 §4 | m1_perception | GWT-TST-01 |
| TC-GWT-04 | 愿景 §4.4 | GWT-1 | 协议 §3 | gwt_mvp_exam stage1 | GWT-TST-01 |
| TC-GWT-05 | 愿景 §4.4 | GWT-2 | 协议 §3 | run_global_tick | GWT-TST-01 |
| TC-GWT-06 | mgmt TEST | Q-TST-003 | test-v1 | test_gwt_*.py | **GWT-TST-01** |
| TC-GWT-07 | 愿景 §4.4 | GWT-2 | 协议 §3 | gwt_mvp_exam stage2 | **GWT-TST-02** |
| TC-GWT-08 | TST-LIVE-01 | — | lint | WO json | **GWT-TST-03** |

---

## 4. 执行摘要（报告引用）

| 统计 | 数量 |
|------|------|
| 总用例 | 8 |
| P0 | 8 |
| PASS | 0（待 exec） |
| FAIL | 0 |
| BLOCK | 0 |

---

*2026-07-11 · 陈正齐 · WO-TEST-NEURO-GWT-MVP-01*
