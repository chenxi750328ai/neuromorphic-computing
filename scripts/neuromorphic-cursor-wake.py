#!/usr/bin/env python3
"""类脑 Cursor hook：.neuro-brain-wake → sessionStart / stop 注入（类脑仓自有脚本）。"""
from __future__ import annotations

import json
import os
import sys
from datetime import datetime
from pathlib import Path

NEURO = Path(os.environ.get("NEUROMORPHIC_ROOT", "/home/cx/neuromorphic-computing")).resolve()
WAKE = NEURO / ".neuro-brain-wake"
LOG = NEURO / ".neuro-cursor-hook.log"
NEURO_ROOT = str(NEURO)
MAX_STOP_FOLLOWUPS = 1


def load_wake() -> dict | None:
    if not WAKE.is_file():
        return None
    try:
        return json.loads(WAKE.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return None


def save_wake(wake: dict) -> None:
    WAKE.write_text(json.dumps(wake, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def archive_consumed(wake: dict) -> None:
    if not (wake.get("cursor") or {}).get("consumed"):
        return
    done = NEURO / "data" / ".neuro-brain-wake.done.jsonl"
    done.parent.mkdir(parents=True, exist_ok=True)
    with done.open("a", encoding="utf-8") as f:
        f.write(json.dumps(wake, ensure_ascii=False) + "\n")
    WAKE.unlink(missing_ok=True)


def extract_workspace_roots(payload: dict) -> list[str]:
    roots: list[str] = []
    for key in ("workspace_roots", "workspaceRoots", "workspace_root", "rootPath", "projectPath", "cwd"):
        val = payload.get(key)
        if isinstance(val, list):
            roots.extend(str(x) for x in val if x)
        elif isinstance(val, str) and val.strip():
            roots.append(val.strip())
    out: list[str] = []
    for r in roots:
        try:
            out.append(str(Path(r).resolve()))
        except OSError:
            out.append(r)
    return out


def workspace_is_neuro(payload: dict) -> tuple[bool, str]:
    roots = extract_workspace_roots(payload)
    if not roots:
        return False, "no_workspace"
    for r in roots:
        if r == NEURO_ROOT or r.startswith(NEURO_ROOT + os.sep):
            return True, "neuro_root"
    return False, f"mismatch:{roots[:2]}"


def should_inject(wake: dict | None) -> bool:
    if not wake:
        return False
    if not (wake.get("instruction") or "").strip():
        return False
    return not (wake.get("cursor") or {}).get("consumed")


def build_context(wake: dict) -> str:
    return (wake.get("instruction") or "").strip()


def log_event(event: str, **fields) -> None:
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with LOG.open("a", encoding="utf-8") as f:
        f.write(json.dumps({"ts": datetime.now().astimezone().isoformat(), "event": event, **fields}, ensure_ascii=False) + "\n")


def main() -> None:
    payload = json.loads(sys.stdin.read() or "{}")
    event = payload.get("hook_event_name", "")
    out: dict = {}
    ok, ws_reason = workspace_is_neuro(payload)

    if not ok:
        log_event(event, skipped=True, reason=ws_reason)
        print(json.dumps(out, ensure_ascii=False))
        return

    wake = load_wake()
    if wake and (wake.get("cursor") or {}).get("consumed"):
        archive_consumed(wake)
        wake = load_wake()

    if event in ("sessionStart", "beforeSubmitPrompt") and should_inject(wake):
        ctx = build_context(wake)
        prefix = "" if ctx.startswith("【类脑") else "[类脑·陈正共·自驱唤醒]\n"
        out["additional_context"] = prefix + ctx
        out["env"] = {"NEURO_BRAIN_WAKE": "1", "NEUROMORPHIC_ROOT": NEURO_ROOT}
        wake.setdefault("cursor", {})
        wake["cursor"]["injected_at"] = datetime.now().astimezone().isoformat()
        save_wake(wake)

    if event == "stop":
        status = payload.get("status", "")
        loop_count = int(payload.get("loop_count") or 0)
        cur = (wake or {}).get("cursor") or {}
        followups = int(cur.get("followup_count") or 0)
        if status == "completed" and should_inject(wake) and followups < MAX_STOP_FOLLOWUPS:
            ctx = build_context(wake)
            prefix = "" if ctx.startswith("【类脑") else "[类脑·陈正共·自驱唤醒]\n"
            out["followup_message"] = prefix + ctx
            wake.setdefault("cursor", {})
            wake["cursor"]["followup_sent"] = True
            wake["cursor"]["followup_count"] = followups + 1
            wake["cursor"]["last_hook_at"] = datetime.now().astimezone().isoformat()
            save_wake(wake)
        elif wake and cur.get("followup_sent") and loop_count >= 1:
            wake.setdefault("cursor", {})
            wake["cursor"]["consumed"] = True
            wake["cursor"]["auto_consumed"] = True
            wake["cursor"]["auto_consumed_reason"] = "stop_followup_done"
            save_wake(wake)
            archive_consumed(wake)

    log_event(event, has_wake=bool(wake), workspace=ws_reason, out_keys=list(out.keys()))
    print(json.dumps(out, ensure_ascii=False))


if __name__ == "__main__":
    main()
