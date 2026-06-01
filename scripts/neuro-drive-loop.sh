#!/usr/bin/env bash
# 类脑自驱：/loop 监听 AGENT_LOOP_TICK_NEURO
# 每轮：小脑写纸条 → echo 纸条 instruction → Agent 被唤醒执行
# 用法：./scripts/neuro-drive-loop.sh [间隔秒，默认 600]
set -euo pipefail
INTERVAL="${1:-600}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VC="/home/cx/vcompany"
while true; do
  sleep "$INTERVAL"
  python3 "$VC/scripts/neuromorphic-cerebellum.py" || true
  python3 "$ROOT/scripts/neuro-loop-emit.py" || true
done
