#!/usr/bin/env python3
"""小脑/收工后刷新类脑项目看板真源（milestones + live JSON + 项目看板.md）。"""
from __future__ import annotations

import json
import os
import re
from datetime import date, datetime, timezone
from pathlib import Path

NEURO = Path(os.environ.get("NEUROMORPHIC_ROOT", Path(__file__).resolve().parents[1])).resolve()
VC = Path(os.environ.get("VCOMPANY_ROOT", "/home/cx/vcompany"))
MILESTONES = VC / "data" / "neuromorphic-milestones.json"
LIVE = VC / "data" / "neuro-dashboard-live.json"
BRIEF_JSON = VC / "data" / "neuro-president-brief.json"
BRIEF_MD = NEURO / "docs" / "总裁汇报_最新.md"
APPROVAL = VC / "data" / "neuro-ipd-qa-approval.json"
QA_P4 = NEURO / "docs" / "QA_验收记录_Phase4.md"
BOARD_MD = NEURO / "docs" / "项目看板.md"
DAILY_PLAN = NEURO / "docs/每日计划.md"
DAILY_PROGRESS = NEURO / "reports/daily_progress.md"
WAKE = NEURO / ".neuro-brain-wake"


def _now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat()


def _today() -> str:
    return date.today().isoformat()


def load_json(path: Path) -> dict:
    if not path.is_file():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}


def parse_today_plan(md: str) -> list[dict]:
    rows: list[dict] = []
    today = _today()
    in_today = False
    for line in md.splitlines():
        if line.startswith("### ") and today in line:
            in_today = True
            continue
        if in_today and line.startswith("### "):
            break
        if not in_today or not line.startswith("|"):
            continue
        cols = [c.strip() for c in line.split("|") if c.strip()]
        if len(cols) >= 3 and cols[0].startswith("**"):
            kind = cols[0].strip("*")
            if kind in ("完成", "进行", "待办", "计划"):
                rows.append({"type": kind, "content": cols[1], "status": cols[2]})
    return rows


def parse_backlog(md: str) -> list[str]:
    items: list[str] = []
    in_backlog = False
    for line in md.splitlines():
        if re.match(r"^##\s+待办 backlog", line):
            in_backlog = True
            continue
        if in_backlog and line.startswith("## "):
            break
        if in_backlog and line.startswith("| P"):
            cols = [c.strip() for c in line.split("|") if c.strip()]
            if len(cols) >= 2 and cols[0] not in ("优先级", "---"):
                items.append(f"[{cols[0]}] {cols[1]}")
    return items[:6]


def parse_recent_progress(md: str) -> list[str]:
    m = re.search(r"^## (\d{4}-\d{2}-\d{2})\s*$", md, re.MULTILINE)
    if not m:
        return []
    start = m.start()
    nxt = re.search(r"^## \d{4}-\d{2}-\d{2}\s*$", md[m.end() :], re.MULTILINE)
    block = md[start : start + m.end() + nxt.start()] if nxt else md[start:]
    bullets = []
    for line in block.splitlines():
        line = line.strip()
        if line.startswith("- "):
            bullets.append(line[2:].strip())
    return bullets[:6]


def gate_phase4_active(gates: list[dict]) -> list[dict]:
    out = []
    for g in gates:
        g = dict(g)
        if g.get("id") == "phase4" and g.get("status") == "future":
            g["status"] = "active"
            g["pct"] = max(int(g.get("pct") or 0), 15)
        out.append(g)
    return out


def build_hero(headline: str, pending: list[dict]) -> str:
    top = pending[0]["title"] if pending else "无待办"
    return f"▶ {headline} · 当前推进：{top}"


def render_president_brief_md(brief: dict) -> str:
    b = brief
    delivered = "\n".join(f"| {d['phase']} | {d['result']} | {d['status']} |" for d in b.get("delivered") or [])
    phase4 = "\n".join(f"| {m['id']} | {m['title']} | {m['status']} |" for m in b.get("phase4_milestones") or [])
    approvals = "\n".join(f"| {a['role']} | {a['item']} | {a['status']} |" for a in b.get("approvals") or [])
    actions = b.get("president_actions") or []
    actions_md = "\n".join(f"- {a}" for a in actions) if actions else "- **暂无**：工程自驱推进，无需总裁日常介入"
    next_steps = "\n".join(f"- {n}" for n in b.get("next_steps") or [])
    return f"""# 类脑计算 · 总裁汇报（真源副本）

> **机读真源**：`vcompany/data/neuro-president-brief.json`  
> **自动刷新**：小脑写 wake → `neuro-dashboard-sync.py`  
> **看板**：http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html#president-brief  
> **更新**：{b.get("updated", "—")} · 汇报人：陈正共 · ChenZhengGong

---

## 一句话

{b.get("summary", "—")}

---

## 总体进度

| 指标 | 数值 |
|------|------|
| 完成度 | **{b.get("completed_pct", "—")}%**（剩余 {b.get("remaining_pct", "—")}%） |
| 当前关口 | **{b.get("current_gate", "—")}** |
| 窗口 | {b.get("window", "—")} |

---

## 已交付

| 阶段 | 核心结果 | 状态 |
|------|----------|------|
{delivered}

---

## Phase4 进展

| 里程碑 | 内容 | 状态 |
|--------|------|------|
{phase4}

---

## 流程与签字

| 角色 | 事项 | 状态 |
|------|------|------|
{approvals}

---

## 给总裁的简报

{b.get("brief_for_president", "—")}

---

## 可选批示 / 办事

{actions_md}

---

## 下一步

{next_steps}

## Git 合并审计

PR #2 合并者（GitHub 记录）：**`chenxi750328`** · commit `3e573a0` · 本机 Agent **未执行** merge。  
详见 [治理_Git合并审计.md](./治理_Git合并审计.md)。

---

*本文件由小脑同步生成；聊天汇报请以本页与看板为准。*
"""


def parse_phase4_status() -> dict:
    """从 QA 记录与 atlas 留档推断 M4-2/M4-3/M4-4 状态。"""
    out = {"s2b": "WARN/待跑", "s2_snn": "WARN", "m4_3": "⏳ 下一步", "m4_4": "待 M4-3", "s4": False}
    snn_manifest = load_json(NEURO / "runs" / "phase4_export" / "snn_manifest.json")
    if snn_manifest.get("status") == "ok":
        out["s2_snn"] = "PASS"
    align = load_json(NEURO / "runs" / "phase4_poc" / "snn_board_align.json")
    if align.get("aligned"):
        out["m4_3"] = "✅ 真 SNN OM · ORT 对齐 diff=0"
        out["m4_4"] = "✅ PR #5 已合 main"
    manifest = load_json(NEURO / "runs/phase4_export/surrogate_manifest.json")
    if manifest.get("status") == "ok":
        out["s2b"] = "PASS"
    atlas_log = NEURO / "runs/phase4_poc/atlas_smoke.log"
    if atlas_log.is_file() and "PASS" in atlas_log.read_text(encoding="utf-8", errors="replace"):
        out["m4_3"] = "✅ MNIST OM ~0.86ms"
        out["m4_4"] = "⏳ 待 PR"
    if QA_P4.is_file():
        qa = QA_P4.read_text(encoding="utf-8", errors="replace")
<<<<<<< HEAD
        if "S3 · 硬件冒烟" in qa and "真 SNN" in qa and "**PASS**" in qa.split("S3 · 硬件冒烟")[1].split("\n")[0]:
            out["m4_3"] = "✅ 真 SNN OM · ORT 对齐"
=======
        if "S3 · 硬件冒烟" in qa and "**PASS**" in qa.split("S3 · 硬件冒烟")[1].split("\n")[0]:
            out["m4_3"] = "✅ 真 SNN OM · ORT 对齐"
            out["m4_4"] = "✅ PR #3 已合 main"
        elif "S3b" in qa and "surrogate" in qa.lower():
            pass
        snn_manifest = load_json(NEURO / "runs" / "phase4_export" / "snn_manifest.json")
>>>>>>> origin/main
        if snn_manifest.get("status") == "ok":
            out["s2_snn"] = "PASS"
        if "S4 · CI" in qa and "**PASS**" in qa.split("S4 · CI")[1].split("\n")[0]:
            out["s4"] = True
            if "PR #5" in qa.split("S4 · CI")[1]:
                out["m4_4"] = "✅ PR #5 已合 main"
            else:
                out["m4_4"] = "✅ PR #3 已合 main"
    return out


def build_president_brief(ms: dict, live: dict) -> dict:
    burndown = ms.get("burndown") or {}
    completed = burndown.get("completed_points", 78)
    remaining = burndown.get("remaining_points", 22)
    window = ms.get("window") or {}
    approval = load_json(APPROVAL)
    p4 = parse_phase4_status()
    m4_3_done = p4["m4_3"].startswith("✅")
    m4_4_done = p4["m4_4"].startswith("✅")

    brief = {
        "updated": _now(),
        "report_date": _today(),
        "owner": "陈正共 · ChenZhengGong",
        "summary": (
            f"TR1～Phase4 v0 已合 main（含真 SNN 上板 PR #5）；"
            f"整体完成约 {completed}%。"
            if p4.get("s2_snn") == "PASS" and m4_3_done
            else (
                f"TR1～Phase3 已合 main；总裁已批 IPD/QA 裁剪；"
                f"Phase4 v0 PoC {'已合 main（PR #3）' if m4_4_done else ('Atlas 推理已冒烟通过' if m4_3_done else '进行中')}，"
                f"整体完成约 {completed}%。"
            )
        ),
        "completed_pct": completed,
        "remaining_pct": remaining,
        "current_gate": ms.get("current_gate", "phase4"),
        "headline": ms.get("headline", ""),
        "window": f"{window.get('start', '—')} → {window.get('target_end', '—')}",
        "dashboard_url": "http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html",
        "brief_md_path": "neuromorphic-computing/docs/总裁汇报_最新.md",
        "delivered": [
            {"phase": "TR1", "result": "2026-05-28 总裁拍板", "status": "✅"},
            {"phase": "Phase1 SNN", "result": "test 96.97%", "status": "✅"},
            {"phase": "Phase2 ANN", "result": "test 98.10%", "status": "✅"},
            {"phase": "Phase3 小样本", "result": "ANN 96.32% · SNN 89.23%", "status": "✅"},
            {"phase": "IPD/QA", "result": "研究轨裁剪 · 总裁已批准", "status": "✅"},
            {"phase": "PR #2", "result": "IPD/QA + Phase3 + neuro-ci", "status": "✅ 已合 main"},
        ],
        "phase4_milestones": [
            {"id": "M4-1", "title": "TR2 轻评审草案", "status": "✅ 已出稿"},
            {"id": "M4-2", "title": "4090 复现 + 模型导出", "status": "✅ S1 PASS · S2 SNN " + p4.get("s2_snn", "WARN")},
            {"id": "M4-3", "title": "Atlas 200DK 冒烟", "status": p4["m4_3"]},
            {"id": "M4-4", "title": "Phase4 QA + 合 main", "status": p4["m4_4"]},
        ],
        "approvals": [
            {
                "role": "总裁",
                "item": "IPD/QA 研究轨裁剪",
                "status": "✅ APPROVED" if approval.get("decision") == "APPROVED" else "⏳",
            },
            {"role": "VP", "item": "裁剪方案 5 点", "status": "✅ 已确认（CI 不裁剪）"},
            {"role": "VP", "item": "Phase1–3 QA signoff", "status": "⏳ VP_QA: PASS 待补"},
            {"role": "VP/总裁", "item": "TR2 Phase4 轻评审", "status": "⏳ 草案待勾选"},
        ],
        "brief_for_president": (
            "Phase4 v0 PoC 工程已收工并合入 main（PR #3，neuro-ci 绿）：4090 复现、ANN 近似 ONNX、"
            "CPU/Atlas 冒烟均 PASS。"
            if m4_4_done
            else (
                "Phase4 核心工程已跑通：4090 复现、ANN 近似 ONNX 导出、CPU 冒烟"
                + ("，以及 **Atlas 200I DK 上 MNIST surrogate OM 推理**（AclLite PASS，延迟约 0.86ms）。"
                   if m4_3_done else "；下一步是 Atlas 板子冒烟。")
            )
            + " SNN 直导 ONNX 仍标 WARN（LIF 算子）。"
            + (" 剩 TR2 轻评审签字与 VP QA 可后补。" if m4_4_done
               else " 下一步是 TR2 轻评审勾选「Atlas 优先」与 Phase4 分支合 main；日常工程陈正共自驱，不必您盯。")
        ),
        "president_actions": [
            "（可选）阅读 [TR2 Phase4 轻评审草案](http://127.0.0.1:18766/dashboard/md-viewer.html?src=%2Fdocs%2Fneuromorphic-computing%2FTR2_Phase4_%E8%BD%BB%E8%AF%84%E5%AE%A1%E8%8D%89%E6%A1%88.md&from=neuro&review=REV-document-neuro-TR2-Phase4) 勾选 **路径 A · Atlas 优先**",
        ],
        "next_steps": live.get("focus") or ms.get("focus") or [],
        "git_audit": {
            "pr2_merged_by": "chenxi750328",
            "pr2_merge_commit": "3e573a0",
            "agent_did_merge": False,
            "doc": "neuromorphic-computing/docs/治理_Git合并审计.md",
        },
        "recent_progress": live.get("recent_progress") or [],
    }
    return brief


def sync_president_brief(ms: dict, live: dict) -> dict:
    brief = build_president_brief(ms, live)
    BRIEF_JSON.write_text(json.dumps(brief, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    BRIEF_MD.write_text(render_president_brief_md(brief), encoding="utf-8")
    return brief


def render_board_md(ms: dict, live: dict) -> str:
    gates = {g["id"]: g for g in ms.get("gates") or []}
    p4 = gates.get("phase4", {})
    p4_status = parse_phase4_status()
    p4_line = "筹备中"
    if p4.get("status") == "done":
        p4_line = f"**✅ 完成** {p4.get('pct', 100)}% · 真 SNN 上板"
    elif p4.get("status") == "active":
        suffix = " · PR #3 ✓" if p4_status.get("s4") else (" · M4-3 **PASS**" if p4_status["m4_3"].startswith("✅") else " · Atlas 优先")
        p4_line = f"**进行中** {p4.get('pct', 0)}%{suffix}"
    focus = live.get("focus") or []
    focus_ul = "\n".join(f"- {f}" for f in focus) or "- （无）"
    pending_ul = "\n".join(f"- {p['title']}" for p in live.get("pending") or []) or "- （无）"
    return f"""# 类脑计算 · 项目看板

> **浏览器（推荐）：** http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html  
> 服务未起时：`python3 /home/cx/vcompany/scripts/vp-dashboard-serve.py`  
> **自动刷新**：小脑写 wake 时由 `scripts/neuro-dashboard-sync.py` 更新（{_now()}）

## 当前状态（{ _today() }）

| 阶段 | 状态 |
|------|------|
| TR1 | ✅ 2026-05-28 总裁拍板 |
| Phase1 SNN | ✅ test **96.97%** |
| Phase2 ANN | ✅ test **98.10%** · PR #1 已合并 |
| Phase3 小样本 | ✅ v0 收尾 |
| Phase4 | {p4_line} · [TR2 草案](./TR2_Phase4_轻评审草案.md) |
| IPD/QA | ✅ 总裁已批准 · ✅ PR #2 已合 main |

**关口**：{ms.get("headline", "—")}

## 小脑 focus

{focus_ul}

## 待办（唤醒纸条）

{pending_ul}

## 链接

| 项 | URL |
|----|-----|
| TR1 网页看板 | http://127.0.0.1:18766/dashboard/neuromorphic-tr1.html |
| 每日计划 | http://127.0.0.1:18766/dashboard/md-viewer.html?src=%2Fdocs%2Fneuromorphic-computing%2F%E6%AF%8F%E6%97%A5%E8%AE%A1%E5%88%92.md |
| 总裁汇报 | http://127.0.0.1:18766/dashboard/md-viewer.html?src=%2Fdocs%2Fneuromorphic-computing%2F%E6%80%BB%E8%A3%81%E6%B1%87%E6%8A%A5_%E6%9C%80%E6%96%B0.md&from=neuro |
| Phase4 PoC | [phase4_inference_poc_plan.md](./phase4_inference_poc_plan.md) |
| Atlas 连接 | [Atlas_200I_DK_配置与连接状态.md](./Atlas_200I_DK_配置与连接状态.md) |
| GitHub | https://github.com/chenxi750328ai/neuromorphic-computing |

---

*陈正共 · ChenZhengGong · 看板由小脑自动同步*
"""


def sync_dashboard(wake: dict | None = None) -> dict:
    ms = load_json(MILESTONES)
    wake = wake or load_json(WAKE)
    stem = wake.get("stem") or {}
    pending = wake.get("pending") or []
    if not pending and MILESTONES.is_file():
        m = ms
        pending = [{"title": t, "priority": "P0", "status": "待办"} for t in (m.get("focus") or [])]

    headline = stem.get("headline") or ms.get("headline") or "类脑计算"
    focus = stem.get("focus") or [p.get("title", "") for p in pending[:3]]
    current_gate = stem.get("current_gate") or ms.get("current_gate") or "phase4"

    plan_md = DAILY_PLAN.read_text(encoding="utf-8") if DAILY_PLAN.is_file() else ""
    prog_md = DAILY_PROGRESS.read_text(encoding="utf-8") if DAILY_PROGRESS.is_file() else ""

    live = {
        "updated": _now(),
        "wake_ts": wake.get("ts"),
        "wake_consumed": bool((wake.get("cursor") or {}).get("consumed")),
        "headline": headline,
        "current_gate": current_gate,
        "hero": build_hero(headline, pending),
        "focus": focus,
        "pending": pending,
        "backlog": parse_backlog(plan_md),
        "today_plan": parse_today_plan(plan_md),
        "recent_progress": parse_recent_progress(prog_md),
    }

    gates = gate_phase4_active(ms.get("gates") or [])
    ms_out = {
        **ms,
        "updated": _now(),
        "current_gate": current_gate,
        "headline": headline,
        "focus": focus,
        "gates": gates,
    }
    MILESTONES.parent.mkdir(parents=True, exist_ok=True)
    MILESTONES.write_text(json.dumps(ms_out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    LIVE.write_text(json.dumps(live, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    BOARD_MD.write_text(render_board_md(ms_out, live), encoding="utf-8")
    sync_president_brief(ms_out, live)
    return {
        "ok": True,
        "milestones": str(MILESTONES),
        "live": str(LIVE),
        "board": str(BOARD_MD),
        "president_brief": str(BRIEF_JSON),
    }


def main() -> int:
    import argparse

    p = argparse.ArgumentParser(description="Sync neuro dashboard from wake/plan")
    p.add_argument("--json", action="store_true")
    args = p.parse_args()
    result = sync_dashboard()
    if args.json:
        print(json.dumps(result, ensure_ascii=False))
    else:
        print(f"dashboard synced -> {result['live']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
