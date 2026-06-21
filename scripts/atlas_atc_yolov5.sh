#!/bin/bash
# ONNX -> OM (ATC) for YOLOv5s on Atlas 310B4
set -eo pipefail
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"
# shellcheck source=/dev/null
source /usr/local/Ascend/ascend-toolkit/set_env.sh
cd /home/HwHiAiUser/samples/notebooks/01-yolov5

ATC=/usr/local/Ascend/ascend-toolkit/7.0.RC1.3/aarch64-linux/bin/atc
OUT="${1:-yolov5s_custom}"

echo "Converting yolov5s.onnx -> ${OUT}.om (input: input_image)"
"${ATC}" \
  --model=yolov5s.onnx \
  --framework=5 \
  --output="${OUT}" \
  --input_format=NCHW \
  --input_shape="input_image:1,3,640,640" \
  --soc_version=Ascend310B4 \
  --log=error

ls -la "${OUT}.om"
echo "ATC OK: ${OUT}.om"
