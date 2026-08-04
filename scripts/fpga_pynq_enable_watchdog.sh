#!/bin/bash
# PYNQ-Z2 · 打开硬件看门狗（陈正共）
# SoC: cdns-wdt /dev/watchdog0（约 10s）。
# systemd 服务周期写 /dev/watchdog；CPU 硬挂停写 → 自动复位。
set -euo pipefail

PASS="${PYNQ_SUDO_PASS:-${PYNQ_PASS:-}}"
if [[ -z "$PASS" ]]; then
  echo "FAIL set PYNQ_PASS or PYNQ_SUDO_PASS" >&2
  exit 2
fi

sudo_cmd() {
  # 密码走 stdin；勿与 heredoc 抢 stdin
  echo "$PASS" | sudo -S "$@"
}

UNIT_TMP="$(mktemp)"
cat >"$UNIT_TMP" <<'EOF'
[Unit]
Description=Neuro PYNQ hardware watchdog petter (ChenZhengGong)
After=multi-user.target

[Service]
Type=simple
ExecStart=/bin/bash -c 'while true; do printf A > /dev/watchdog; sleep 2; done'
Restart=always
RestartSec=1
Nice=-5

[Install]
WantedBy=multi-user.target
EOF

CONF_TMP="$(mktemp)"
cat >"$CONF_TMP" <<'EOF'
[Manager]
RuntimeWatchdogSec=10
RebootWatchdogSec=2min
EOF

echo "[1/4] install unit (unmask if needed)"
sudo_cmd systemctl unmask neuro-hw-watchdog.service 2>/dev/null || true
sudo_cmd rm -f /etc/systemd/system/neuro-hw-watchdog.service
sudo_cmd cp "$UNIT_TMP" /etc/systemd/system/neuro-hw-watchdog.service
sudo_cmd chmod 644 /etc/systemd/system/neuro-hw-watchdog.service

echo "[2/4] enable --now"
sudo_cmd systemctl daemon-reload
sudo_cmd systemctl enable --now neuro-hw-watchdog.service

echo "[3/4] optional RuntimeWatchdogSec drop-in"
sudo_cmd mkdir -p /etc/systemd/system.conf.d
sudo_cmd cp "$CONF_TMP" /etc/systemd/system.conf.d/10-watchdog.conf
sudo_cmd systemctl daemon-reexec || true

rm -f "$UNIT_TMP" "$CONF_TMP"

echo "[4/4] verify"
sleep 1
systemctl is-active neuro-hw-watchdog.service
systemctl is-enabled neuro-hw-watchdog.service
pgrep -af 'printf A > /dev/watchdog' | head -2 || true
test -e /dev/watchdog0 && echo "dev_watchdog0=present"
dmesg | grep -i 'Xilinx Watchdog\|cdns-wdt' | tail -2 || true

echo "PYNQ_WATCHDOG_ENABLE_OK service=neuro-hw-watchdog.service"
