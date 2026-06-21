# 类脑计算 · IPD / QA 流程裁剪（VP 已确认 · 总裁已批示）

> **项目**：`chenxi750328ai/neuromorphic-computing` · **轨道**：**研究项目（Research Track）**  
> **负责人**：陈正共 · **起草**：2026-06-08 · **VP 确认**：2026-06-08 陈小五-VP  
> **依据**：[`vcompany/docs/03-ipd/QA与工程门禁基线_V1.md`](../../vcompany/docs/03-ipd/QA与工程门禁基线_V1.md) · [`PDCP-QA裁剪表_模板.md`](../../vcompany/docs/03-ipd/PDCP-QA裁剪表_模板.md)  
> **VP 讨论稿**：[`vcompany/docs/03-ipd/类脑计算-QA流程裁剪_VP讨论稿.md`](../../vcompany/docs/03-ipd/类脑计算-QA流程裁剪_VP讨论稿.md)  
> **浏览器阅读 + 总裁批示**：http://127.0.0.1:18766/dashboard/md-viewer.html?src=%2Fdocs%2Fneuromorphic-computing%2FIPD-QA%E6%B5%81%E7%A8%8B%E8%A3%81%E5%89%AA_%E5%BE%85VP%E6%80%BB%E8%A3%81%E6%89%B9%E5%87%86.md&from=console  
> **页顶有「批准生效 / 附条件 / 驳回」按钮**；或打开 [总裁对话台](http://127.0.0.1:18766/dashboard/president-console.html) →「类脑 · 待总裁批示」  
> （须先起看板服务：`python3 /home/cx/vcompany/scripts/vp-dashboard-serve.py`）

---

## 1. 为何裁剪（以及什么 **不** 裁剪）

### 总裁预审（2026-06-08）

> **CI 不能裁剪。** 先 VP 讨论，再总裁批准本表。

| 类别 | 内容 |
|------|------|
| **不可裁剪** | **CI 管线**：每 PR/push 跑 `neuro-ci`；`tier=ci` 全 gate **BLOCK**；`main` **branch protection**（必 PR + CI 绿） |
| **可裁剪** | vcompany **平台地基**（spec-registry、spawn-access、BOM、L0–L3、delivery-scope 等） |
| **澄清** | 4090 **全量训练手跑** + `metrics.json` 是 **算力分工**，**不替代** CI，也 **不等于** 裁剪 CI |

### 背景

| 事实 | 含义 |
|------|------|
| 类脑为 **独立 Git 仓**，非 vcompany 子目录 | 不挂 `vcompany-ci` 全量脚本，但 **须自有 CI** |
| vcompany 章程 **BA-10 Out** | 平台 OR/BOM 等可裁剪；**CI 门禁不在裁剪表** |
| **TR1 已 Go**（2026-05-28） | Phase 以实验指标 + 轻评审为主 |
| 研究性质 | CI 跑语法/冒烟/shellcheck/文档；**指标**在 4090 手跑 |

**原则**：地基不可默认全免；**CI 除外于裁剪**；可审计链路：设计 → 开发 → **CI 必绿** → VP QA → 总裁批准 → PR 合并。

---

## 2. 与 vcompany 标准五段流程对照

| 环节 | vcompany 标准 | 类脑研究轨（本方案） | 裁剪 |
|------|---------------|----------------------|------|
| **设计** | OR 九项 + IPD 文档 | TR1 已做 + Phase 需求草案 + 实验结论 md | 免 OR 机读清单；保留 md 真源 |
| **开发** | `feature/*` + PR | **同** | 不裁剪 |
| **测试** | CI 必绿 + 验收清单 | **CI 不裁剪**：语法/冒烟/shellcheck/文档 **BLOCK**；指标 4090 手跑 | **仅** 全量训练不进 runner |
| **QA** | VP PASS/FAIL | VP 在 `docs/QA_验收记录_*.md` 签字 **PASS** | 裁剪 qa-baseline 全包 |
| **合并** | 非 trivial → 总裁确认 | Phase 级：**VP PASS + 总裁批准行** 后 merge `main` | 裁剪 spec-plan-gate |

---

## 3. QA 门禁裁剪表（Tailoring）

> **总裁预审**：**CI 不在本表** — `N-CI-*` 一律 **不可裁剪、BLOCK**。  
> 下表仅列 **vcompany 平台地基** 在研究轨的豁免（待 VP 讨论确认）。

### 3.1 不可裁剪（强制 · 不在裁剪表投票）

| 项 | tier | 说明 |
|----|------|------|
| `N-CI-SYNTAX` / `N-CI-SMOKE` / `N-CI-SHELL` / `N-CI-DOCS` | **ci BLOCK** | GitHub `neuro-ci` + `qa-neuro-baseline-run.py --tier ci` |
| `main` branch protection | — | 必 PR + CI 绿（VP 配 GitHub Settings） |
| `N-PRE-MERGE-QA` | pre_merge BLOCK | VP QA 签字（与 CI 并列，非替代） |

机读：[`config/neuro-qa-gate-baseline.json`](../config/neuro-qa-gate-baseline.json) · `ciPolicy: NO_TAILORING`

### 3.2 平台地基（可裁剪 · 待 VP + 总裁批准）

| gateId（vcompany） | 默认 | 研究轨 | 理由 |
|--------------------|------|--------|------|
| G-SPEC-REGISTRY-PLAN | ci BLOCK | **豁免** | 无 spec-registry；Phase 需求用 md |
| G-SPEC-VERIFY-PREFLIGHT | ci BLOCK | **豁免** | 无 Adapter 契约 |
| G-SPAWN-ACCESS | pre_spawn BLOCK | **豁免** | 不经过 PO spawn 编排 |
| G-BOM-L1 | ci BLOCK | **豁免** | 研究栈 torch/snnTorch，无 BOM gate |
| G-ARCH-SCHEMA-L0 ~ L3 | ci BLOCK | **豁免** | 无 4+1 架构仓 |
| G-DELIVERY-SCOPE | ci BLOCK | **豁免** | 未纳入 delivery-scope-v1 |
| TR2/TR3 正式评审 | 产品轨必做 | **WARN → Phase 笔记** | Phase4 前补 TR2 轻评审 |

---

## 4. 研究轨保留项（批准即生效）

### 4.1 CI（每个 PR / push · GitHub `neuro-ci`）

```bash
python3 scripts/qa-neuro-baseline-run.py --tier ci
```

### 4.2 阶段验收（4090 手跑 · 不入 CI）

| Phase | 验收 | 及格线 | 已达成 |
|-------|------|--------|--------|
| Phase1 SNN | `runs/*/metrics.json` test acc | ≥90% | **96.97%** |
| Phase2 ANN | 同上 | ≥90% | **98.10%** |
| Phase3 小样本 | 实验报告 md | 微调路线有效 | ANN 96.32% / SNN 89.23% |

### 4.3 合并 `main` 前（pre_merge）

```bash
python3 scripts/qa-neuro-baseline-run.py --tier all
python3 scripts/qa-neuro-phase-signoff.py --check   # 须含 VP QA: PASS
```

---

## 5. 审批栏（须 VP 讨论后总裁签字）

| 角色 | 决定 | 签字 | 日期 |
|------|------|------|------|
| **VP（陈小五）** | ✅ **同意研究轨裁剪**（5 点全同意；CI 不裁剪） | 陈小五-VP | 2026-06-08 |
| **总裁** | ✅ **批准生效** | test | 2026-06-08 |

**VP 确认摘要**（[`讨论稿 §5`](../../vcompany/docs/03-ipd/类脑计算-QA流程裁剪_VP讨论稿.md)）：

- CI 不可裁剪 · `neuro-ci` 全 BLOCK · `main` branch protection  
- vcompany `qa-baseline-run` 豁免，类脑用 `qa-neuro-baseline-run.py`  
- 合 `main` 须 VP QA 签字（pre_merge）  
- Phase3 先 PR 合入再 VP 补签追溯验收  
- Phase4 前 TR2 轻评审  

**批准后动作**（陈正共）：

1. VP 在 [`QA_验收记录_Phase1-3.md`](./QA_验收记录_Phase1-3.md) 填写 `VP QA: PASS`  
2. 总裁在同一文件或本表 §5 签字「批准」  
3. 启用 GitHub branch protection：`main` 要求 `neuro-ci` 通过  
4. 更新 [`vcompany/data/neuromorphic-milestones.json`](../../vcompany/data/neuromorphic-milestones.json) headline

---

## 6. 机读与脚本

| 文件 | 用途 |
|------|------|
| [`config/neuro-qa-gate-baseline.json`](../config/neuro-qa-gate-baseline.json) | 研究轨 gate 清单 |
| [`scripts/qa-neuro-baseline-run.py`](../scripts/qa-neuro-baseline-run.py) | 一键跑 gate |
| [`scripts/qa-neuro-doc-check.py`](../scripts/qa-neuro-doc-check.py) | 文档存在性 |
| [`scripts/qa-neuro-phase-signoff.py`](../scripts/qa-neuro-phase-signoff.py) | VP PASS 检查 |
| [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) | GitHub Actions |

---

*起草：陈正共 · ChenZhengGong · 2026-06-08*
