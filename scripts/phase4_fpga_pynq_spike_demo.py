#!/usr/bin/env python3
"""Phase4 path B · run fixed-point spike demo on PYNQ-Z2 (blink LD4 on spikes).

Can run locally for dry-run, or push logic via SSH to the board.
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import textwrap
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Inline script executed ON the board (numpy + pynq available in venv/kernel).
BOARD_SCRIPT = textwrap.dedent(
    r'''
import json
import os
import sys
import time

os.environ.setdefault("XILINX_XRT", "/usr")

FRAC = 16
SCALE = 1 << FRAC
BETA_FP = int(round(0.9 * SCALE))
TH_FP = int(round(1.0 * SCALE))


def lif_step(cur_fp, mem_fp):
    reset = 1 if mem_fp >= TH_FP else 0
    mem_fp = (BETA_FP * mem_fp) // SCALE + cur_fp - reset * TH_FP
    spk = 1 if mem_fp >= TH_FP else 0
    return spk, mem_fp


def run_spike_demo(blink: bool, hold_s: float):
    currents = [0.0, 0.0, 1.2, 0.0, 0.0, 1.1, 1.1, 0.0, 0.0, 1.05]
    mem_fp = 0
    spikes = []
    for cur in currents:
        cur_fp = int(round(cur * SCALE))
        spk, mem_fp = lif_step(cur_fp, mem_fp)
        spikes.append(spk)

    total = sum(spikes)
    result = {
        "currents": currents,
        "spikes": spikes,
        "spike_total": total,
        "format": "Q16.16",
        "blink": blink,
    }

    if blink:
        from pynq.overlays.base import BaseOverlay
        base = BaseOverlay("base.bit")
        led = base.rgbleds[4]
        for spk in spikes:
            if spk:
                led.write(1)  # blue
                time.sleep(hold_s)
                led.off()
            else:
                time.sleep(hold_s * 0.3)
        led.off()
        result["led"] = "LD4_blue_blink"

    print("FPGA_SPIKE_DEMO_OK")
    print(json.dumps(result))

if __name__ == "__main__":
    blink = "--blink" in sys.argv
    hold = 0.4
    for i, a in enumerate(sys.argv):
        if a == "--hold" and i + 1 < len(sys.argv):
            hold = float(sys.argv[i + 1])
    run_spike_demo(blink, hold)
'''
)


def main() -> int:
    p = argparse.ArgumentParser(description="PYNQ spike accumulation + LED demo")
    p.add_argument("--host", default="192.168.137.3")
    p.add_argument("--user", default="xilinx")
    p.add_argument("--password", default="xilinx")
    p.add_argument("--blink", action="store_true", help="Blink LD4 blue on each spike")
    p.add_argument("--hold", type=float, default=0.4, help="Seconds per spike blink")
    p.add_argument("--local", action="store_true", help="Run BOARD_SCRIPT locally (dry-run)")
    p.add_argument("--out", type=Path, default=ROOT / "runs" / "phase4_poc" / "fpga_board_spike_demo.json")
    args = p.parse_args()

    remote_path = "/tmp/phase4_fpga_spike_demo.py"
    local_script = ROOT / "runs" / "phase4_poc" / "_board_spike_demo.py"

    if args.local:
        local_script.parent.mkdir(parents=True, exist_ok=True)
        local_script.write_text(BOARD_SCRIPT, encoding="utf-8")
        cmd = [sys.executable, str(local_script)]
        if args.blink:
            cmd.append("--blink")
        cmd.extend(["--hold", str(args.hold)])
        proc = subprocess.run(cmd, capture_output=True, text=True)
        print(proc.stdout)
        if proc.returncode != 0:
            print(proc.stderr, file=sys.stderr)
            return proc.returncode
        lines = [ln for ln in proc.stdout.splitlines() if ln.strip()]
        if not lines or lines[0] != "FPGA_SPIKE_DEMO_OK":
            return 1
        board_result = json.loads(lines[1])
    else:
        local_script.parent.mkdir(parents=True, exist_ok=True)
        local_script.write_text(BOARD_SCRIPT, encoding="utf-8")

        scp = [
            "sshpass",
            "-p",
            args.password,
            "scp",
            "-o",
            "StrictHostKeyChecking=no",
            str(local_script),
            f"{args.user}@{args.host}:{remote_path}",
        ]
        subprocess.run(scp, check=True)

        remote_cmd = f"export XILINX_XRT=/usr; echo {args.password} | sudo -S python3 {remote_path}"
        if args.blink:
            remote_cmd += " --blink"
        remote_cmd += f" --hold {args.hold}"

        ssh = [
            "sshpass",
            "-p",
            args.password,
            "ssh",
            "-o",
            "StrictHostKeyChecking=no",
            f"{args.user}@{args.host}",
            remote_cmd,
        ]
        proc = subprocess.run(ssh, capture_output=True, text=True)
        print(proc.stdout)
        if proc.stderr:
            print(proc.stderr, file=sys.stderr)
        if proc.returncode != 0:
            return proc.returncode
        lines = [ln for ln in proc.stdout.splitlines() if ln.strip() and not ln.startswith("[sudo]")]
        ok_lines = [ln for ln in lines if ln == "FPGA_SPIKE_DEMO_OK"]
        if not ok_lines:
            return 1
        json_line = [ln for ln in lines if ln.startswith("{")][-1]
        board_result = json.loads(json_line)

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "host": args.host,
        "blink": args.blink,
        "board_result": board_result,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
