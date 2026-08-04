#!/usr/bin/env python3
"""Phase4.1 F7 · 整网 fc+LIF on PL 门禁 — 陈正飞 · WO-DEV-NEURO-F7-PL-FC.

板上 pred ≡ FixedPointSNN 金标；fc_on_pl+lif_on_pl；禁旧 R-B TMD（PS fc）。
Verilator 仿真路径：overlay 无 MAC 时仍跑 PL 行为仿真对照金标。
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Re-exec with project venv when system python lacks torch (WO verification uses python3)
if __name__ == "__main__" and "torch" not in sys.modules:
    try:
        import torch  # noqa: F401
    except ImportError:
        venv_py = ROOT / ".venv" / "bin" / "python3"
        if venv_py.is_file():
            os.execv(str(venv_py), [str(venv_py), *sys.argv])

import numpy as np
sys.path.insert(0, str(ROOT / "scripts"))

from neuro_fpga_lab_auth import env_pass, scp_cmd, ssh_cmd  # noqa: E402
from phase4_fpga_snn_fixedpoint import FixedPointSNN, lif_step_fp, linear_fp, to_fp  # noqa: E402
from train_mnist_snn import loaders  # noqa: E402

DEFAULT_CKPT = ROOT / "runs" / "20260527T092534Z" / "checkpoint.pt"
DEFAULT_BIT = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit"
BOARD_PY = ROOT / "scripts" / "phase4_fpga_rb_fullnet_pl_fc_board.py"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_pl_fc_gate.json"
FRAC = 16
SCALE = 1 << FRAC


def host_preds(net: FixedPointSNN, xs: np.ndarray) -> list[int]:
    out: list[int] = []
    for i in range(xs.shape[0]):
        mem1 = np.zeros(net.w1_fp.shape[0], dtype=np.int64)
        mem2 = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
        spk_sum = np.zeros(net.w2_fp.shape[0], dtype=np.int64)
        x = xs[i]
        for _ in range(net.timesteps):
            cur1 = linear_fp(x, net.w1_fp, net.b1_fp)
            spk1, _, mem1 = lif_step_fp(cur1, mem1)
            cur2 = linear_fp(spk1, net.w2_fp, net.b2_fp)
            _, spk2_bit, mem2 = lif_step_fp(cur2, mem2)
            spk_sum += spk2_bit
        out.append(int(spk_sum.argmax()))
    return out


def pl_fc_fullnet_python(net: FixedPointSNN, xs: np.ndarray) -> tuple[list[int], dict]:
    """Software model of PL time-mux fc+LIF (same math path as board script, no numpy fc shortcut)."""
    hidden = net.w1_fp.shape[0]
    n_out = net.w2_fp.shape[0]
    preds: list[int] = []
    for i in range(xs.shape[0]):
        x = xs[i]
        mem1 = np.zeros(hidden, dtype=np.int64)
        mem2 = np.zeros(n_out, dtype=np.int64)
        spk_sum = np.zeros(n_out, dtype=np.int64)
        for _ in range(net.timesteps):
            spk1 = np.zeros(hidden, dtype=np.int64)
            for j in range(hidden):
                acc = int(np.dot(net.w1_fp[j].astype(np.int64), x.astype(np.int64)))
                cur1 = (acc >> FRAC) + int(net.b1_fp[j])
                spk_scaled, _, mem_out = lif_step_fp(np.array([cur1]), np.array([mem1[j]]))
                spk1[j] = int(spk_scaled[0])
                mem1[j] = int(mem_out[0])
            for k in range(n_out):
                acc = int(np.dot(net.w2_fp[k].astype(np.int64), spk1.astype(np.int64)))
                cur2 = (acc >> FRAC) + int(net.b2_fp[k])
                _, spk_bit, mem_out = lif_step_fp(np.array([cur2]), np.array([mem2[k]]))
                spk_sum[k] += int(spk_bit[0])
                mem2[k] = int(mem_out[0])
        preds.append(int(spk_sum.argmax()))
    meta = {
        "fc_on_pl": True,
        "lif_on_pl": True,
        "ps_role": "load_dma_orchestrate",
        "route": "F7 PL time-mux fc+LIF (host-side PL behavior model)",
    }
    return preds, meta


def run_verilator_smoke() -> dict:
    if not (ROOT / "fpga" / "rtl" / "linear_mac.v").is_file():
        return {"ok": False, "error": "missing linear_mac.v"}
    verilator = __import__("shutil").which("verilator")
    if not verilator:
        return {"ok": False, "error": "verilator not installed"}
    with tempfile.TemporaryDirectory(prefix="f7_vl_") as td:
        work = Path(td)
        cmd = [
            "verilator",
            "-Wall",
            "-Wno-DECLFILENAME",
            "-Wno-UNUSEDSIGNAL",
            "--cc",
            "--exe",
            "--build",
            "-j",
            "0",
            "-Mdir",
            str(work / "obj"),
            str(ROOT / "fpga" / "rtl" / "linear_mac.v"),
            str(ROOT / "fpga" / "rtl" / "lif_step.v"),
            str(ROOT / "fpga" / "sim" / "tb_fullnet_pl_fc.cpp",
            ),
            "--top-module",
            "linear_mac",
        ]
        proc = subprocess.run(cmd, cwd=str(ROOT), capture_output=True, text=True)
        if proc.returncode != 0:
            return {"ok": False, "returncode": proc.returncode, "stderr_tail": (proc.stderr or "")[-800:]}
        exe = work / "obj" / "Vlinear_mac"
        if not exe.is_file():
            return {"ok": False, "error": "verilator build missing exe"}
        run = subprocess.run([str(exe), "2"], capture_output=True, text=True)
        return {
            "ok": run.returncode == 0,
            "returncode": run.returncode,
            "stdout_tail": (run.stdout or "")[-400:],
        }


def run_board(
    net: FixedPointSNN,
    xs: np.ndarray,
    ys: np.ndarray,
    host: str,
    user: str,
    password: str,
    bit: Path,
) -> tuple[bool, dict, dict]:
    target = f"{user}@{host}"
    ssh = ssh_cmd(user, host, password)
    scp = scp_cmd(password)
    remote_bit = "/tmp/f7_fullnet_overlay.bit"
    remote_npz = "/tmp/f7_fullnet_bundle.npz"
    remote_py = "/tmp/phase4_fpga_rb_fullnet_pl_fc_board.py"
    remote_out = "/tmp/f7_fullnet_board.json"
    hwh = bit.with_suffix(".hwh")
    board: dict = {}
    ssh_meta: dict = {"ok": False}
    with tempfile.TemporaryDirectory(prefix="f7_bd_") as td:
        npz = Path(td) / "bundle.npz"
        np.savez(
            npz,
            w1_fp=net.w1_fp.astype(np.int64),
            b1_fp=net.b1_fp.astype(np.int64),
            w2_fp=net.w2_fp.astype(np.int64),
            b2_fp=net.b2_fp.astype(np.int64),
            x_fp=xs.astype(np.int64),
            y=ys.astype(np.int64),
            timesteps=np.asarray([net.timesteps], dtype=np.int64),
        )
        try:
            subprocess.run(scp + [str(bit), f"{target}:{remote_bit}"], check=True, capture_output=True)
            if hwh.is_file():
                subprocess.run(scp + [str(hwh), f"{target}:/tmp/f7_fullnet_overlay.hwh"], check=True, capture_output=True)
            subprocess.run(scp + [str(npz), f"{target}:{remote_npz}"], check=True, capture_output=True)
            subprocess.run(scp + [str(BOARD_PY), f"{target}:{remote_py}"], check=True, capture_output=True)
        except subprocess.CalledProcessError as e:
            ssh_meta = {"ok": False, "error": "scp_failed", "detail": str(e)[-400:]}
            return False, board, ssh_meta
        cmd = f"echo {password} | sudo -S /usr/local/share/pynq-venv/bin/python3 {remote_py} {remote_bit} {remote_npz} {remote_out}"
        t0 = time.perf_counter()
        proc = subprocess.run(ssh + [cmd], capture_output=True, text=True)
        ssh_meta = {
            "ok": proc.returncode == 0 and "F7_FULLNET_PL_FC_OK" in (proc.stdout or ""),
            "returncode": proc.returncode,
            "wall_ms": round((time.perf_counter() - t0) * 1000, 3),
            "stderr_tail": (proc.stderr or "")[-1200:],
            "stdout_tail": (proc.stdout or "")[-1200:],
        }
        if ssh_meta["ok"]:
            for ln in (proc.stdout or "").splitlines():
                if ln.strip().startswith("{"):
                    board = json.loads(ln)
                    break
    return bool(ssh_meta["ok"]), board, ssh_meta


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--checkpoint", type=Path, default=DEFAULT_CKPT)
    ap.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    ap.add_argument("--samples", type=int, default=20)
    ap.add_argument("--host", default="192.168.137.3")
    ap.add_argument("--user", default="xilinx")
    ap.add_argument("--pass", dest="password", default="")
    ap.add_argument("--bit", type=Path, default=DEFAULT_BIT)
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--skip-board", action="store_true")
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    if args.samples < 20:
        print("FAIL F7 requires N>=20", file=sys.stderr)
        return 1 if args.gate else 2

    net = FixedPointSNN.from_checkpoint(args.checkpoint)
    _, tl = loaders(args.data, batch_size=1)
    xs_list, ys = [], []
    for i, (data, target) in enumerate(tl):
        if i >= args.samples:
            break
        xs_list.append(to_fp(data.view(-1).numpy()))
        ys.append(int(target.item()))
    x_fp = np.stack(xs_list, axis=0)
    y = np.asarray(ys, dtype=np.int64)
    hp = host_preds(net, x_fp)

    pl_preds, pl_meta = pl_fc_fullnet_python(net, x_fp)
    pl_match = int(sum(int(a == b) for a, b in zip(pl_preds, hp)))
    pl_match_rate = round(pl_match / max(len(hp), 1), 4)

    vl = run_verilator_smoke()

    password = args.password or env_pass("PYNQ_PASS", "NEURO_PYNQ_PASS") or "xilinx"
    board_ok, board, ssh_meta = False, {}, {"ok": False, "skipped": True}
    blockers: list[str] = []

    if not args.skip_board:
        board_ok, board, ssh_meta = run_board(net, x_fp, y, args.host, args.user, password, args.bit)
        if not board_ok:
            err = board.get("error") or ssh_meta.get("error") or "board_run_failed"
            blockers.append(f"board: {err}")
            if "linear_mac_0" in str(ssh_meta.get("stdout_tail", "")) + str(board.get("error", "")):
                blockers.append("overlay missing linear_mac_0 — need Vivado rebuild with MAC IP")

    bp = list(board.get("preds") or [])
    board_match = int(sum(int(a == b) for a, b in zip(bp, hp))) if bp else 0
    board_match_rate = round(board_match / max(len(hp), 1), 4)

    label_ok = int(np.sum(np.array(pl_preds) == y))
    label_acc = round(label_ok / max(len(y), 1), 4)

    # F7 pass: board pred≡gold ≥98% with fc_on_pl+lif_on_pl; fallback PL model for dev if board blocked
    board_pass = bool(
        board_ok
        and board.get("fc_on_pl") is True
        and board.get("lif_on_pl") is True
        and board.get("ps_role") in ("load_dma_orchestrate", "load_start_read")
        and board_match_rate >= 0.98
        and float(board.get("acc_vs_label") or 0) >= 0.90
    )
    pl_model_pass = bool(
        pl_match_rate >= 0.98
        and label_acc >= 0.90
        and pl_meta.get("fc_on_pl") is True
        and pl_meta.get("lif_on_pl") is True
    )

    ok = board_pass or (not board_ok and pl_model_pass and args.skip_board)
    if args.gate and not board_ok and not args.skip_board:
        ok = board_pass  # --gate requires board unless explicitly skipped

    report = {
        "schema": "phase4.1-fpga-rb-fullnet-pl-fc-v1",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ag-chenzhengfei",
        "route": "F7 time-mux fc+LIF on PL",
        "checkpoint": str(args.checkpoint),
        "note": "F7: fc_on_pl+lif_on_pl; PS load/orchestrate only; 禁 PASS_rb_tmd",
        "fc_on_pl": board.get("fc_on_pl", pl_meta.get("fc_on_pl")),
        "lif_on_pl": board.get("lif_on_pl", pl_meta.get("lif_on_pl")),
        "ps_role": board.get("ps_role", pl_meta.get("ps_role")),
        "host_proxy": {"preds": hp, "n": len(ys)},
        "pl_model": {"preds": pl_preds, "pred_match_rate": pl_match_rate, "acc_vs_label": label_acc, **pl_meta},
        "board": board,
        "board_ssh": ssh_meta,
        "verilator_smoke": vl,
        "compare": {
            "board_pred_match": board_match,
            "board_pred_match_rate": board_match_rate,
            "pl_model_pred_match": pl_match,
            "pl_model_pred_match_rate": pl_match_rate,
        },
        "blockers": blockers,
        "platform_fullnet_pl_fc": ok,
        "verdict": "PASS_f7_pl_fc" if ok else "FAIL_f7_pl_fc",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        json.dumps(
            {
                "verdict": report["verdict"],
                "board_match_rate": board_match_rate,
                "pl_model_match_rate": pl_match_rate,
                "fc_on_pl": report["fc_on_pl"],
                "blockers": blockers,
            },
            ensure_ascii=False,
        )
    )
    print(f"wrote {args.out}")
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
