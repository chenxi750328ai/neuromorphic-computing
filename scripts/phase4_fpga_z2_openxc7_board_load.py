#!/usr/bin/env python3
"""F6 · 将 openXC7 产出的 Z2 .bit 加载到 PYNQ 并记录证据 — 陈正共.

默认：scp bit + 远程加载脚本 → 板上 sudo Bitstream.download() → 写 JSON 证据。
注意：不可把远程 .py 经 `sudo -S` 的 stdin 传入（密码会吞掉脚本）。
LED 闪烁需人眼确认（LFSR bit28 @125MHz ≈ 2.1s 周期）。
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from neuro_fpga_lab_auth import SSH_OPTS, require_pass  # noqa: E402

OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_board_load.json"
BIT_DEFAULT = ROOT / "fpga" / "openxc7_try" / "build" / "blinky_soft_ps7.bit"
HOST_DEFAULT = "192.168.137.3"
USER_DEFAULT = "xilinx"

REMOTE_LOADER = r'''#!/usr/bin/env python3
import json, os, sys, shutil, subprocess
os.environ.setdefault("XILINX_XRT", "/usr")
bit = sys.argv[1]
out = {"bit": bit, "methods": []}
ok = False
err = None
try:
    from pynq import Bitstream
    Bitstream(bit).download()
    out["methods"].append({"name": "pynq.Bitstream.download", "ok": True})
    ok = True
except Exception as e:
    out["methods"].append({"name": "pynq.Bitstream.download", "ok": False, "error": repr(e)})
    err = repr(e)
if not ok:
    fu = shutil.which("fpgautil")
    if fu:
        r = subprocess.run([fu, "-b", bit], capture_output=True, text=True)
        m = {
            "name": "fpgautil",
            "ok": r.returncode == 0,
            "stdout": (r.stdout or "")[-200:],
            "stderr": (r.stderr or "")[-200:],
        }
        out["methods"].append(m)
        ok = r.returncode == 0
        if not ok:
            err = m.get("stderr") or "fpgautil failed"
if not ok and os.path.exists("/dev/xdevcfg"):
    try:
        with open(bit, "rb") as src, open("/dev/xdevcfg", "wb") as dst:
            dst.write(src.read())
        out["methods"].append({"name": "xdevcfg", "ok": True})
        ok = True
    except Exception as e:
        out["methods"].append({"name": "xdevcfg", "ok": False, "error": repr(e)})
        err = repr(e)
for p in ("/sys/class/fpga_manager/fpga0/state", "/sys/class/fpga_manager/fpga0/name"):
    if os.path.exists(p):
        try:
            out[p] = open(p).read().strip()
        except Exception as e:
            out[p] = repr(e)
# dmesg hint
try:
    r = subprocess.run(["dmesg"], capture_output=True, text=True)
    lines = [ln for ln in (r.stdout or "").splitlines() if "fpga_manager" in ln or "writing" in ln]
    out["dmesg_fpga_tail"] = lines[-5:]
except Exception:
    pass
out["ok"] = ok
out["error"] = None if ok else err
print(json.dumps(out))
sys.exit(0 if ok else 2)
'''


def run(cmd: list[str], timeout: float = 120) -> dict:
    t0 = time.time()
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return {
            "cmd": ["***" if i >= 2 and cmd[i - 1] == "-p" else c for i, c in enumerate(cmd[:8])]
            + (["…"] if len(cmd) > 8 else []),
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
    ap.add_argument("--password", default="", help="或环境变量 PYNQ_PASS / NEURO_PYNQ_PASS")
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true")
    ap.add_argument("--observe-sec", type=float, default=6.0)
    args = ap.parse_args()
    password = args.password or require_pass("PYNQ", "PYNQ_PASS", "NEURO_PYNQ_PASS")

    stages: dict = {}
    if not args.bit.is_file():
        stages["preflight"] = {"ok": False, "error": f"missing bit {args.bit}"}
        report = _report(stages, False, args)
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(report["conclusion"])
        return 1 if args.gate else 0

    stages["preflight"] = {
        "ok": True,
        "bit": str(args.bit),
        "bit_bytes": args.bit.stat().st_size,
        "host": args.host,
    }
    stages["ping"] = run(["ping", "-c", "2", "-W", "2", args.host], timeout=10)

    remote_bit = "/tmp/blinky_openxc7.bit"
    remote_py = "/tmp/openxc7_board_load.py"
    target_bit = f"{args.user}@{args.host}:{remote_bit}"
    target_py = f"{args.user}@{args.host}:{remote_py}"
    scp_base = ["sshpass", "-p", password, "scp", *SSH_OPTS]
    ssh_base = ["sshpass", "-p", password, "ssh", *SSH_OPTS, f"{args.user}@{args.host}"]

    with tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8") as tf:
        tf.write(REMOTE_LOADER)
        local_py = tf.name
    try:
        stages["scp_bit"] = run(scp_base + [str(args.bit), target_bit], timeout=120)
        stages["scp_loader"] = run(scp_base + [local_py, target_py], timeout=60)
    finally:
        Path(local_py).unlink(missing_ok=True)

    if not stages["scp_bit"].get("ok") or not stages["scp_loader"].get("ok"):
        report = _report(stages, False, args)
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(report["conclusion"])
        return 1 if args.gate else 0

    # password on stdin for sudo only; script path is argv
    load_remote = (
        f"echo {password} | sudo -S /usr/local/share/pynq-venv/bin/python3 "
        f"{remote_py} {remote_bit}"
    )
    t0 = time.time()
    try:
        r = subprocess.run(
            ssh_base + [load_remote],
            capture_output=True,
            text=True,
            timeout=180,
        )
        stages["download"] = {
            "exit": r.returncode,
            "ok": False,
            "seconds": round(time.time() - t0, 2),
            "stdout_tail": (r.stdout or "")[-1200:],
            "stderr_tail": (r.stderr or "")[-800:],
        }
        lines = [ln for ln in (r.stdout or "").splitlines() if ln.strip().startswith("{")]
        if lines:
            board_json = json.loads(lines[-1])
            stages["download"]["board_json"] = board_json
            stages["download"]["ok"] = bool(board_json.get("ok"))
        else:
            stages["download"]["error"] = "no board JSON in stdout"
    except (OSError, subprocess.TimeoutExpired, json.JSONDecodeError) as e:
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
    for name in ("ping", "scp_bit", "scp_loader", "download"):
        st = stages.get(name) or {}
        print(f"  {name}: {'PASS' if st.get('ok') else 'FAIL'} {st.get('error') or ''}")
    bj = (stages.get("download") or {}).get("board_json") or {}
    if bj.get("dmesg_fpga_tail"):
        print("  dmesg:", bj["dmesg_fpga_tail"][-2:])
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
        "honesty": "load_ok=PL 下载无异常且 dmesg/board_json 可核；LED 功能需人眼确认",
    }


if __name__ == "__main__":
    raise SystemExit(main())
