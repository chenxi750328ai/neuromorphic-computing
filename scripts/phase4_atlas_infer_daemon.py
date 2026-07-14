#!/usr/bin/env python3
"""Atlas 侧 · Phase4.1 推理常驻 daemon（AclLite 单次 init · TCP）。

在 Atlas 上启动（须已部署 mnist_snn.om 与 acllite 环境）:
  source /usr/local/Ascend/ascend-toolkit/set_env.sh
  export PYTHONPATH=/usr/local/Ascend/thirdpart/aarch64/acllite:$PYTHONPATH
  python3 phase4_atlas_infer_daemon.py --model /tmp/phase4_snn/mnist_snn.om --port 9527

协议（每请求一连接）:
  客户端 → 8B magic b'PH41INFR' + uint32_le payload_bytes + float32 ndarray (C-order)
  服务端 → uint32_le json_len + UTF-8 JSON {"ok":true,"infer_ms":..,"atlas_counts":[...]}
"""
from __future__ import annotations

import argparse
import json
import socket
import struct
import sys
import time
from typing import Any

import numpy as np

sys.path.insert(0, "/usr/local/Ascend/thirdpart/aarch64/acllite")
sys.path.insert(0, "/usr/local/Ascend/ascend-toolkit/latest/python/site-packages")

from acllite_model import AclLiteModel  # noqa: E402
from acllite_resource import AclLiteResource  # noqa: E402

MAGIC = b"PH41INFR"


def _recv_exact(conn: socket.socket, n: int) -> bytes:
    buf = bytearray()
    while len(buf) < n:
        chunk = conn.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("client closed")
        buf.extend(chunk)
    return bytes(buf)


def _send_json(conn: socket.socket, payload: dict[str, Any]) -> None:
    raw = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    conn.sendall(struct.pack("<I", len(raw)) + raw)


def handle_client(conn: socket.socket, model: AclLiteModel) -> None:
    header = _recv_exact(conn, 8)
    if header != MAGIC:
        _send_json(conn, {"ok": False, "error": f"bad magic {header!r}"})
        return
    (nbytes,) = struct.unpack("<I", _recv_exact(conn, 4))
    if nbytes <= 0 or nbytes > 16 * 1024 * 1024:
        _send_json(conn, {"ok": False, "error": f"bad payload size {nbytes}"})
        return
    raw = _recv_exact(conn, nbytes)
    arr = np.frombuffer(raw, dtype=np.float32)
    if arr.size == 784:
        sample = arr.reshape(1, 1, 28, 28)
    elif arr.size == 28 * 28:
        sample = arr.reshape(1, 1, 28, 28)
    else:
        sample = arr.reshape(1, -1, 28, 28) if arr.size % (28 * 28) == 0 else arr.reshape(1, -1)
    sample = np.ascontiguousarray(sample.astype(np.float32))
    t0 = time.perf_counter()
    out = model.execute([sample])
    infer_ms = round((time.perf_counter() - t0) * 1000, 3)
    counts = np.asarray(out[0])[0].tolist()
    _send_json(
        conn,
        {
            "ok": True,
            "infer_ms": infer_ms,
            "atlas_counts": counts,
            "shape": list(sample.shape),
        },
    )


def serve(model_path: str, host: str, port: int) -> None:
    res = AclLiteResource()
    res.init()
    model = AclLiteModel(model_path)
    print(json.dumps({"event": "daemon_ready", "host": host, "port": port, "model": model_path}), flush=True)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind((host, port))
    sock.listen(8)
    while True:
        conn, addr = sock.accept()
        try:
            handle_client(conn, model)
        except Exception as e:
            try:
                _send_json(conn, {"ok": False, "error": f"{type(e).__name__}: {e}"})
            except OSError:
                pass
        finally:
            conn.close()


def main() -> int:
    ap = argparse.ArgumentParser(description="Phase4.1 Atlas inference daemon")
    ap.add_argument("--model", default="/tmp/phase4_snn/mnist_snn.om")
    ap.add_argument("--host", default="0.0.0.0")
    ap.add_argument("--port", type=int, default=9527)
    args = ap.parse_args()
    serve(args.model, args.host, args.port)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
