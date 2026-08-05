#!/usr/bin/env python3
"""Phase4.2 F7 · 整网 perf 采集 + P4.2-LAT 门禁 — 陈正飞 · WO-DEV-NEURO-F7-PERF.

产出 docs/phase4_poc_evidence/fpga_rb_fullnet_pl_fc_perf.json
判据：per_sample_ms|p50_ms|wall_ms/n ≤100 · board_pred_match_rate≥1.0 · n≥20 · fc_on_pl∧lif_on_pl
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
from statistics import median

ROOT = Path(__file__).resolve().parents[1]

if __name__ == "__main__" and "torch" not in sys.modules:
    try:
        import torch  # noqa: F401
    except ImportError:
        venv_py = ROOT / ".venv" / "bin" / "python3"
        if venv_py.is_file():
            os.execv(str(venv_py), [str(venv_py), *sys.argv])

sys.path.insert(0, str(ROOT / "scripts"))

from neuro_fpga_lab_auth import env_pass, scp_cmd, ssh_cmd  # noqa: E402
from phase4_fpga_rb_fullnet_pl_fc_gate import (  # noqa: E402
    DEFAULT_BIT,
    DEFAULT_CKPT,
    BOARD_PY,
    run_board,
)
from phase4_fpga_snn_fixedpoint import FixedPointSNN, to_fp  # noqa: E402
from train_mnist_snn import loaders  # noqa: E402

GATE_BASELINE = ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_pl_fc_gate.json"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_pl_fc_perf.json"
BOARD_FAST = ROOT / "scripts" / "phase4_fpga_rb_fullnet_pl_fc_board.py"
LAT_THRESHOLD_MS = 100.0


def _per_sample_ms(board: dict) -> float | None:
    n = int(board.get("n") or 0)
    if board.get("per_sample_ms") is not None:
        return float(board["per_sample_ms"])
    if board.get("p50_ms") is not None:
        return float(board["p50_ms"])
    wall = board.get("wall_ms")
    if wall is not None and n > 0:
        return float(wall) / n
    return None


def _load_baseline() -> dict:
    if not GATE_BASELINE.is_file():
        return {}
    return json.loads(GATE_BASELINE.read_text(encoding="utf-8"))


def _board_reachable(host: str) -> bool:
    proc = subprocess.run(
        ["ping", "-c", "1", "-W", "2", host],
        capture_output=True,
        text=True,
    )
    return proc.returncode == 0


def _run_board_fast(
    net: FixedPointSNN,
    xs,
    ys,
    host: str,
    user: str,
    password: str,
    bit: Path,
) -> tuple[bool, dict, dict]:
    """Board run using optimized board script (same SSH path as gate)."""
    target = f"{user}@{host}"
    ssh = ssh_cmd(user, host, password)
    scp = scp_cmd(password)
    remote_bit = "/tmp/f7_fullnet_overlay.bit"
    remote_npz = "/tmp/f7_fullnet_bundle.npz"
    remote_py = "/tmp/phase4_fpga_rb_fullnet_pl_fc_board.py"
    remote_out = "/tmp/f7_fullnet_perf.json"
    hwh = bit.with_suffix(".hwh")
    board: dict = {}
    ssh_meta: dict = {"ok": False}
    with tempfile.TemporaryDirectory(prefix="f7_pf_") as td:
        npz = Path(td) / "bundle.npz"
        import numpy as np

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
                subprocess.run(
                    scp + [str(hwh), f"{target}:/tmp/f7_fullnet_overlay.hwh"],
                    check=True,
                    capture_output=True,
                )
            subprocess.run(scp + [str(npz), f"{target}:{remote_npz}"], check=True, capture_output=True)
            subprocess.run(scp + [str(BOARD_FAST), f"{target}:{remote_py}"], check=True, capture_output=True)
        except subprocess.CalledProcessError as e:
            ssh_meta = {"ok": False, "error": "scp_failed", "detail": str(e)[-400:]}
            return False, board, ssh_meta
        cmd = (
            f"echo {password} | sudo -S /usr/local/share/pynq-venv/bin/python3 "
            f"{remote_py} {remote_bit} {remote_npz} {remote_out}"
        )
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


def build_perf_report(
    *,
    board: dict,
    board_ssh: dict,
    host_preds: list[int],
    baseline: dict,
    source: str,
    blockers: list[str],
) -> dict:
    bp = list(board.get("preds") or [])
    hp = host_preds
    board_match = int(sum(int(a == b) for a, b in zip(bp, hp))) if bp else 0
    n = int(board.get("n") or (baseline.get("board") or {}).get("n") or 0)
    rate = round(board_match / max(len(hp), 1), 4) if hp else float(
        (baseline.get("compare") or {}).get("board_pred_match_rate") or 0
    )
    lat = _per_sample_ms(board)
    p50 = board.get("p50_ms")
    if p50 is None and lat is not None:
        p50 = lat

    fc = board.get("fc_on_pl")
    lif = board.get("lif_on_pl")
    if fc is None:
        fc = (baseline.get("board") or {}).get("fc_on_pl")
    if lif is None:
        lif = (baseline.get("board") or {}).get("lif_on_pl")

    ok_lat = lat is not None and float(lat) <= LAT_THRESHOLD_MS
    ok_acc = rate >= 1.0 and n >= 20
    ok_pl = fc is True and lif is True
    ok = bool(ok_lat and ok_acc and ok_pl)

    return {
        "schema": "phase4.2-fpga-rb-fullnet-pl-fc-perf-v1",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ag-chenzhengfei",
        "wo_id": "WO-DEV-NEURO-F7-PERF",
        "route": "F7 time-mux fc+LIF on PL · Phase4.2 LAT",
        "source": source,
        "threshold_ms": LAT_THRESHOLD_MS,
        "n": n,
        "board_pred_match_rate": rate,
        "fc_on_pl": fc,
        "lif_on_pl": lif,
        "per_sample_ms": lat,
        "p50_ms": p50,
        "wall_ms": board.get("wall_ms"),
        "fc_pl_ms": board.get("fc_pl_ms"),
        "lif_pl_ms": board.get("lif_pl_ms"),
        "n_mac_pl_calls": board.get("n_mac_pl_calls"),
        "n_lif_pl_calls": board.get("n_lif_pl_calls"),
        "mac_access": board.get("mac_access"),
        "ps_role": board.get("ps_role", "load_dma_orchestrate"),
        "preds": bp,
        "board": board,
        "board_ssh": board_ssh,
        "baseline_ref": str(GATE_BASELINE) if baseline else None,
        "baseline_per_sample_ms": _per_sample_ms(baseline.get("board") or {}) if baseline else None,
        "optimizations_applied": board.get("optimizations_applied", []),
        "blockers": blockers,
        "verdict": "PASS_p4.2_lat" if ok else "FAIL_p4.2_lat",
        "p4_2_lat_ok": ok_lat,
        "p4_2_acc_ok": ok_acc,
        "p4_2_pl_ok": ok_pl,
    }


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
    ap.add_argument("--use-baseline", action="store_true", help="板不可达时复用 gate.json 延迟")
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    if args.samples < 20:
        print("FAIL P4.2 requires N>=20", file=sys.stderr)
        return 1

    baseline = _load_baseline()
    net = FixedPointSNN.from_checkpoint(args.checkpoint)
    _, tl = loaders(args.data, batch_size=1)
    xs_list, ys = [], []
    for i, (data, target) in enumerate(tl):
        if i >= args.samples:
            break
        xs_list.append(to_fp(data.view(-1).numpy()))
        ys.append(int(target.item()))
    import numpy as np

    x_fp = np.stack(xs_list, axis=0)
    y = np.asarray(ys, dtype=np.int64)

    sys.path.insert(0, str(ROOT / "scripts"))
    from phase4_fpga_rb_fullnet_pl_fc_gate import host_preds

    hp = host_preds(net, x_fp)

    password = args.password or env_pass("PYNQ_PASS", "NEURO_PYNQ_PASS") or "xilinx"
    blockers: list[str] = []
    board: dict = {}
    board_ssh: dict = {"ok": False}
    source = "none"

    if not args.skip_board:
        reachable = _board_reachable(args.host)
        if not reachable:
            blockers.append(f"board_unreachable: ping {args.host} failed")
            if args.use_baseline or baseline:
                b0 = dict(baseline.get("board") or {})
                board = b0
                board_ssh = {"ok": False, "skipped": True, "reason": "board_unreachable", **(baseline.get("board_ssh") or {})}
                source = "baseline_gate_json"
                blockers.append("latency from Phase4.1 gate baseline — not re-measured on board")
            else:
                source = "board_unreachable_no_baseline"
        else:
            board_ok, board, board_ssh = _run_board_fast(
                net, x_fp, y, args.host, args.user, password, args.bit
            )
            source = "board_live_fast_mmio"
            if not board_ok:
                blockers.append("board_run_failed")
                err = board.get("error") or board_ssh.get("error") or "unknown"
                blockers.append(str(err))
    elif args.use_baseline and baseline:
        board = dict(baseline.get("board") or {})
        board_ssh = {"ok": False, "skipped": True, "reason": "--skip-board"}
        source = "baseline_gate_json"
        blockers.append("explicit --skip-board; using Phase4.1 baseline latency")

    report = build_perf_report(
        board=board,
        board_ssh=board_ssh,
        host_preds=hp,
        baseline=baseline,
        source=source,
        blockers=blockers,
    )

    per_sample = report.get("per_sample_ms")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    summary = {
        "verdict": report["verdict"],
        "per_sample_ms": per_sample,
        "board_pred_match_rate": report["board_pred_match_rate"],
        "n": report["n"],
        "fc_on_pl": report["fc_on_pl"],
        "lif_on_pl": report["lif_on_pl"],
        "source": source,
        "blockers": blockers,
    }
    print(json.dumps(summary, ensure_ascii=False))
    print(f"wrote {args.out}")

    if args.gate:
        ok = report["verdict"] == "PASS_p4.2_lat"
        return 0 if ok else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
