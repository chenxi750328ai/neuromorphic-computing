#!/usr/bin/env python3
"""F6 · Vivado LIF bit 完整性门（陈正共）— 禁假绿旁路。

校验：bit 存在、非空、sha256 清单、配套 util/timing rpt、tcl 无静默 catch 吞 bitstream 失败。
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIT = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.bit"
UTIL = ROOT / "fpga" / "bitstreams" / "lif_step_utilization.rpt"
TIMING = ROOT / "fpga" / "bitstreams" / "lif_step_timing.rpt"
TCL = ROOT / "fpga" / "vivado" / "create_lif_overlay.tcl"
MANIFEST = ROOT / "fpga" / "bitstreams" / "lif_step_overlay.sha256"
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_vivado_bit_gate.json"


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true")
    ap.add_argument("--write-manifest", action="store_true")
    args = ap.parse_args()

    errs: list[str] = []
    checks: dict = {}

    if not BIT.is_file() or BIT.stat().st_size < 1000:
        errs.append("missing or tiny lif_step_overlay.bit")
        checks["bit"] = {"ok": False}
    else:
        digest = sha256(BIT)
        checks["bit"] = {"ok": True, "bytes": BIT.stat().st_size, "sha256": digest}
        if args.write_manifest or not MANIFEST.is_file():
            MANIFEST.write_text(f"{digest}  {BIT.name}\n", encoding="utf-8")
        if MANIFEST.is_file():
            man = MANIFEST.read_text(encoding="utf-8").split()[0].strip()
            if man != digest:
                errs.append(f"sha256 mismatch manifest={man} actual={digest}")
            checks["manifest"] = {"ok": man == digest, "path": str(MANIFEST)}
        else:
            errs.append("missing lif_step_overlay.sha256")

    for label, path in (("util", UTIL), ("timing", TIMING), ("tcl", TCL)):
        ok = path.is_file()
        checks[label] = {"ok": ok, "path": str(path)}
        if not ok:
            errs.append(f"missing {path.name}")

    if TCL.is_file():
        tcl = TCL.read_text(encoding="utf-8")
        # 禁止 bitstream 失败后仍 exit 0 的假绿模式
        if "BD_BITSTREAM_SKIP" in tcl or re.search(
            r"BD_BITSTREAM_SKIP|puts \"DONE.*\"\s*\nexit 0\s*$", tcl
        ):
            # allow DONE+exit 0 only on success path; fail if SKIP string present
            if "BD_BITSTREAM_SKIP" in tcl:
                errs.append("tcl still contains BD_BITSTREAM_SKIP (silent pass)")
                checks["tcl_hard_fail"] = {"ok": False}
            else:
                checks["tcl_hard_fail"] = {"ok": True}
        if "BD_BITSTREAM_FAIL" in tcl and "exit 1" in tcl:
            checks["tcl_hard_fail"] = {"ok": True}
        elif "BD_BITSTREAM_FAIL" not in tcl:
            errs.append("tcl missing BD_BITSTREAM_FAIL hard-fail path")
            checks["tcl_hard_fail"] = {"ok": False}

    ok = not errs
    report = {
        "schema": "phase4.1-fpga-vivado-bit-gate-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "checks": checks,
        "errors": errs,
        "pass": ok,
        "honesty": "本门验闭源旁路产物完整性与脚本硬失败；不宣称开源出 bit",
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("PASS" if ok else "FAIL", "phase4_fpga_vivado_bit_gate")
    for e in errs:
        print(" -", e)
    print(f"wrote {args.out}")
    return 0 if (ok or not args.gate) else 1


if __name__ == "__main__":
    raise SystemExit(main())
