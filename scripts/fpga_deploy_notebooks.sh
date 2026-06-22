#!/bin/bash
# Push neuromorphic Jupyter notebooks to PYNQ-Z2.
set -euo pipefail

HOST="${PYNQ_HOST:-192.168.137.3}"
USER="${PYNQ_USER:-xilinx}"
PASS="${PYNQ_PASS:-xilinx}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REMOTE_DIR="/home/xilinx/jupyter_notebooks/neuromorphic"

sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no "${USER}@${HOST}" "mkdir -p ${REMOTE_DIR}"

sshpass -p "$PASS" scp -o StrictHostKeyChecking=no \
  "${ROOT}/notebooks/fpga/"*.ipynb \
  "${USER}@${HOST}:${REMOTE_DIR}/"

echo "Deployed to http://${HOST}:9090/lab/tree/neuromorphic"
echo "Open: http://${HOST}:9090/lab/tree/neuromorphic/01_fpga_blue_led_demo.ipynb"
