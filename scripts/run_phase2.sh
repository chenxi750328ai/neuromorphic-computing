#!/usr/bin/env bash
# Phase 2：MNIST ANN 基线（陈正共）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
if [[ ! -x .venv/bin/python ]]; then
  python3 -m venv .venv
  .venv/bin/pip install --default-timeout=300 torch torchvision --index-url https://download.pytorch.org/whl/cu124
  .venv/bin/pip install --default-timeout=300 snntorch
fi
exec .venv/bin/python scripts/train_mnist_ann.py --seed 42 --epochs 10 --batch-size 256 "$@"
