#!/usr/bin/env python3
"""合入 main 前 IPD 门禁：neuro-ci 绿不够，须对应 WO-TEST 已过 EXEC。

用法：
  python3 scripts/neuro-pre-merge-ipd-gate.py --wo WO-TEST-NEURO-F7-PL-FC --gate
  python3 scripts/neuro-pre-merge-ipd-gate.py --pr 22 --gate   # 从 PR body/标题猜 WO（弱）

exit 0 = 允许继续人工 merge；非 0 = 禁止 merge。
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

VC = Path(os.environ.get("VCOMPANY_ROOT", "/home/cx/vcompany")).resolve()
ALLOWED_STATUS = {
    "awaiting_acceptance",
    "done",
    "accepted",
    "closed",
}


def load_wo(wo_id: str) -> dict:
    path = VC / "data" / "work-orders" / f"{wo_id}.json"
    if not path.is_file():
        raise SystemExit(f"FAIL missing WO contract: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def last_verify_ok(wo_id: str) -> tuple[bool, str]:
    es = VC / "data" / "wo-agent-execution-state" / f"{wo_id}.json"
    if not es.is_file():
        return False, "no executionState"
    state = json.loads(es.read_text(encoding="utf-8"))
    lv = state.get("lastVerify") or {}
    if lv.get("ok") is True:
        return True, f"lastVerify.ok=true id={lv.get('id') or lv.get('verifyId')}"
    # fallback: dispatch-check summary
    summary = VC / "data" / "ops" / "wo-verify" / f"{wo_id}-dispatch-check-summary.json"
    if summary.is_file():
        s = json.loads(summary.read_text(encoding="utf-8"))
        if s.get("nodeVerdict") == "PASS" and not s.get("red"):
            return True, f"dispatch-check PASS @ {s.get('ranAt')}"
    return False, f"lastVerify not ok: {lv!r}"


def main() -> int:
    ap = argparse.ArgumentParser(description="Neuro IPD pre-merge gate (TEST WO)")
    ap.add_argument("--wo", required=True, help="WO-TEST-* id")
    ap.add_argument("--gate", action="store_true", help="exit non-zero on fail")
    ap.add_argument("--allow-status", default="", help="extra comma statuses")
    args = ap.parse_args()

    allowed = set(ALLOWED_STATUS)
    if args.allow_status:
        allowed |= {s.strip() for s in args.allow_status.split(",") if s.strip()}

    wo = load_wo(args.wo)
    status = (wo.get("status") or "").strip()
    ok_verify, verify_note = last_verify_ok(args.wo)
    status_ok = status in allowed

    report = {
        "woId": args.wo,
        "status": status,
        "status_ok": status_ok,
        "verify_ok": ok_verify,
        "verify_note": verify_note,
        "allowed_status": sorted(allowed),
        "verdict": "PASS" if (status_ok and ok_verify) else "FAIL",
        "rule": "DEV→TEST EXEC PASS→then merge; neuro-ci alone insufficient",
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))

    if report["verdict"] != "PASS":
        print(
            "BLOCK: IPD TEST not ready — do not gh pr merge / do not merge to main",
            file=sys.stderr,
        )
        return 1 if args.gate else 0
    print("OK: IPD TEST gate green — still require neuro-ci + human review", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
