#!/bin/bash
# Phase4 M4-3 · MNIST surrogate ONNX → OM → AclLite 冒烟
set -eo pipefail
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"
# shellcheck source=/dev/null
source /usr/local/Ascend/ascend-toolkit/set_env.sh
WORKDIR="${1:-/tmp/phase4_poc}"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

ATC=/usr/local/Ascend/ascend-toolkit/7.0.RC1.3/aarch64-linux/bin/atc
ONNX="${WORKDIR}/model_ann_surrogate.onnx"
OM="${WORKDIR}/mnist_snn_surrogate.om"

if [[ ! -f "$ONNX" ]]; then
  echo "missing $ONNX" >&2
  exit 1
fi

echo "=== ATC input:1,1,28,28 ==="
"$ATC" \
  --model="$ONNX" \
  --framework=5 \
  --output="${WORKDIR}/mnist_snn_surrogate" \
  --input_format=NCHW \
  --input_shape="input:1,1,28,28" \
  --soc_version=Ascend310B4 \
  --log=error

export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH
python3 "${WORKDIR}/phase4_atlas_mnist_smoke.py" --model "$OM"
