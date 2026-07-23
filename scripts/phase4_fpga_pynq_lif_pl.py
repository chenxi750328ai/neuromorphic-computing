#!/usr/bin/env python3
"""Load neuromorphic lif_step_overlay on PYNQ PL and measure LIF steps (陈正共).

Requires fpga/bitstreams/lif_step_overlay.{bit,hwh} produced by Vivado/Vitis.
Uses sudo on board (PYNQ mmap needs root on this image).
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FRAC = 16
SCALE = 1 << FRAC


BOARD_SCRIPT = r'''
import json, os, time, sys
os.environ["XILINX_XRT"] = "/usr"
from pynq import Overlay
import numpy as np

bit = sys.argv[1]
ol = Overlay(bit)
# Expected IP name: lif_step_0 with AXI-Lite regs:
#   0x00 start, 0x04 cur, 0x08 mem_in, 0x0c status(done|spk), 0x10 mem_out
ip = ol.ip_dict
print("IP_KEYS", sorted(ip.keys())[:40], flush=True)
# Until custom axi wrapper lands, refuse fake PASS
if not any("lif" in k.lower() for k in ip):
    print("NO_LIF_IP")
    sys.exit(3)

# Placeholder MMIO loop when IP ready
driver = ol.lif_step_0
currents = [0.0, 0.0, 1.2, 0.0, 0.0, 1.1, 1.1, 0.0, 0.0, 1.05]
SCALE = 65536
mem = 0
spikes = []
t0 = time.perf_counter()
for cur in currents:
    cur_fp = int(round(cur * SCALE))
    driver.write(0x04, cur_fp & 0xFFFFFFFF)
    driver.write(0x08, mem & 0xFFFFFFFF)
    driver.write(0x00, 1)
    for _ in range(10000):
        st = driver.read(0x0C)
        if st & 1:
            break
    spk = (st >> 1) & 1
    mem = driver.read(0x10)
    if mem >= 2**31:
        mem -= 2**32
    spikes.append(int(spk))
t_ms = (time.perf_counter() - t0) * 1000
print("LIF_PL_OK")
print(json.dumps({"spikes": spikes, "spike_total": sum(spikes), "t_sequence_ms": round(t_ms, 3)}))
'''


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default=os.environ.get("PYNQ_HOST", "192.168.137.3"))
    ap.add_argument("--user", default="xilinx")
    ap.add_argument("--pass", dest="password", default="xilinx")
    ap.add_argument(
        "--bit",
        type=Path,
        default=ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=ROOT / "runs" / "phase4_poc" / "fpga_lif_pl_run.json",
    )
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    if not args.bit.is_file():
        report = {
            "ok": False,
            "error": f"missing bitstream {args.bit}",
            "hint": "先在 Vivado 机综合，见 docs/phase4_fpga_toolchain_V0.md",
        }
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
        print(json.dumps(report, ensure_ascii=False))
        return 2 if args.gate else 0

    remote_bit = "/tmp/lif_step_overlay.bit"
    remote_hwh = "/tmp/lif_step_overlay.hwh"
    remote_py = "/tmp/phase4_fpga_pynq_lif_pl_board.py"
    hwh = args.bit.with_suffix(".hwh")
    target = f"{args.user}@{args.host}"
    ssh = ["sshpass", "-p", args.password, "ssh", "-o", "StrictHostKeyChecking=no", target]
    scp = ["sshpass", "-p", args.password, "scp", "-o", "StrictHostKeyChecking=no"]

    subprocess.run(scp + [str(args.bit), f"{target}:{remote_bit}"], check=True)
    if hwh.is_file():
        subprocess.run(scp + [str(hwh), f"{target}:{remote_hwh}"], check=True)
    Path("/tmp/_lif_pl_board.py").write_text(BOARD_SCRIPT, encoding="utf-8")
    subprocess.run(scp + ["/tmp/_lif_pl_board.py", f"{target}:{remote_py}"], check=True)

    remote = (
        f"echo {args.password} | sudo -S /usr/local/share/pynq-venv/bin/python3 "
        f"{remote_py} {remote_bit}"
    )
    t0 = time.perf_counter()
    proc = subprocess.run(ssh + [remote], capture_output=True, text=True)
    wall_ms = (time.perf_counter() - t0) * 1000
    ok = proc.returncode == 0 and "LIF_PL_OK" in (proc.stdout or "")
    payload = {
        "ok": ok,
        "wall_ms": round(wall_ms, 3),
        "stdout": proc.stdout,
        "stderr": proc.stderr[-2000:],
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "bit": str(args.bit),
    }
    if ok:
        for ln in (proc.stdout or "").splitlines():
            if ln.strip().startswith("{"):
                payload["board"] = json.loads(ln)
                break
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"ok": ok, "out": str(args.out)}, ensure_ascii=False))
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
