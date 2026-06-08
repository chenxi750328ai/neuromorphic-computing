#!/usr/bin/env python3
"""类脑计算 · 研究项目 QA 门禁一键跑（裁剪版）。

Usage:
  python3 scripts/qa-neuro-baseline-run.py
  python3 scripts/qa-neuro-baseline-run.py --tier ci
  python3 scripts/qa-neuro-baseline-run.py --only N-CI-SMOKE
"""
from __future__ import annotations

import argparse
import json
import py_compile
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASELINE = ROOT / "config" / "neuro-qa-gate-baseline.json"


def gate_syntax() -> tuple[str, str]:
    scripts = sorted((ROOT / "scripts").glob("*.py"))
    failed = []
    for path in scripts:
        try:
            py_compile.compile(str(path), doraise=True)
        except py_compile.PyCompileError as exc:
            failed.append(f"{path.name}: {exc}")
    if failed:
        return "fail", "; ".join(failed)
    return "pass", f"{len(scripts)} scripts ok"


def gate_smoke() -> tuple[str, str]:
    r = subprocess.run(
        [sys.executable, "-m", "unittest", "discover", "-s", "tests", "-p", "test_*.py", "-q"],
        cwd=str(ROOT),
        capture_output=True,
        text=True,
    )
    out = ((r.stdout or "") + (r.stderr or "")).strip()
    snippet = out.splitlines()[-1] if out else f"exit={r.returncode}"
    if r.returncode == 0:
        return "pass", snippet[:200]
    return "fail", snippet[:400]


def gate_shell() -> tuple[str, str]:
    sh_files = sorted((ROOT / "scripts").glob("*.sh"))
    if not sh_files:
        return "pass", "no shell scripts"
    if not subprocess.run(["bash", "-c", "command -v shellcheck"], capture_output=True).returncode == 0:
        return "warn", "shellcheck not installed, skip"
    cmd = ["shellcheck", "-e", "SC2012"] + [str(p) for p in sh_files]
    r = subprocess.run(cmd, capture_output=True, text=True)
    out = ((r.stdout or "") + (r.stderr or "")).strip()
    if r.returncode == 0:
        return "pass", f"{len(sh_files)} scripts ok"
    return "fail", out.splitlines()[0][:200] if out else f"exit={r.returncode}"


def gate_docs() -> tuple[str, str]:
    r = subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "qa-neuro-doc-check.py")],
        cwd=str(ROOT),
        capture_output=True,
        text=True,
    )
    out = ((r.stdout or "") + (r.stderr or "")).strip()
    snippet = out.splitlines()[-1] if out else f"exit={r.returncode}"
    if r.returncode == 0:
        return "pass", snippet[:200]
    if r.returncode == 2:
        return "warn", snippet[:200]
    return "fail", snippet[:200]


RUNNERS = {
    "N-CI-SYNTAX": gate_syntax,
    "N-CI-SMOKE": gate_smoke,
    "N-CI-SHELL": gate_shell,
    "N-CI-DOCS": gate_docs,
}


def main() -> int:
    p = argparse.ArgumentParser(description="Neuro research QA baseline")
    p.add_argument("--tier", default="ci", help="ci | pre_merge | all")
    p.add_argument("--only", default="", help="single gate id")
    p.add_argument("--json", action="store_true")
    args = p.parse_args()

    if not BASELINE.is_file():
        print("FAIL missing neuro-qa-gate-baseline.json", file=sys.stderr)
        return 2

    data = json.loads(BASELINE.read_text(encoding="utf-8"))
    tiers = {"ci", "pre_merge"} if args.tier == "all" else {args.tier}

    results = []
    failed = 0
    warned = 0
    for gate in data.get("gates", []):
        gid = gate["id"]
        if args.only and gid != args.only:
            continue
        if not args.only and gate.get("tier") not in tiers:
            continue
        if gid in RUNNERS:
            status, msg = RUNNERS[gid]()
        elif gid.startswith("N-PRE-MERGE") or gid.startswith("N-PHASE"):
            sp = ROOT / gate["script"]
            cmd = [sys.executable, str(sp), *(gate.get("args") or [])]
            r = subprocess.run(cmd, cwd=str(ROOT), capture_output=True, text=True)
            out = ((r.stdout or "") + (r.stderr or "")).strip()
            snippet = out.splitlines()[-1] if out else f"exit={r.returncode}"
            if r.returncode == 0:
                status, msg = "pass", snippet[:200]
            elif r.returncode == 2:
                status, msg = "warn", snippet[:200]
                warned += 1
            else:
                status, msg = "fail", snippet[:200]
                failed += 1
            results.append({"id": gid, "status": status, "detail": msg})
            if not args.json:
                icon = {"pass": "✓", "fail": "✗", "warn": "△"}[status]
                print(f"{icon} {gid}: {msg}")
            continue
        else:
            status, msg = "skip", "no local runner"
        if status == "fail":
            failed += 1
        elif status == "warn":
            warned += 1
        results.append({"id": gid, "status": status, "detail": msg})
        if not args.json:
            icon = {"pass": "✓", "fail": "✗", "warn": "△", "skip": "○"}[status]
            print(f"{icon} {gid}: {msg}")

    summary = {"failed": failed, "warned": warned, "results": results}
    if args.json:
        print(json.dumps(summary, ensure_ascii=False, indent=2))
    if failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
