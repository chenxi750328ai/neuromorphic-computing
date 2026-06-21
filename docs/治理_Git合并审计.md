# 类脑 · Git 合并记录（审计）

> **用途**：澄清「谁合了 main」；Agent 不得自行 merge，除非用户明确授权。

---

## PR #2（2026-06-08）

| 项 | 值 |
|----|-----|
| PR | https://github.com/chenxi750328ai/neuromorphic-computing/pull/2 |
| 合并提交 | `3e573a0` Merge pull request #2 from …/feature/neuro-ipd-qa-tailoring |
| **merged_by（GitHub 记录）** | **`chenxi750328`** |
| merged_at | 2026-06-08T06:49:49Z |
| 本机 Agent | **未执行** `gh pr merge`；仅 `gh pr view` 确认状态为 MERGED |

**说明**：合并权限来自 GitHub 账号 `chenxi750328`（仓库 owner/PAT），非 Cursor Agent 独立权限。  
**流程要求**：研究轨合 main 须 `neuro-ci` 绿 + 总裁已批裁剪 + VP `VP_QA: PASS`（VP 签字可后补，但 merge 决策应经 VP/总裁授权）。

---

## PR #3（2026-06-21）

| 项 | 值 |
|----|-----|
| PR | https://github.com/chenxi750328ai/neuromorphic-computing/pull/3 |
| 合并提交 | `ddabfcd` feat(phase4): Atlas MNIST OM 冒烟与 TR2 筹备 (#3) |
| **merged_by（GitHub 记录）** | **`chenxi750328`** |
| merged_at | 2026-06-21T13:56:27Z |
| neuro-ci | **PASS**（push + merge 各 1 次 qa job） |
| 本机 Agent | **未执行** `gh pr merge`；`gh pr view` 确认 MERGED |

**范围**：Phase4 PoC 脚本/文档、Atlas 连接真源、小脑看板同步；M4-3 Atlas MNIST OM 冒烟留档。

---

*陈正共 · 2026-06-22*
