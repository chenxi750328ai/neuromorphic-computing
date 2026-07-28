#!/usr/bin/env python3
"""Phase4.1 · R-B（FPGA 跑整网）平台可用性门禁 — 陈正共.

两段证据：
  1) 算法：WSL Q16.16 整网定点精度（证明「整网定点语义」可跑，非板上）
  2) 资源：用已测单神经元 LUT 外推 hidden×timesteps 并行实例 → 是否塞进 PYNQ-Z2

若资源墙成立，结论合法写 platform_available=false（本板不可用），避免长线白搞。
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from phase4_fpga_snn_fixedpoint import FixedPointSNN, to_fp  # noqa: E402
from train_mnist_snn import loaders  # noqa: E402

# PYNQ-Z2 XC7Z020 粗算可用逻辑（保守）
Z2_LUT_BUDGET = 53200
Z2_BRAM_BUDGET = 140  # 36Kb blocks approx
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


def parse_util_luts(rpt: Path) -> int | None:
    if not rpt.is_file():
        return None
    text = rpt.read_text(encoding="utf-8", errors="ignore")
    # Vivado utilization often has "| CLB LUTs*                   |  379 |"
    m = re.search(r"CLB LUTs\S*\s*\|\s*(\d+)", text)
    if m:
        return int(m.group(1))
    m = re.search(r"Slice LUTs\s*\|\s*(\d+)", text)
    if m:
        return int(m.group(1))
    return None


def eval_fixedpoint_fullnet(ckpt: Path, n: int, data_dir: Path) -> dict:
    net = FixedPointSNN.from_checkpoint(ckpt)
    _, test_loader = loaders(data_dir, batch_size=1)
    correct = 0
    t0 = time.perf_counter()
    for i, (data, target) in enumerate(test_loader):
        if i >= n:
            break
        x_fp = to_fp(data.view(-1).numpy())
        pred = int(net.forward(x_fp).argmax())
        correct += int(pred == int(target.item()))
    elapsed = time.perf_counter() - t0
    return {
        "n": n,
        "correct": correct,
        "acc": round(correct / max(n, 1), 4),
        "avg_e2e_ms_host": round(elapsed * 1000 / max(n, 1), 3),
        "hidden": int(net.w1_fp.shape[0]),
        "timesteps": int(net.timesteps),
        "note": "host Q16.16 full net — not on PL",
    }


def resource_wall(hidden: int, timesteps: int, lut_per_neuron: int) -> dict:
    # 并行实例：每个 hidden 神经元一个 lif_step → 明显超 Z2
    lut_parallel = lut_per_neuron * hidden
    # 时分复用：单实例反复喂 256 神经元 × 25 tick —— 逻辑上可塞，但吞吐/延迟另账
    lut_tmd = lut_per_neuron
    return {
        "lut_per_neuron_measured_or_assumed": lut_per_neuron,
        "hidden": hidden,
        "timesteps": timesteps,
        "parallel_instances_lut": lut_parallel,
        "z2_lut_budget": Z2_LUT_BUDGET,
        "parallel_fits_z2": lut_parallel <= Z2_LUT_BUDGET,
        "time_mux_single_core_lut": lut_tmd,
        "time_mux_fits_z2": lut_tmd <= Z2_LUT_BUDGET,
        "verdict": (
            "fullnet_parallel_not_on_z2"
            if lut_parallel > Z2_LUT_BUDGET
            else "fullnet_parallel_possible"
        ),
        "note": (
            "并行整网 LIF 阵列按单核 LUT×hidden 外推；"
            "时分复用理论上 LUT 够，但需新 RTL 调度器+权重 BRAM，本闸记为「本板并行整网不可用」"
        ),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--checkpoint", type=Path, default=None)
    ap.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    ap.add_argument("--samples", type=int, default=100)
    ap.add_argument(
        "--util-rpt",
        type=Path,
        default=ROOT / "fpga" / "bitstreams" / "lif_step_utilization.rpt",
    )
    ap.add_argument(
        "--assume-lut-per-neuron",
        type=int,
        default=379,
        help="若无 utilization.rpt，用历史 E4 单核 LUT（默认 379）",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_platform_gate.json",
    )
    args = ap.parse_args()

    try:
        ckpt = resolve_checkpoint(args.checkpoint)
    except FileNotFoundError as e:
        print(e, file=sys.stderr)
        return 2

    algo = eval_fixedpoint_fullnet(ckpt, args.samples, args.data)
    lut = parse_util_luts(args.util_rpt) or args.assume_lut_per_neuron
    wall = resource_wall(algo["hidden"], algo["timesteps"], lut)

    # R-B「平台可用」：本闸对 PYNQ-Z2 要求「并行整网」——外推不过则 false
    platform_ok = bool(wall["parallel_fits_z2"]) and algo["acc"] >= 0.90

    report = {
        "schema": "phase4.1-fpga-rb-fullnet-platform-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "route": "R-B FPGA full network",
        "checkpoint": str(ckpt),
        "algorithm_host_fixedpoint": algo,
        "resource": wall,
        "platform_available_rb_on_pynq_z2_parallel": platform_ok,
        "conclusion": (
            "PASS_parallel_fullnet_on_z2"
            if platform_ok
            else "FAIL_parallel_fullnet_on_z2_resource_wall"
        ),
        "followups": [
            "若要坚持整网 FPGA：换更大器件，或实现时分复用调度 RTL（新工作量）",
            "R-A 加速（单核/少量 LIF IP）与 Z2 资源匹配，优先作为近端可行路径",
        ],
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "acc": algo["acc"],
        "parallel_fits_z2": wall["parallel_fits_z2"],
        "conclusion": report["conclusion"],
    }, ensure_ascii=False))
    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
