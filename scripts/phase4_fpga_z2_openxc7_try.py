#!/usr/bin/env python3
"""F6 · Z2(xc7z020) 开源出 bit 实测（陈正共）.

阶段：yosys synth_xilinx → chipdb → nextpnr-xilinx → fasm2frames → xc7frames2bit
缺工具则如实记 FAIL/SKIP，禁止 pen 判死刑。
默认设计：软逻辑 blinky（无 CARRY4）；可选对照加法器 blinky。
"""
from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TRY = ROOT / "fpga" / "openxc7_try"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_try.json"
PART = "xc7z020clg400-1"
FAMILY = "zynq7"
THIRD = ROOT / "third_party" / "openxc7-try"


def which(name: str) -> str | None:
    p = shutil.which(name)
    if p:
        return p
    cands = [
        THIRD / "nextpnr-xilinx" / "build" / name,
        THIRD / "prjxray" / "build" / "tools" / name,
        THIRD / "prjxray" / "build" / name,
    ]
    for c in cands:
        if c.is_file() and os.access(c, os.X_OK):
            return str(c)
    if (THIRD / "prjxray" / "build").is_dir():
        for c in (THIRD / "prjxray" / "build").rglob(name):
            if c.is_file() and os.access(c, os.X_OK):
                return str(c)
    return None


def run(
    cmd: list[str],
    cwd: Path | None = None,
    timeout: float = 600,
    env: dict | None = None,
) -> dict:
    t0 = time.time()
    try:
        r = subprocess.run(
            cmd,
            cwd=str(cwd) if cwd else None,
            capture_output=True,
            text=True,
            timeout=timeout,
            env=env,
        )
        return {
            "cmd": cmd,
            "exit": r.returncode,
            "ok": r.returncode == 0,
            "seconds": round(time.time() - t0, 2),
            "stdout_tail": (r.stdout or "")[-600:],
            "stderr_tail": (r.stderr or "")[-600:],
        }
    except subprocess.TimeoutExpired:
        return {"cmd": cmd, "exit": -1, "ok": False, "seconds": timeout, "error": "timeout"}
    except OSError as e:
        return {"cmd": cmd, "exit": -1, "ok": False, "error": str(e)}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--workdir", type=Path, default=TRY / "build")
    ap.add_argument("--gate", action="store_true", help="require full .bit success")
    ap.add_argument(
        "--design",
        choices=("soft", "soft_ps7", "carry", "ps7"),
        default="soft",
        help="soft=LFSR无CARRY；soft_ps7=LFSR+PS7(上板)；carry=加法；ps7=计数+PS7",
    )
    ap.add_argument("--skip-pnr", action="store_true")
    args = ap.parse_args()

    work = args.workdir
    work.mkdir(parents=True, exist_ok=True)

    venv_py = THIRD / "venv" / "bin" / "python3"
    py = (
        str(venv_py)
        if venv_py.is_file()
        else (shutil.which("pypy3") or shutil.which("python3"))
    )
    fasm2frames_py = THIRD / "prjxray" / "utils" / "fasm2frames.py"
    tools = {
        "yosys": which("yosys") or shutil.which("yosys"),
        "nextpnr-xilinx": which("nextpnr-xilinx"),
        "bbasm": which("bbasm"),
        "fasm2frames": which("fasm2frames")
        or (str(fasm2frames_py) if fasm2frames_py.is_file() else None),
        "xc7frames2bit": which("xc7frames2bit"),
        "python": py,
    }
    stages: dict = {
        "tools": {k: bool(v) for k, v in tools.items()},
        "tool_paths": tools,
        "design_variant": args.design,
    }

    design_map = {
        "soft": TRY / "blinky_z2_soft.v",
        "soft_ps7": TRY / "blinky_z2_soft_ps7.v",
        "carry": TRY / "blinky_z2_nops.v",
        "ps7": TRY / "blinky_z2.v",
    }
    vlog = design_map[args.design]
    xdc = TRY / "pynq_z2_leds.xdc"
    stem = f"blinky_{args.design}"
    json_net = work / f"{stem}.json"
    fasm = work / f"{stem}.fasm"
    frames = work / f"{stem}.frames"
    bit = work / f"{stem}.bit"
    chipdb_dir = THIRD / "chipdb"
    chipdb = chipdb_dir / f"{PART}.bin"
    db_root = THIRD / "prjxray-db" / FAMILY
    prjxray_py = THIRD / "prjxray"

    # 1) Yosys synth_xilinx（软逻辑不用 abc9，更贴近实测成功路径）
    synth_flags = "-flatten -arch xc7"
    if args.design in ("carry", "ps7"):
        synth_flags = "-flatten -abc9 -arch xc7"
    if not tools["yosys"]:
        stages["synth"] = {"ok": False, "error": "yosys missing"}
    elif not vlog.is_file():
        stages["synth"] = {"ok": False, "error": f"missing {vlog}"}
    else:
        stages["synth"] = run(
            [
                tools["yosys"],
                "-p",
                f"synth_xilinx {synth_flags} -top blinky; write_json {json_net}",
                str(vlog),
            ],
            timeout=300,
        )
        stages["synth"]["netlist"] = str(json_net) if json_net.is_file() else None
        stages["synth"]["rtl"] = str(vlog)

    # 2) chipdb
    if chipdb.is_file():
        stages["chipdb"] = {
            "ok": True,
            "path": str(chipdb),
            "cached": True,
            "bytes": chipdb.stat().st_size,
        }
    else:
        stages["chipdb"] = {"ok": False, "error": f"missing {chipdb} (generate via bbaexport+bbasm)"}

    # 3) P&R
    if args.skip_pnr:
        stages["pnr"] = {"ok": False, "skipped": True}
    elif not stages.get("synth", {}).get("ok"):
        stages["pnr"] = {"ok": False, "error": "synth failed"}
    elif not stages.get("chipdb", {}).get("ok"):
        stages["pnr"] = {"ok": False, "error": "chipdb missing"}
    elif not tools["nextpnr-xilinx"]:
        stages["pnr"] = {"ok": False, "error": "nextpnr-xilinx missing"}
    else:
        stages["pnr"] = run(
            [
                tools["nextpnr-xilinx"],
                "--chipdb",
                str(chipdb),
                "--xdc",
                str(xdc),
                "--json",
                str(json_net),
                "--fasm",
                str(fasm),
                "--seed",
                "1",
            ],
            timeout=1200,
        )
        stages["pnr"]["fasm"] = str(fasm) if fasm.is_file() else None
        stages["pnr"]["fasm_bytes"] = fasm.stat().st_size if fasm.is_file() else 0

    # 4) frames + bit
    if (
        stages.get("pnr", {}).get("ok")
        and fasm.is_file()
        and tools["fasm2frames"]
        and tools["xc7frames2bit"]
        and py
    ):
        env = os.environ.copy()
        env["PYTHONPATH"] = str(prjxray_py) + (
            os.pathsep + env["PYTHONPATH"] if env.get("PYTHONPATH") else ""
        )
        f2f_cmd = (
            [py, tools["fasm2frames"], "--part", PART, "--db-root", str(db_root), str(fasm)]
            if tools["fasm2frames"].endswith(".py")
            else [tools["fasm2frames"], "--part", PART, "--db-root", str(db_root), str(fasm)]
        )
        try:
            with frames.open("w", encoding="utf-8") as fh:
                r = subprocess.run(
                    f2f_cmd,
                    stdout=fh,
                    stderr=subprocess.PIPE,
                    text=True,
                    timeout=300,
                    env=env,
                )
            stages["frames"] = {
                "ok": r.returncode == 0 and frames.is_file() and frames.stat().st_size > 0,
                "exit": r.returncode,
                "stderr_tail": (r.stderr or "")[-600:],
                "frames_bytes": frames.stat().st_size if frames.is_file() else 0,
            }
        except (OSError, subprocess.TimeoutExpired) as e:
            stages["frames"] = {"ok": False, "error": str(e)}
        if stages.get("frames", {}).get("ok"):
            stages["bitstream"] = run(
                [
                    tools["xc7frames2bit"],
                    "--part_file",
                    str(db_root / PART / "part.yaml"),
                    "--part_name",
                    PART,
                    "--frm_file",
                    str(frames),
                    "--output_file",
                    str(bit),
                ],
                timeout=300,
            )
            stages["bitstream"]["bit_path"] = str(bit) if bit.is_file() else None
            stages["bitstream"]["bit_bytes"] = bit.stat().st_size if bit.is_file() else 0
    else:
        stages["frames"] = stages.get("frames") or {"ok": False, "error": "pnr or tools missing"}
        stages["bitstream"] = {"ok": False, "error": "upstream incomplete"}

    bit_ok = bool(stages.get("bitstream", {}).get("ok") and bit.is_file())
    report = {
        "schema": "phase4.1-fpga-z2-openxc7-try-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "part": PART,
        "board": "PYNQ-Z2",
        "design": f"{vlog.name} ({args.design})",
        "toolchain_notes": {
            "yosys": "system /usr/bin/yosys 0.33",
            "nextpnr": "openXC7/nextpnr-xilinx stable-backports @62839b3",
            "prjxray": "local build xc7frames2bit (Wno-error=deprecated-declarations)",
            "carry_counter": "FAIL route on this build (see design=carry)",
            "board_load": "not attempted this run",
        },
        "stages": stages,
        "pass_full_open_bit": bit_ok,
        "pass_synth_xilinx": bool(stages.get("synth", {}).get("ok")),
        "conclusion": (
            "OPEN_BITSTREAM_OK"
            if bit_ok
            else (
                "SYNTH_OK_PNR_OR_BIT_BLOCKED"
                if stages.get("synth", {}).get("ok")
                else "SYNTH_FAILED"
            )
        ),
        "honesty": "结果以本机实测阶段为准，不是 pen 判断",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(report["conclusion"], "full_bit=" + str(bit_ok))
    for name in ("synth", "chipdb", "pnr", "frames", "bitstream"):
        st = stages.get(name) or {}
        print(f"  {name}: {'PASS' if st.get('ok') else 'FAIL/SKIP'} {st.get('error') or ''}")
    print(f"wrote {args.out}")
    if args.gate:
        return 0 if bit_ok else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
