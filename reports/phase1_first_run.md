# Phase 1 首跑摘要（TR1 证据）

| 字段 | 值 |
|------|-----|
| **run_id** | `20260527T092534Z` |
| **seed** | 42 |
| **device** | cuda (RTX 4090) |
| **test_accuracy** | **96.97%** |
| **pass_line_90pct** | true |
| **params** | 203530 |
| **elapsed_sec** | 112.62 |

完整指标见本机 `runs/20260527T092534Z/metrics.json`（`runs/` 目录不入库，见 `.gitignore`）。

复现：

```bash
./scripts/run_phase1.sh
```

*陈正共 · ChenZhengGong · 2026-05-27*
