#!/usr/bin/env bash
# 安装类脑 Cursor hook（用户级 ~/.cursor/hooks + 仓内 .cursor/hooks.json 已指向本仓脚本）
set -euo pipefail
NEURO="$(cd "$(dirname "$0")/.." && pwd)"
HOOK_DIR="${HOME}/.cursor/hooks"
mkdir -p "$HOOK_DIR"
install -m 755 "$NEURO/scripts/neuromorphic-cursor-wake.py" "$HOOK_DIR/neuromorphic-cursor-wake.py"
install -m 755 "$NEURO/scripts/neuromorphic-cerebellum.py" "$HOOK_DIR/neuromorphic-cerebellum.py"
echo "OK: neuromorphic-cursor-wake.py + neuromorphic-cerebellum.py → $HOOK_DIR"
echo "项目 hook: $NEURO/.cursor/hooks.json"
echo "请在 Cursor 以类脑仓根目录开工作区，Settings → Hooks 确认 Loaded。"
