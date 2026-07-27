#!/usr/bin/env python3
"""Phase4.1 · R-A（FPGA 加速 / M-lif）平台可用性门禁 — 陈正共.

切分假说：Atlas/host 跑 fc1/fc2；FPGA 角色 = lif1（hidden 维 LIF 步进）。
本脚本两档：
  --mode host_proxy  用与 RTL 同语义的 Q16.16 lif_step 在 host 模拟「卸到 FPGA 的 lif1」
                     （算法/切分账；**不算**板上平台可用）
  --mode board_pl    要求 fpga/bitstreams/lif_step_overlay.bit，经 SSH 调 PYNQ 跑单神经元序列
                     （单算子 PL 平台可用；整层向量化仍待后续）

输出 JSON 供 §4 对照表与总裁一页汇总。
"""
from __future__ import annotations

import argparse
import json
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

import numpy as np
import torch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from phase4_fpga_snn_fixedpoint import (  # noqa: E402
    FixedPointSNN,
    FRAC,
    SCALE,
    linear_fp,
    lif_step_fp,
    to_fp,
)
from train_mnist_snn import loaders  # noqa: E402

# Phase4 PoC 真源权重（勿用 mtime 最新：fewshot/trackB 可能语义不同）
DEFAULT_CKPT = ROOT / "runs" / "20260527T092534Z" / "checkpoint.pt"


def resolve_checkpoint(explicit: Path | None) -> Path:
    if explicit is not None:
        return explicit
    if DEFAULT_CKPT.is_file():
        return DEFAULT_CKPT
    runs = sorted((ROOT / "runs").glob("*/checkpoint.pt"))
    if not runs:
        raise FileNotFoundError("no checkpoint.pt under runs/")
    return runs[-1]


def forward_mlif_host_proxy(net: FixedPointSNN, x_fp: np.ndarray) -> np.ndarray:
    """fc1 → lif1(host=FPGA角色) → fc2 → lif2；与整网定点同语义。"""
    mem1 = np.zeros(net.w1_fp.shape[0], dtype=np.int64)
    mem2 = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
    spk_sum = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
    for _ in range(net.timesteps):
        cur1 = linear_fp(x_fp, net.w1_fp, net.b1_fp)
        spk1, _, mem1 = lif_step_fp(cur1, mem1)  # ← M-lif 卸出点
        cur2 = linear_fp(spk1, net.w2_fp, net.b2_fp)
        _, spk2_bit, mem2 = lif_step_fp(cur2, mem2)
        spk_sum += spk2_bit
    return spk_sum


def eval_proxy(net: FixedPointSNN, n: int, data_dir: Path) -> dict:
    _, test_loader = loaders(data_dir, batch_size=1)
    correct = 0
    t0 = time.perf_counter()
    for i, (data, target) in enumerate(test_loader):
        if i >= n:
            break
        x = data.view(-1).numpy()
        x_fp = to_fp(x)
        pred = int(forward_mlif_host_proxy(net, x_fp).argmax())
        correct += int(pred == int(target.item()))
    elapsed = time.perf_counter() - t0
    return {
        "n": n,
        "correct": correct,
        "acc": round(correct / max(n, 1), 4),
        "avg_e2e_ms": round(elapsed * 1000 / max(n, 1), 3),
        "split": "M-lif: host_proxy runs lif1 with Q16.16≡RTL semantics; fc* on host",
    }


def board_pl_smoke(bit: Path, host: str, password: str, out_run: Path) -> dict:
    """委托既有 phase4_fpga_pynq_lif_pl.py。"""
    import subprocess

    script = ROOT / "scripts" / "phase4_fpga_pynq_lif_pl.py"
    if not bit.is_file():
        return {
            "ok": False,
            "blocker": f"missing bitstream: {bit}",
            "platform_available": False,
        }
    proc = subprocess.run(
        [
            sys.executable,
            str(script),
            "--host",
            host,
            "--pass",
            password,
            "--bit",
            str(bit),
            "--out",
            str(out_run),
        ],
        capture_output=True,
        text=True,
    )
    payload = {
        "ok": proc.returncode == 0,
        "returncode": proc.returncode,
        "stdout_tail": (proc.stdout or "")[-500:],
        "stderr_tail": (proc.stderr or "")[-500:],
        "run_json": str(out_run) if out_run.is_file() else None,
    }
    if out_run.is_file():
        try:
            payload["run"] = json.loads(out_run.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            pass
    payload["platform_available"] = bool(payload["ok"])
    payload["note"] = (
        "board_pl 仅验证单神经元 lif_step IP 上 PL；"
        "hidden=256 向量化 LIF 层仍未实现——R-A「整层入链」需后续 bitstream"
    )
    return payload


def main() -> int:
    ap = argparse.ArgumentParser(description="R-A M-lif platform gate")
    ap.add_argument("--mode", choices=("host_proxy", "board_pl", "both"), default="both")
    ap.add_argument("--checkpoint", type=Path, default=None)
    ap.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    ap.add_argument("--samples", type=int, default=100)
    ap.add_argument("--host", default="192.168.137.3")
    ap.add_argument("--pass", dest="password", default="xilinx")
    ap.add_argument(
        "--bit",
        type=Path,
        default=ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "docs" / "phase4_poc_evidence" / "fpga_ra_mlif_platform_gate.json",
    )
    args = ap.parse_args()

    try:
        ckpt = resolve_checkpoint(args.checkpoint)
    except FileNotFoundError as e:
        print(e, file=sys.stderr)
        return 2

    report: dict = {
        "schema": "phase4.1-fpga-ra-mlif-platform-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "route": "R-A FPGA accelerate M-lif",
        "checkpoint": str(ckpt),
        "mode": args.mode,
    }

    if args.mode in ("host_proxy", "both"):
        net = FixedPointSNN.from_checkpoint(ckpt)
        report["host_proxy"] = eval_proxy(net, args.samples, args.data)
        # host_proxy 本身不是板上平台；仅记切分账是否达标
        report["host_proxy"]["platform_available"] = False
        report["host_proxy"]["verdict"] = (
            "split_logic_ok"
            if report["host_proxy"]["acc"] >= 0.90
            else "split_logic_accuracy_fail"
        )

    if args.mode in ("board_pl", "both"):
        run_path = ROOT / "runs" / "phase4_poc" / "fpga_lif_pl_run_ra.json"
        run_path.parent.mkdir(parents=True, exist_ok=True)
        report["board_pl"] = board_pl_smoke(args.bit, args.host, args.password, run_path)

    # 路线级结论：板上单算子通才算「加速平台可用」的最低条；host_proxy 只是切分账
    bp = report.get("board_pl") or {}
    hp = report.get("host_proxy") or {}
    report["platform_available_ra"] = bool(bp.get("platform_available"))
    report["summary"] = {
        "host_proxy_acc": hp.get("acc"),
        "board_pl_ok": bp.get("ok"),
        "blocker": None
        if report["platform_available_ra"]
        else (bp.get("blocker") or "bitstream_or_board_pl_fail"),
    }

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report["summary"], ensure_ascii=False))
    print(f"wrote {args.out}")
    return 0 if hp.get("acc", 1) >= 0.90 or args.mode == "board_pl" else 1


if __name__ == "__main__":
    raise SystemExit(main())
