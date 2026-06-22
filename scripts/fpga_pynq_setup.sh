#!/bin/bash
# PYNQ-Z2 one-shot setup: static IP, python/pynq fix, blue LED smoke.
set -euo pipefail

PASS="${PYNQ_SUDO_PASS:-xilinx}"
STATIC_IP="${PYNQ_STATIC_IP:-192.168.137.3}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo_cmd() {
  echo "$PASS" | sudo -S "$@"
}

echo "[1/4] Persist eth0 -> ${STATIC_IP}"
sudo_cmd cp "${SCRIPT_DIR}/fpga-pynq-eth0.interfaces" /etc/network/interfaces.d/eth0
sudo_cmd ifdown eth0 2>/dev/null || true
sudo_cmd ifup eth0 2>/dev/null || true

echo "[2/4] Fix python3 pynq/pydantic + XRT groups"
sudo_cmd usermod -aG video,render xilinx || true
sudo_cmd bash -c 'echo /usr/local/share/pynq-venv/lib/python3.10/site-packages > /usr/local/lib/python3.10/dist-packages/pynq_venv.pth'
sudo_cmd tee /etc/profile.d/pynq_xrt.sh >/dev/null <<'EOF'
export XILINX_XRT=/usr
EOF

echo "[3/4] Verify import pynq"
export XILINX_XRT=/usr
python3 -c "import pydantic; import pynq; print('pynq', pynq.__version__, 'pydantic', pydantic.__version__)"

echo "[4/4] Blue LED smoke (LD4, needs sudo for PL mmap)"
export XILINX_XRT=/usr
echo "$PASS" | sudo -S -E python3 "${SCRIPT_DIR}/fpga_blue_led.py" 3

echo "PYNQ_SETUP_OK"
