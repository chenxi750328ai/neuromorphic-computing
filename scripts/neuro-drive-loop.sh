#!/usr/bin/env bash
# 类脑自驱 loop：小脑 tick → AGENT_LOOP_TICK_NEURO（供 Cursor /loop 或后台监听）
# 用法：./scripts/neuro-drive-loop.sh [间隔秒，默认 600]
set -euo pipefail
INTERVAL="${1:-600}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$ROOT/.neuro-drive-loop.log"
ts() { date '+%Y-%m-%dT%H:%M:%S%z'; }
while true; do
  sleep "$INTERVAL"
  {
    echo "[$(ts)] cerebellum tick"
    python3 "$ROOT/scripts/neuromorphic-cerebellum.py" --once || true
    python3 "$ROOT/scripts/neuro-loop-emit.py" || true
  } 2>&1 | tee -a "$LOG"
done
