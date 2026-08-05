## Summary

-

## IPD / 合入前检查（必填）

- [ ] 对应 **WO-DEV-*** EXEC 已 PASS（或无 DEV 工单的纯 docs 变更已说明）
- [ ] 对应 **WO-TEST-*** EXEC 已 PASS，且状态为 `awaiting_acceptance` / `done`
- [ ] 已跑：`python3 scripts/neuro-pre-merge-ipd-gate.py --wo <WO-TEST-*> --gate`（exit 0）
- [ ] **neuro-ci** `qa` 绿
- [ ] **禁止**：仅 CI 绿就合；TEST 未过不得 merge

## Test plan

- [ ]

---

合入顺序真源：DEV → TEST → PR/ci → 人审 → merge → VP 关单。
