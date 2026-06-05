#!/usr/bin/env bash
# Phase 3：MNIST 小样本 ANN（K=1,5,10 · 陈正共）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
if [[ ! -x .venv/bin/python ]]; then
  python3 -m venv .venv
  .venv/bin/pip install --default-timeout=300 torch torchvision --index-url https://download.pytorch.org/whl/cu124
  .venv/bin/pip install --default-timeout=300 snntorch
fi
PY=.venv/bin/python
RESULTS="$ROOT/docs/phase3_fewshot_results.md"
{
  echo "# Phase 3 · 小样本结果（自动生成）"
  echo ""
  echo "> 生成时间：$(date -Iseconds) · 陈正共"
  echo ""
  echo "| K-shot/类 | 训练张数 | test acc | 与全量 ANN gap | 及格 | run_id |"
  echo "|-----------|----------|----------|----------------|------|--------|"
} > "$RESULTS"
for K in 1 5 10; do
  PASS=0.70
  [[ "$K" -ge 5 ]] && PASS=0.85
  "$PY" scripts/train_mnist_fewshot.py --shots-per-class "$K" --pass-line "$PASS" --epochs 30 "$@" || true
  RUN=$(ls -td "$ROOT"/runs/*_fewshot_k"${K}" 2>/dev/null | head -1 || true)
  if [[ -n "$RUN" && -f "$RUN/metrics.json" ]]; then
    "$PY" -c "
import json
from pathlib import Path
m = json.loads(Path('$RUN/metrics.json').read_text())
rid = Path('$RUN').name
ok = '✓' if m['pass_fewshot'] else '✗'
print(f\"| {m['shots_per_class']} | {m['train_images']} | {m['test_accuracy']*100:.2f}% | {m['gap_vs_full_ann']*100:.2f}pp | {ok} | \`{rid}\` |\")
" >> "$RESULTS"
  else
    echo "| $K | — | — | — | ✗ | 无 metrics |" >> "$RESULTS"
  fi
done
SNN_CKPT="${SNN_CKPT:-$ROOT/runs/20260527T092534Z/checkpoint.pt}"
ANN_CKPT="${ANN_CKPT:-$ROOT/runs/20260530T010904Z_ann/checkpoint.pt}"
{
  echo ""
  echo "## SNN 小样本（类脑路线）"
  echo ""
  echo "| 方式 | K | test acc | 及格 | run_id |"
  echo "|------|---|----------|------|--------|"
} >> "$RESULTS"
for MODE in scratch finetune; do
  for K in 5 10; do
    EXTRA=()
    if [[ "$MODE" == "finetune" && -f "$SNN_CKPT" ]]; then
      EXTRA=(--warm-start "$SNN_CKPT" --epochs 20)
      LABEL="SNN微调"
    else
      EXTRA=(--epochs 30)
      LABEL="SNN从头"
      [[ "$MODE" == "finetune" ]] && continue
    fi
    "$PY" scripts/train_mnist_fewshot_snn.py --shots-per-class "$K" --pass-line 0.85 "${EXTRA[@]}" "$@" || true
    RUN=$(ls -td "$ROOT"/runs/*_fewshot_snn_k"${K}" 2>/dev/null | head -1 || true)
    if [[ -n "$RUN" && -f "$RUN/metrics.json" ]]; then
      "$PY" -c "
import json
from pathlib import Path
m = json.loads(Path('$RUN/metrics.json').read_text())
ok = '✓' if m['pass_fewshot'] else '✗'
print(f\"| $LABEL | {m['shots_per_class']} | {m['test_accuracy']*100:.2f}% | {ok} | \`{Path('$RUN').name}\` |\")
" >> "$RESULTS"
    fi
  done
done
{
  echo ""
  echo "## ANN 小样本微调（对照）"
  echo ""
  echo "| K | test acc | run_id |"
  echo "|---|----------|--------|"
} >> "$RESULTS"
for K in 5 10; do
  if [[ -f "$ANN_CKPT" ]]; then
    "$PY" scripts/train_mnist_fewshot.py -k "$K" --warm-start "$ANN_CKPT" --epochs 20 --pass-line 0.85 "$@" || true
    RUN=$(ls -td "$ROOT"/runs/*_fewshot_k"${K}" 2>/dev/null | head -1 || true)
    if [[ -n "$RUN" && -f "$RUN/metrics.json" ]]; then
      "$PY" -c "
import json
from pathlib import Path
m = json.loads(Path('$RUN/metrics.json').read_text())
print(f\"| {m['shots_per_class']} | {m['test_accuracy']*100:.2f}% | \`{Path('$RUN').name}\` |\")
" >> "$RESULTS"
    fi
  fi
done
{
  echo ""
  echo "基线：全量 ANN **98.10%** · 全量 SNN **96.97%**（见 \`phase2_snn_vs_ann.md\`）"
  echo ""
  echo "复现：\`./scripts/run_phase3.sh\`"
} >> "$RESULTS"
echo "wrote $RESULTS"
