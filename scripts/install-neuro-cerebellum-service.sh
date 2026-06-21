#!/usr/bin/env bash
# 安装类脑小脑 systemd 用户服务（例行 tick + 看板/总裁汇报同步）
set -euo pipefail
UNIT_DIR="${HOME}/.config/systemd/user"
mkdir -p "$UNIT_DIR"
install -m 644 "$(dirname "$0")/../config/neuro-cerebellum.service" "$UNIT_DIR/neuro-cerebellum.service"
systemctl --user daemon-reload
systemctl --user enable neuro-cerebellum.service
systemctl --user restart neuro-cerebellum.service || true
echo "OK: neuro-cerebellum.service"
systemctl --user status neuro-cerebellum.service --no-pager || true
echo "若 WSL 需 linger: loginctl enable-linger \$USER"
