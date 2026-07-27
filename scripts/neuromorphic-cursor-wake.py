#!/usr/bin/env python3
"""类脑 Cursor hook：.neuro-brain-wake → sessionStart / stop 注入（类脑仓自有脚本）。

门禁（2026-07-20 收紧 · 2026-07-24 复发加固）：
- 仅投递「类脑专用工作区」（全部 workspace root 都在 neuromorphic 下）
  或「本会话已认领陈正共 / 有效 arm」
- 多根（vcompany+类脑+…）→ neuro_sidecar_in_multi_root，**禁止注入**
- 会话 claim=human-vp → 一律跳过（防 VP 窗 stop followup）
- 真源：本文件与 ~/.cursor/hooks/neuromorphic-cursor-wake.py 须同步；
  项目 hooks.json 指向本脚本。合 main / 检出后勿回退「任一 root 含类脑即注入」。
"""
from __future__ import annotations

import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

NEURO = Path(os.environ.get("NEUROMORPHIC_ROOT", "/home/cx/neuromorphic-computing")).resolve()
WAKE = NEURO / ".neuro-brain-wake"
LOG = NEURO / ".neuro-cursor-hook.log"
FOCUS = NEURO / "data" / ".neuro-ide-focus.json"
ARM = Path("/home/cx/vcompany/data/.neuro-agent-arm.json")
CLAIM_DIR = Path("/home/cx/vcompany/data/cursor-session-claims")
VC_ROOT = str(Path("/home/cx/vcompany").resolve())
NEURO_ROOT = str(NEURO)
NEURO_MEMBER = "ag-chenzhenggong"
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


def is_neuro_dedicated(roots: list[str]) -> bool:
    """全部根都在类脑仓下 → 专用窗。"""
    if not roots:
        return False
    for r in roots:
        if r == NEURO_ROOT or r.startswith(NEURO_ROOT + os.sep):
            continue
        return False
    return True


def has_neuro_root(roots: list[str]) -> bool:
    for r in roots:
        if r == NEURO_ROOT or r.startswith(NEURO_ROOT + os.sep):
            return True
    return False


def has_vcompany_root(roots: list[str]) -> bool:
    for r in roots:
        if r == VC_ROOT or r.startswith(VC_ROOT + os.sep):
            return True
    return False


def conversation_id(payload: dict) -> str:
    for key in ("conversation_id", "conversationId", "composerId", "session_id", "sessionId"):
        val = payload.get(key)
        if isinstance(val, str) and val.strip():
            return val.strip()
    env = payload.get("env") or {}
    for key in ("CURSOR_CONVERSATION_ID", "CONVERSATION_ID"):
        val = env.get(key) or os.environ.get(key)
        if isinstance(val, str) and val.strip():
            return val.strip()
    return ""


def session_claim_member(payload: dict) -> str | None:
    cid = conversation_id(payload)
    if not cid:
        return None
    p = CLAIM_DIR / f"{cid}.json"
    if not p.is_file():
        return None
    try:
        doc = json.loads(p.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return None
    mid = doc.get("memberId")
    return mid if isinstance(mid, str) else None


def neuro_session_claimed(payload: dict) -> bool:
    env = payload.get("env") or {}
    ch = env.get("NEURO_BRAIN_CHANNEL") or os.environ.get("NEURO_BRAIN_CHANNEL")
    return ch in (NEURO_MEMBER, "ag-chenzhenggong", "ChenZhengGong", "chenzhenggong")


def arm_valid() -> bool:
    if not ARM.is_file():
        return False
    try:
        doc = json.loads(ARM.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return False
    if doc.get("agent_id") not in ("ChenZhengGong", "ag-chenzhenggong", NEURO_MEMBER):
        return False
    exp = doc.get("expires_at") or ""
    if not exp:
        return True
    try:
        # allow Z or +08:00
        ts = datetime.fromisoformat(exp.replace("Z", "+00:00"))
        now = datetime.now(tz=ts.tzinfo or timezone.utc)
        return now <= ts
    except ValueError:
        return False


def should_activate_neuro(payload: dict, event: str = "") -> tuple[bool, str]:
    roots = extract_workspace_roots(payload)
    if not roots:
        return False, "no_workspace"

    claim = session_claim_member(payload)
    # VP 会话认领：多根旁挂类脑也绝不注入
    if claim == "human-vp" and not is_neuro_dedicated(roots):
        return False, "session_claim_human-vp"

    # 显式 VP 通道
    env = payload.get("env") or {}
    if env.get("VP_BRAIN_CHANNEL") == "human-vp" and not is_neuro_dedicated(roots):
        return False, "env_vp_brain_channel"

    # 1) 类脑专用工作区 → 可注入
    if is_neuro_dedicated(roots):
        return True, "neuro_dedicated"

    # 多根含 vcompany：一律当 VP sidecar，禁止靠 arm/channel 误灌
    if has_vcompany_root(roots) and has_neuro_root(roots) and not is_neuro_dedicated(roots):
        return False, "neuro_sidecar_in_multi_root"

    # 2) 本会话已钉死陈正共通道（且非 VP 多根）
    if neuro_session_claimed(payload):
        return True, "neuro_channel_claimed"

    # 3) 有效 arm（陈正共主动认领）且工作区至少挂了类脑仓——但仍禁止 vcompany 多根
    if arm_valid() and has_neuro_root(roots) and not has_vcompany_root(roots):
        return True, "neuro_arm_valid"

    # 多根非 VP 但挂了类脑：仍拒绝（须专用窗）
    if has_neuro_root(roots):
        return False, "neuro_sidecar_in_multi_root"
    return False, f"mismatch:{roots[:2]}"


def workspace_is_neuro(payload: dict) -> tuple[bool, str]:
    ok, reason = should_activate_neuro(payload, payload.get("hook_event_name", ""))
    if ok:
        return True, f"neuro:{reason}"
    return False, reason


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
        out["env"] = {
            "NEURO_BRAIN_WAKE": "1",
            "NEUROMORPHIC_ROOT": NEURO_ROOT,
            "NEURO_BRAIN_CHANNEL": NEURO_MEMBER,
        }
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
