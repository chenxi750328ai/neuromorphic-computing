#!/usr/bin/env python3
"""类脑小脑 — 读燃尽/每日计划 backlog，写 .neuro-brain-wake（类脑仓自有脚本）。"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

NEURO = Path(os.environ.get("NEUROMORPHIC_ROOT", Path(__file__).resolve().parents[1])).resolve()
VC = Path(os.environ.get("VCOMPANY_ROOT", "/home/cx/vcompany"))
WAKE = NEURO / ".neuro-brain-wake"
MILESTONES = VC / "data/neuromorphic-milestones.json"
DAILY_PLAN = NEURO / "docs/每日计划.md"
LAST = NEURO / "data/.neuro-cerebellum-last.json"
CONFIG = NEURO / "config/neuro-cerebellum-config.json"

DEFAULT_CONFIG = {"poll_interval_sec": 600, "min_wake_interval_sec": 300, "stale_wake_sec": 3600}


def _now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat()


def load_config() -> dict:
    if CONFIG.is_file():
        try:
            return {**DEFAULT_CONFIG, **json.loads(CONFIG.read_text(encoding="utf-8"))}
        except json.JSONDecodeError:
            pass
    return dict(DEFAULT_CONFIG)


def load_json(path: Path) -> dict:
    if not path.is_file():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}


def parse_backlog(md: str) -> list[dict]:
    items: list[dict] = []
    in_backlog = False
    for line in md.splitlines():
        if re.match(r"^##\s+待办 backlog", line):
            in_backlog = True
            continue
        if in_backlog and line.startswith("## "):
            break
        if not in_backlog or not line.startswith("| P"):
            continue
        cols = [c.strip() for c in line.split("|") if c.strip()]
        if len(cols) < 2 or cols[0] in ("优先级", "---"):
            continue
        pri, body = cols[0], cols[1]
        title = re.sub(r"\*\*", "", body)
        title = re.sub(r"\[.*?\]\(.*?\)", lambda m: m.group(0).split("]")[0][1:], title)
        items.append(
            {
                "todoId": f"backlog-{len(items)}",
                "title": title.strip(),
                "priority": pri,
                "status": "待办",
            }
        )
    return items


def collect_pending() -> tuple[list[dict], dict]:
    stem: dict = {}
    pending: list[dict] = []

    if MILESTONES.is_file():
        m = load_json(MILESTONES)
        stem = {
            "ts": _now(),
            "current_gate": m.get("current_gate"),
            "headline": m.get("headline"),
            "focus": m.get("focus") or [],
        }
        for i, f in enumerate(m.get("focus") or []):
            pending.append(
                {
                    "todoId": f"focus-{i}",
                    "title": f,
                    "priority": "P0",
                    "status": "待办",
                }
            )

    if DAILY_PLAN.is_file():
        for item in parse_backlog(DAILY_PLAN.read_text(encoding="utf-8")):
            if not any(p["title"] == item["title"] for p in pending):
                pending.append(item)

    return pending, stem


def build_instruction(pending: list[dict], stem: dict) -> str:
    lines = [
        "【类脑·陈正共·自驱唤醒】",
        "身份：陈正共 ChenZhengGong · 类脑计算 PL。",
        "规则：commit message 须含陈正共或 ChenZhengGong；开发在 feature/* 分支；合 main 须 neuro-ci 绿。",
        "",
        f"关口：{stem.get('current_gate', '—')} · {stem.get('headline', '')}",
        "",
        "待办（按优先级执行，做完更新 docs/每日计划.md 与 reports/daily_progress.md）：",
    ]
    for i, p in enumerate(pending[:8], 1):
        lines.append(f"{i}. [{p.get('priority', 'P?')}] {p.get('title', '')}")
    lines.extend(
        [
            "",
            "收工：更新 neuromorphic-milestones.json；设 wake cursor.consumed=true；",
            "若无剩余待办可不写新 wake。",
        ]
    )
    return "\n".join(lines)


def should_skip_write(force: bool) -> str | None:
    if force:
        return None
    if not WAKE.is_file():
        return None
    wake = load_json(WAKE)
    cur = wake.get("cursor") or {}
    if cur.get("consumed"):
        return None
    ts = wake.get("ts")
    stale_sec = load_config().get("stale_wake_sec", 3600)
    if ts:
        try:
            age = (datetime.now().astimezone() - datetime.fromisoformat(ts)).total_seconds()
            if age >= stale_sec:
                return None  # 过期未消费 → 允许刷新，避免小脑僵死
            if age < load_config().get("min_wake_interval_sec", 300):
                return f"recent_wake_{age:.0f}s"
        except ValueError:
            pass
    if wake.get("instruction") and not cur.get("consumed"):
        return "unconsumed_wake_exists"
    return None


def _sync_dashboard(wake: dict) -> None:
    import importlib.util

    spec = importlib.util.spec_from_file_location("neuro_dashboard_sync", NEURO / "scripts" / "neuro-dashboard-sync.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    mod.sync_dashboard(wake)


def routine_tick(argv: list[str] | None = None) -> int:
    """例行一轮：刷新看板/总裁汇报 → 小脑 wake 逻辑。"""
    try:
        _sync_dashboard({})
    except Exception as exc:
        print(f"[routine] dashboard sync warn: {exc}", file=sys.stderr)
    clean = [a for a in (argv or []) if a not in ("--once", "--daemon")]
    return wake_tick(clean)


def wake_tick(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description="Neuro cerebellum tick")
    p.add_argument("--force", action="store_true", help="overwrite existing unconsumed wake")
    p.add_argument("--json", action="store_true")
    args = p.parse_args(argv)

    skip = should_skip_write(args.force)
    pending, stem = collect_pending()
    if not pending:
        result = {"ok": True, "action": "noop", "reason": "no_pending"}
        if args.json:
            print(json.dumps(result, ensure_ascii=False))
        else:
            print("noop: no pending items")
        return 0

    if skip:
        result = {"ok": True, "action": "skip", "reason": skip, "pending_count": len(pending)}
        if args.json:
            print(json.dumps(result, ensure_ascii=False))
        else:
            print(f"skip: {skip} ({len(pending)} pending)")
        return 0

    instruction = build_instruction(pending, stem)
    wake = {
        "ts": _now(),
        "reason": "daily_plan_pending",
        "action": "neuro_execute",
        "agent_id": "ChenZhengGong",
        "display_name": "陈正共",
        "agent": "ChenZhengGong",
        "stem": stem,
        "pending": pending,
        "instruction": instruction,
        "cursor": {"consumed": False, "source": "neuromorphic-cerebellum"},
    }
    WAKE.parent.mkdir(parents=True, exist_ok=True)
    WAKE.write_text(json.dumps(wake, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    LAST.parent.mkdir(parents=True, exist_ok=True)
    LAST.write_text(
        json.dumps({"ts": _now(), "pending_count": len(pending), "headline": stem.get("headline")}, ensure_ascii=False, indent=2)
        + "\n",
        encoding="utf-8",
    )
    try:
        _sync_dashboard(wake)
    except Exception as exc:
        print(f"dashboard sync warn: {exc}", file=sys.stderr)
    result = {"ok": True, "action": "wake_written", "pending_count": len(pending), "wake": str(WAKE), "dashboard_synced": True}
    if args.json:
        print(json.dumps(result, ensure_ascii=False))
    else:
        print(f"wake written: {len(pending)} items -> {WAKE}")
    return 0


def main(argv: list[str] | None = None) -> int:
    if argv is None:
        argv = sys.argv[1:]
    if "--once" in argv:
        return routine_tick(argv)
    return wake_tick(argv)


if __name__ == "__main__":
    import time

    if "--daemon" in sys.argv:
        cfg = load_config()
        interval = int(cfg.get("poll_interval_sec", 600))
        log_path = VC / "data" / "neuromorphic-cerebellum.log"
        argv = [a for a in sys.argv[1:] if a != "--daemon"]
        while True:
            ts = _now()
            try:
                rc = routine_tick(argv)
                line = f"[{ts}] routine_tick rc={rc}\n"
            except Exception as exc:
                line = f"[{ts}] routine_tick error: {exc}\n"
            log_path.parent.mkdir(parents=True, exist_ok=True)
            with log_path.open("a", encoding="utf-8") as f:
                f.write(line)
            print(line.strip())
            time.sleep(interval)
    else:
        raise SystemExit(main())
