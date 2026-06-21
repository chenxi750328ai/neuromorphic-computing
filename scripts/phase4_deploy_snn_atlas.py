#!/usr/bin/env python3
"""本机推送真 SNN ONNX 到 Atlas 并执行 ATC+冒烟。"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_HOST = "192.168.137.2"
DEFAULT_USER = "root"
DEFAULT_PASS = "Mind@123"
WORKDIR = "/tmp/phase4_snn"


def run(cmd: list[str], capture: bool = True) -> subprocess.CompletedProcess:
    print("+", " ".join(cmd), flush=True)
    return subprocess.run(cmd, check=capture, text=True, capture_output=capture)


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--host", default=os.environ.get("ATLAS_HOST", DEFAULT_HOST))
    p.add_argument("--onnx", type=Path, default=ROOT / "runs" / "phase4_export" / "model_snn.onnx")
    p.add_argument("--skip-atc", action="store_true", help="OM 已存在时仅推理")
    args = p.parse_args()

    if not args.onnx.is_file():
        print(f"missing onnx: {args.onnx}", file=sys.stderr)
        return 2

    pw = os.environ.get("ATLAS_SSH_PASS", DEFAULT_PASS)
    target = f"{DEFAULT_USER}@{args.host}"
    ssh = ["sshpass", "-p", pw, "ssh", "-o", "StrictHostKeyChecking=no", target]
    scp = ["sshpass", "-p", pw, "scp", "-o", "StrictHostKeyChecking=no"]

    run(ssh + [f"mkdir -p {WORKDIR}"])
    for local, remote in (
        (args.onnx, f"{WORKDIR}/model_snn.onnx"),
        (ROOT / "scripts/phase4_atlas_snn_smoke.py", f"{WORKDIR}/phase4_atlas_snn_smoke.py"),
        (ROOT / "scripts/phase4_atlas_snn_smoke.sh", f"{WORKDIR}/phase4_atlas_snn_smoke.sh"),
    ):
        run(scp + [str(local), f"{target}:{remote}"])

    remote_cmd = (
        f"chmod +x {WORKDIR}/phase4_atlas_snn_smoke.sh && "
        f"export SKIP_ATC={'1' if args.skip_atc else '0'}; "
        f"if [[ $SKIP_ATC == 1 ]]; then "
        f"source /usr/local/Ascend/ascend-toolkit/set_env.sh && "
        f"export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:\\$PYTHONPATH && "
        f"python3 {WORKDIR}/phase4_atlas_snn_smoke.py --model {WORKDIR}/mnist_snn.om; "
        f"else {WORKDIR}/phase4_atlas_snn_smoke.sh {WORKDIR}; fi"
    )
    proc = run(ssh + [remote_cmd])

    log = ROOT / "runs" / "phase4_poc" / "atlas_snn_smoke.log"
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_text(
        f"# Atlas SNN smoke {datetime.now(timezone.utc).isoformat()}\n"
        f"host={args.host}\nonnx={args.onnx}\n\n{proc.stdout}\n{proc.stderr}\n",
        encoding="utf-8",
    )
    print(f"log: {log}")
    return 0 if "PASS" in proc.stdout else 1


if __name__ == "__main__":
    raise SystemExit(main())
