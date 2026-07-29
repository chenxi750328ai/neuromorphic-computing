#!/usr/bin/env python3
"""F6 · 将 openXC7 产出的 Z2 .bit 加载到 PYNQ 并记录证据 — 陈正共.

默认：scp → 板上 sudo Bitstream.download() → 写 JSON 证据。
LED 闪烁需人眼确认（LFSR bit28 @125MHz ≈ 2.1s 周期）。
"""
from __future__ import annotations

import argparse
import json
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_board_load.json"
BIT_DEFAULT = ROOT / "fpga" / "openxc7_try" / "build" / "blinky_soft_ps7.bit"
HOST_DEFAULT = "192.168.137.3"
USER_DEFAULT = "xilinx"
PASS_DEFAULT = "xilinx"


def run(cmd: list[str], timeout: float = 120) -> dict:
    t0 = time.time()
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return {
            "cmd": cmd[:6] + (["…"] if len(cmd) > 6 else []),
            "exit": r.returncode,
            "ok": r.returncode == 0,
            "seconds": round(time.time() - t0, 2),
            "stdout_tail": (r.stdout or "")[-800:],
            "stderr_tail": (r.stderr or "")[-800:],
        }
    except subprocess.TimeoutExpired:
        return {"ok": False, "error": "timeout", "seconds": timeout}
    except OSError as e:
        return {"ok": False, "error": str(e)}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--bit", type=Path, default=BIT_DEFAULT)
    ap.add_argument("--host", default=HOST_DEFAULT)
    ap.add_argument("--user", default=USER_DEFAULT)
    ap.add_argument("--password", default=PASS_DEFAULT)
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true")
    ap.add_argument("--observe-sec", type=float, default=6.0, help="load 后等待，供 LED 观察")
    args = ap.parse_args()

    stages: dict = {}
    if not args.bit.is_file():
        stages["preflight"] = {"ok": False, "error": f"missing bit {args.bit}"}
        report = _report(stages, False, args)
        args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(report["conclusion"])
        return 1 if args.gate else 0

    stages["preflight"] = {
        "ok": True,
        "bit": str(args.bit),
        "bit_bytes": args.bit.stat().st_size,
        "host": args.host,
    }

    # ping
    stages["ping"] = run(["ping", "-c", "2", "-W", "2", args.host], timeout=10)

    remote_bit = "/tmp/blinky_openxc7.bit"
    target = f"{args.user}@{args.host}:{remote_bit}"
    ssh = [
        "sshpass",
        "-p",
        args.password,
        "ssh",
        "-o",
        "StrictHostKeyChecking=no",
        "-o",
        "ConnectTimeout=8",
        f"{args.user}@{args.host}",
    ]
    scp = [
        "sshpass",
        "-p",
        args.password,
        "scp",
        "-o",
        "StrictHostKeyChecking=no",
        "-o",
        "ConnectTimeout=8",
        str(args.bit),
        target,
    ]

    stages["scp"] = run(scp, timeout=120)
    if not stages["scp"].get("ok"):
        report = _report(stages, False, args)
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(report["conclusion"])
        return 1 if args.gate else 0

    # Prefer Bitstream.download (no .hwh). Fallback: /dev/xdevcfg / fpgautil.
    remote_py = f"""
import json, os, sys, time
os.environ.setdefault('XILINX_XRT', '/usr')
bit = {remote_bit!r}
out = {{'bit': bit, 'methods': []}}
ok = False
err = None
# method 1: pynq Bitstream
try:
    from pynq import Bitstream
    Bitstream(bit).download()
    out['methods'].append({{'name': 'pynq.Bitstream.download', 'ok': True}})
    ok = True
except Exception as e:
    out['methods'].append({{'name': 'pynq.Bitstream.download', 'ok': False, 'error': repr(e)}})
    err = repr(e)
# method 2: fpga_manager via fpgautil if present
if not ok:
    import shutil, subprocess
    fu = shutil.which('fpgautil')
    if fu:
        r = subprocess.run([fu, '-b', bit], capture_output=True, text=True)
        m = {{'name': 'fpgautil', 'ok': r.returncode == 0, 'stdout': (r.stdout or '')[-200:], 'stderr': (r.stderr or '')[-200:]}}
        out['methods'].append(m)
        ok = r.returncode == 0
        if not ok:
            err = m.get('stderr') or 'fpgautil failed'
# method 3: raw xdevcfg
if not ok and os.path.exists('/dev/xdevcfg'):
    try:
        with open(bit, 'rb') as src, open('/dev/xdevcfg', 'wb') as dst:
            dst.write(src.read())
        out['methods'].append({{'name': 'xdevcfg', 'ok': True}})
        ok = True
    except Exception as e:
        out['methods'].append({{'name': 'xdevcfg', 'ok': False, 'error': repr(e)}})
        err = repr(e)
# state files
for p in ('/sys/class/fpga_manager/fpga0/state', '/sys/class/fpga_manager/fpga0/name'):
    if os.path.exists(p):
        try:
            out[p] = open(p).read().strip()
        except Exception as e:
            out[p] = repr(e)
out['ok'] = ok
out['error'] = None if ok else err
print(json.dumps(out))
sys.exit(0 if ok else 2)
"""
    # Prefer piping script via stdin to avoid shell quoting hell
    load_cmd = ssh + [
        f"echo {args.password} | sudo -S /usr/local/share/pynq-venv/bin/python3 -"
    ]
    t0 = time.time()
    try:
        r = subprocess.run(
            load_cmd,
            input=remote_py,
            capture_output=True,
            text=True,
            timeout=180,
        )
        stages["download"] = {
            "exit": r.returncode,
            "ok": r.returncode == 0,
            "seconds": round(time.time() - t0, 2),
            "stdout_tail": (r.stdout or "")[-1200:],
            "stderr_tail": (r.stderr or "")[-800:],
        }
        try:
            # last JSON line
            lines = [ln for ln in (r.stdout or "").splitlines() if ln.strip().startswith("{")]
            if lines:
                stages["download"]["board_json"] = json.loads(lines[-1])
                stages["download"]["ok"] = bool(stages["download"]["board_json"].get("ok"))
        except json.JSONDecodeError:
            pass
    except (OSError, subprocess.TimeoutExpired) as e:
        stages["download"] = {"ok": False, "error": str(e)}

    if args.observe_sec > 0 and stages.get("download", {}).get("ok"):
        time.sleep(float(args.observe_sec))
        stages["observe"] = {
            "ok": True,
            "seconds": args.observe_sec,
            "note": "人眼确认 LD0–LD3 是否按 ~2s 节拍闪烁；本脚本不摄录",
        }

    load_ok = bool(stages.get("download", {}).get("ok"))
    report = _report(stages, load_ok, args)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(report["conclusion"], "load_ok=" + str(load_ok))
    for name in ("ping", "scp", "download"):
        st = stages.get(name) or {}
        print(f"  {name}: {'PASS' if st.get('ok') else 'FAIL'} {st.get('error') or ''}")
    print(f"wrote {args.out}")
    return 0 if (load_ok or not args.gate) else 1


def _report(stages: dict, load_ok: bool, args) -> dict:
    return {
        "schema": "phase4.1-fpga-z2-openxc7-board-load-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "board": "PYNQ-Z2",
        "host": args.host,
        "bit": str(args.bit),
        "stages": stages,
        "pass_board_load": load_ok,
        "conclusion": "BOARD_LOAD_OK" if load_ok else "BOARD_LOAD_FAIL",
        "honesty": "load_ok=PL 下载无异常；LED 功能需人眼或后续 GPIO 回读",
    }


if __name__ == "__main__":
    raise SystemExit(main())
