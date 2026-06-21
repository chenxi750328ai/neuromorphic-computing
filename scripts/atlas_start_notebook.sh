#!/bin/bash
# Atlas 200I DK — 启动 Jupyter Notebook（离线安装后使用）
# shellcheck source=/dev/null
source /usr/local/Ascend/ascend-toolkit/set_env.sh
export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH

IP="${1:-192.168.137.2}"
PORT="${2:-8888}"
TOKEN="${JUPYTER_TOKEN:-atlas}"

cd /home/HwHiAiUser/samples/notebooks || exit 1
echo "Jupyter Notebook: http://${IP}:${PORT}/?token=${TOKEN}"
exec python3 -m notebook \
  --ip=0.0.0.0 \
  --port="${PORT}" \
  --allow-root \
  --no-browser \
  --NotebookApp.token="${TOKEN}" \
  --NotebookApp.password=''
