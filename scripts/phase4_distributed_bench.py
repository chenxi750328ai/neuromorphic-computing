#!/usr/bin/env python3
"""Phase4.1 · WSL↔Atlas 双跳链路 bench（分段计时 · 陈正共）。"""
from __future__ import annotations

import argparse
import json
import socket
import struct
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from train_mnist_snn import loaders  # noqa: E402


def _ssh_cmd(host: str, password: str, remote: str) -> list[str]:
    return [
        "sshpass",
        "-p",
        password,
        "ssh",
        "-o",
        "StrictHostKeyChecking=no",
        f"root@{host}",
        remote,
    ]


def _scp_cmd(host: str, password: str, local: Path, remote: str) -> list[str]:
    return [
        "sshpass",
        "-p",
        password,
        "scp",
        "-o",
        "StrictHostKeyChecking=no",
        str(local),
        f"root@{host}:{remote}",
    ]


def load_mnist_samples(data_dir: Path, n: int, offset: int = 0) -> tuple[np.ndarray, np.ndarray]:
    _, test_loader = loaders(data_dir, batch_size=1)
    xs: list[np.ndarray] = []
    ys: list[int] = []
    for i, (x, y) in enumerate(test_loader):
        if i < offset:
            continue
        xs.append(x.numpy().astype(np.float32))
        ys.append(int(y.item()))
        if len(xs) >= n:
            break
    return np.concatenate(xs, axis=0), np.asarray(ys, dtype=np.int64)


def ensure_atlas_probe(host: str, password: str, om: str) -> None:
    remote_dir = "/tmp/phase4_snn"
    subprocess.run(
        _ssh_cmd(host, password, f"mkdir -p {remote_dir}"),
        check=True,
        capture_output=True,
    )
    probe = ROOT / "scripts" / "phase4_atlas_snn_probe.py"
    subprocess.run(_scp_cmd(host, password, probe, f"{remote_dir}/phase4_atlas_snn_probe.py"), check=True)


MAGIC = b"PH41INFR"


def _daemon_infer(host: str, port: int, sample: np.ndarray, timeout: float = 30.0) -> dict:
    arr = np.ascontiguousarray(sample.astype(np.float32)).reshape(-1)
    payload = arr.tobytes()
    t0 = time.perf_counter()
    with socket.create_connection((host, port), timeout=timeout) as conn:
        conn.sendall(MAGIC + struct.pack("<I", len(payload)) + payload)
        (json_len,) = struct.unpack("<I", _recv_exact(conn, 4))
        raw = _recv_exact(conn, json_len)
    t_rtt = (time.perf_counter() - t0) * 1000
    data = json.loads(raw.decode("utf-8"))
    if not data.get("ok"):
        raise RuntimeError(data.get("error") or "daemon infer failed")
    infer_ms = float(data.get("infer_ms") or 0.0)
    return {
        "atlas_counts": data.get("atlas_counts"),
        "infer_ms": infer_ms,
        "t_rtt_ms": round(t_rtt, 3),
        "t_queue_ms": round(max(0.0, t_rtt - infer_ms), 3),
    }


def _recv_exact(conn: socket.socket, n: int) -> bytes:
    buf = bytearray()
    while len(buf) < n:
        chunk = conn.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("daemon closed")
        buf.extend(chunk)
    return bytes(buf)


def bench_daemon_sample(host: str, port: int, sample: np.ndarray, idx: int) -> dict:
    t_pre0 = time.perf_counter()
    x = np.ascontiguousarray(sample)
    t_preprocess = (time.perf_counter() - t_pre0) * 1000
    resp = _daemon_infer(host, port, x)
    t_rtt = float(resp["t_rtt_ms"])
    t_atlas = float(resp["infer_ms"])
    t_queue = float(resp["t_queue_ms"])
    return {
        "i": idx,
        "t_preprocess_ms": round(t_preprocess, 3),
        "t_xfer_in_ms": 0.0,
        "t_atlas_ms": round(t_atlas, 3),
        "t_xfer_out_ms": round(t_queue, 3),
        "t_connect_ms": round(t_queue, 3),
        "t_e2e_ms": round(t_preprocess + t_rtt, 3),
        "atlas_counts": resp.get("atlas_counts"),
        "payload_bytes": int(x.nbytes),
        "daemon": True,
    }


def bench_one_sample(
    host: str,
    password: str,
    om: str,
    sample: np.ndarray,
    work_dir: Path,
    idx: int,
) -> dict:
    remote_dir = "/tmp/phase4_snn/bench"
    local_in = work_dir / f"sample_{idx:04d}.npy"
    np.save(local_in, sample)

    t0 = time.perf_counter()
    subprocess.run(
        _scp_cmd(host, password, local_in, f"{remote_dir}/input.npy"),
        check=True,
        capture_output=True,
    )
    t_xfer_in = (time.perf_counter() - t0) * 1000

    remote = (
        "bash -lc 'source /usr/local/Ascend/ascend-toolkit/set_env.sh && "
        "export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH && "
        f"python3 {remote_dir}/../phase4_atlas_snn_probe.py --model {om} "
        f"--input {remote_dir}/input.npy'"
    )
    t1 = time.perf_counter()
    proc = subprocess.run(_ssh_cmd(host, password, remote), capture_output=True, text=True)
    t_ssh = (time.perf_counter() - t1) * 1000
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr or proc.stdout or "atlas ssh failed")
    line = next(ln for ln in proc.stdout.splitlines() if ln.strip().startswith("{"))
    atlas_payload = json.loads(line)
    t_atlas = float(atlas_payload.get("infer_ms") or 0.0)
    t_xfer_out = max(0.0, t_ssh - t_atlas)

    return {
        "i": idx,
        "t_xfer_in_ms": round(t_xfer_in, 3),
        "t_atlas_ms": round(t_atlas, 3),
        "t_xfer_out_ms": round(t_xfer_out, 3),
        "t_ssh_ms": round(t_ssh, 3),
        "t_e2e_ms": round(t_xfer_in + t_ssh, 3),
        "atlas_counts": atlas_payload.get("atlas_counts"),
        "payload_bytes": int(local_in.stat().st_size),
    }


def dry_run_samples(xs: np.ndarray, onnx_path: Path) -> list[dict]:
    import onnxruntime as ort

    sess = ort.InferenceSession(str(onnx_path), providers=["CPUExecutionProvider"])
    rows = []
    for i in range(xs.shape[0]):
        t0 = time.perf_counter()
        x = np.ascontiguousarray(xs[i : i + 1])
        t_pre = (time.perf_counter() - t0) * 1000
        t1 = time.perf_counter()
        out = sess.run(None, {"input": x})[0]
        t_ort = (time.perf_counter() - t1) * 1000
        rows.append(
            {
                "i": i,
                "t_preprocess_ms": round(t_pre, 3),
                "t_xfer_in_ms": 0.0,
                "t_atlas_ms": round(t_ort, 3),
                "t_xfer_out_ms": 0.0,
                "t_e2e_ms": round(t_pre + t_ort, 3),
                "ort_pred": int(out[0].argmax()),
                "dry_run": True,
            }
        )
    return rows


def summarize(rows: list[dict]) -> dict:
    def avg(key: str) -> float:
        vals = [r[key] for r in rows if key in r]
        return round(float(np.mean(vals)), 3) if vals else 0.0

    def pct(key: str, q: float) -> float:
        vals = [r[key] for r in rows if key in r]
        return round(float(np.percentile(vals, q)), 3) if vals else 0.0

    t_e2e = avg("t_e2e_ms")
    if rows and rows[0].get("daemon"):
        comm = round(t_e2e - avg("t_atlas_ms") - avg("t_preprocess_ms"), 3)
    else:
        comm = avg("t_xfer_in_ms") + avg("t_xfer_out_ms")
    comm_ratio = round(comm / t_e2e, 4) if t_e2e > 0 else 0.0
    return {
        "samples": len(rows),
        "avg_t_preprocess_ms": avg("t_preprocess_ms"),
        "avg_t_xfer_in_ms": avg("t_xfer_in_ms"),
        "avg_t_atlas_ms": avg("t_atlas_ms"),
        "avg_t_xfer_out_ms": avg("t_xfer_out_ms"),
        "avg_t_connect_ms": avg("t_connect_ms"),
        "avg_t_e2e_ms": t_e2e,
        "p50_t_e2e_ms": pct("t_e2e_ms", 50),
        "p95_t_e2e_ms": pct("t_e2e_ms", 95),
        "comm_ms": round(comm, 3),
        "comm_ratio": comm_ratio,
        "bottleneck_hint": (
            "communication" if comm_ratio > 0.5 else "compute_or_balanced"
        ),
    }


def bench_batch(
    host: str,
    password: str,
    om: str,
    xs: np.ndarray,
    ys: np.ndarray,
    work_dir: Path,
) -> tuple[list[dict], dict]:
    """一次 xfer + Atlas batch 推理（对比逐帧 ssh 瓶颈）。"""
    remote_dir = "/tmp/phase4_snn/bench"
    batch_path = work_dir / "batch_inputs.npy"
    np.save(batch_path, xs)

    t0 = time.perf_counter()
    subprocess.run(
        _scp_cmd(host, password, batch_path, f"{remote_dir}/batch_inputs.npy"),
        check=True,
        capture_output=True,
    )
    t_xfer_in = (time.perf_counter() - t0) * 1000

    remote = (
        "bash -lc 'source /usr/local/Ascend/ascend-toolkit/set_env.sh && "
        "export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH && "
        f"python3 /tmp/phase4_snn/phase4_atlas_snn_probe.py --model {om} "
        f"--input {remote_dir}/batch_inputs.npy --batch'"
    )
    t1 = time.perf_counter()
    proc = subprocess.run(_ssh_cmd(host, password, remote), capture_output=True, text=True)
    t_ssh = (time.perf_counter() - t1) * 1000
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr or proc.stdout or "atlas batch ssh failed")
    line = next(ln for ln in proc.stdout.splitlines() if ln.strip().startswith("{"))
    payload = json.loads(line)
    t_atlas = float(payload.get("infer_ms") or 0.0)
    t_xfer_out = max(0.0, t_ssh - t_atlas)
    n = xs.shape[0]
    counts_all = payload.get("atlas_counts") or []

    per_sample = []
    for i in range(n):
        counts = counts_all[i] if isinstance(counts_all[0], list) else counts_all
        pred = int(np.asarray(counts).argmax())
        per_sample.append(
            {
                "i": i,
                "t_preprocess_ms": 0.0,
                "t_xfer_in_ms": round(t_xfer_in / n, 3),
                "t_atlas_ms": round(t_atlas / n, 3),
                "t_xfer_out_ms": round(t_xfer_out / n, 3),
                "t_e2e_ms": round((t_xfer_in + t_ssh) / n, 3),
                "atlas_pred": pred,
                "label": int(ys[i]),
                "pred_match": pred == int(ys[i]),
                "batch_mode": True,
            }
        )
    agg = {
        "batch_xfer_in_ms": round(t_xfer_in, 3),
        "batch_atlas_ms": round(t_atlas, 3),
        "batch_xfer_out_ms": round(t_xfer_out, 3),
        "batch_e2e_ms": round(t_xfer_in + t_ssh, 3),
        "samples": n,
    }
    return per_sample, agg


def main() -> int:
    p = argparse.ArgumentParser(description="Phase4.1 distributed bench WSL↔Atlas")
    p.add_argument("--atlas-only", action="store_true", help="G1: Atlas dual-hop MVP")
    p.add_argument("--samples", type=int, default=100)
    p.add_argument("--offset", type=int, default=0)
    p.add_argument("--host", default="192.168.137.2")
    p.add_argument("--pass", dest="atlas_pass", default="Mind@123")
    p.add_argument("--om", default="/tmp/phase4_snn/mnist_snn.om")
    p.add_argument("--onnx", type=Path, default=ROOT / "runs" / "phase4_export" / "model_snn.onnx")
    p.add_argument("--data", type=Path, default=ROOT / "data" / "mnist")
    p.add_argument("--dry-run", action="store_true", help="WSL ORT only, no Atlas")
    p.add_argument("--batch-xfer", action="store_true", help="单次 batch scp+ssh（对比逐帧）")
    p.add_argument("--daemon-port", type=int, default=0, help="Atlas 常驻 daemon TCP 端口（如 9527）")
    p.add_argument("--out", type=Path, default=None)
    args = p.parse_args()

    if args.out is None:
        if args.dry_run:
            args.out = ROOT / "runs" / "phase4_poc" / "distributed_bench_dry_run.json"
        elif args.daemon_port:
            args.out = ROOT / "runs" / "phase4_poc" / "distributed_bench_daemon.json"
        else:
            args.out = ROOT / "runs" / "phase4_poc" / "distributed_bench_atlas.json"

    if not args.atlas_only and not args.dry_run and not args.daemon_port:
        p.error("specify --atlas-only, --dry-run, or --daemon-port")

    t_load0 = time.perf_counter()
    xs, ys = load_mnist_samples(args.data, args.samples, args.offset)
    t_load_ms = (time.perf_counter() - t_load0) * 1000

    work_dir = ROOT / "runs" / "phase4_poc" / "_bench_work"
    work_dir.mkdir(parents=True, exist_ok=True)

    if args.dry_run:
        per_sample = dry_run_samples(xs, args.onnx)
        batch_agg = None
    elif args.daemon_port:
        batch_agg = None
        per_sample = []
        for i in range(xs.shape[0]):
            row = bench_daemon_sample(args.host, args.daemon_port, xs[i : i + 1], i)
            row["label"] = int(ys[i])
            row["atlas_pred"] = int(np.asarray(row["atlas_counts"]).argmax())
            row["pred_match"] = row["atlas_pred"] == row["label"]
            per_sample.append(row)
            if (i + 1) % 10 == 0:
                print(f"daemon bench {i + 1}/{xs.shape[0]}", file=sys.stderr)
    else:
        subprocess.run(
            _ssh_cmd(args.host, args.atlas_pass, "mkdir -p /tmp/phase4_snn/bench"),
            check=True,
        )
        ensure_atlas_probe(args.host, args.atlas_pass, args.om)
        if args.batch_xfer:
            per_sample, batch_agg = bench_batch(args.host, args.atlas_pass, args.om, xs, ys, work_dir)
        else:
            batch_agg = None
            per_sample = []
            for i in range(xs.shape[0]):
                t_pre0 = time.perf_counter()
                sample = xs[i : i + 1]
                t_preprocess = (time.perf_counter() - t_pre0) * 1000
                row = bench_one_sample(args.host, args.atlas_pass, args.om, sample, work_dir, i)
                row["t_preprocess_ms"] = round(t_preprocess, 3)
                row["label"] = int(ys[i])
                row["atlas_pred"] = int(np.asarray(row["atlas_counts"]).argmax())
                row["pred_match"] = row["atlas_pred"] == row["label"]
                per_sample.append(row)
                if (i + 1) % 10 == 0:
                    print(f"bench {i + 1}/{xs.shape[0]}", file=sys.stderr)

    summary = summarize(per_sample)
    if batch_agg:
        summary["batch_aggregate"] = batch_agg
        summary["batch_comm_ratio"] = round(
            (batch_agg["batch_xfer_in_ms"] + batch_agg["batch_xfer_out_ms"])
            / max(batch_agg["batch_e2e_ms"], 1e-9),
            4,
        )
    if not args.dry_run:
        summary["pred_match_rate"] = float(np.mean([r.get("pred_match", False) for r in per_sample]))
        summary["dataset_load_ms"] = round(t_load_ms, 3)

    report = {
        "schema": "phase4.1-distributed-bench-v1",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "mode": (
            "dry_run"
            if args.dry_run
            else (
                "atlas_daemon"
                if args.daemon_port
                else ("atlas_batch" if args.batch_xfer else "atlas_dual_hop")
            )
        ),
        "host": args.host,
        "daemon_port": args.daemon_port or None,
        "om": args.om,
        "summary": summary,
        "per_sample": per_sample,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(summary, indent=2, ensure_ascii=False))
    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
