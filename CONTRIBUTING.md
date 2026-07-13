# 贡献与 Git 约定

## 仓库定位

本仓 **`chenxi750328ai/neuromorphic-computing`** 与 **`chenxi750328ai/agent-jianghu`** 并列，专责类脑计算工程与文档，不依赖父目录 `/home/cx` 的 git 状态。

**流程轨道**：**研究项目（Research Track）** — IPD/QA 相对 vcompany 标准有 **裁剪**，见 [`docs/IPD-QA流程裁剪_待VP总裁批准.md`](docs/IPD-QA流程裁剪_待VP总裁批准.md)（须 VP 讨论 + 总裁批准生效）。

---

## 流程（裁剪版 · 五段）

| 步骤 | 研究轨要求 |
|------|------------|
| **1. 设计** | Phase 需求/结论写 `docs/`；TR1 已 Go，Phase4 前补 TR2 轻评审 |
| **2. 开发** | `feature/*`、`fix/*`、`docs/*` 分支 |
| **3. 测试** | 本地 4090 手跑 + `runs/*/metrics.json`；**CI** 跑语法/冒烟（不跑全量训练） |
| **4. QA** | VP 在 `docs/QA_验收记录_*.md` 写 **`VP QA: PASS`** |
| **5. 合并** | `neuro-ci` 绿 + VP PASS + 总裁已批准裁剪方案 → PR 合 `main` |

VP 讨论稿（vcompany）：[`vcompany/docs/03-ipd/类脑计算-QA流程裁剪_VP讨论稿.md`](../vcompany/docs/03-ipd/类脑计算-QA流程裁剪_VP讨论稿.md)

---

## 分支

- 禁止在本地 **`main`** 上堆叠未评审的日常提交；开发在 **`feature/*`**、**`fix/*`**、**`docs/*`** 完成。
- 合并进 **`main`** 经 Pull Request（或总裁授权的 hotfix）。

### `main` 分支保护（GitHub · 2026-07-14 起）

| 规则 | 值 |
|------|-----|
| 直推 `main` | **禁止**（含管理员；`enforce_admins`） |
| 合并方式 | 必须 PR；会话评论未解决不可合 |
| 审批 | ≥ **1** 个 approving review；代码变更后旧审批作废 |
| CI | **`qa`** 必绿，且 base 为最新 `main`（strict） |
| 强推 / 删 `main` | 禁止 |

**Agent 纪律**：默认只开/更新 PR，**不** `gh pr merge`；合 `main` 须总裁（或指定审批人）在 GitHub 上 Approve + Merge。  
说明：GitHub 无法区分「总裁本人」与「使用总裁 token 的 Agent」——保护拦的是流程，审批仍须人审。

---

## QA / CI 命令

```bash
# CI 层（每个 PR 必绿）
python3 scripts/qa-neuro-baseline-run.py --tier ci

# 合 main 前（须 VP 已在 QA 记录签字 PASS）
python3 scripts/qa-neuro-baseline-run.py --tier all
python3 scripts/qa-neuro-phase-signoff.py --check

# 冒烟单测
python3 -m unittest discover -s tests -p "test_*.py" -q
```

机读 gate：[`config/neuro-qa-gate-baseline.json`](config/neuro-qa-gate-baseline.json)  
GitHub Actions：[`.github/workflows/ci.yml`](.github/workflows/ci.yml)

---

## 提交说明（必须）

每条 commit message **须包含负责人 AG 署名**之一：

- **陈正共**
- **ChenZhengGong**

示例：

```text
feat(phase1): MNIST SNN 训练脚本 [陈正共 · ChenZhengGong]
```

---

## 推送凭证

- 使用 **`/home/cx/agentfuture/.env`** 中的 **`CHENXI750328AI_GITHUB_USER`**、**`CHENXI750328AI_GITHUB_PAT`**。
- 勿将 `.env`、PAT、Webhook 写入本仓。

## 推送脚本（可选）

```bash
./scripts/push_github.sh
```

从仓库根目录读取上述环境变量并 `git push origin`。
