#!/usr/bin/env python3
"""按项目目标 G1–G8 验证（陈正共）— 对独立评审成功标准做机读对照。

不把执行方流程表当标尺；只报目标达成度。
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DEFAULT = ROOT / "docs" / "phase4_poc_evidence" / "fpga_goal_verify_G1_G8.json"


def rg_count(pattern: str, path: str) -> int:
    r = subprocess.run(
        ["rg", "-n", pattern, path, "-g", "!phase4_fpga_goal_verify.py"],
        cwd=str(ROOT),
        capture_output=True,
        text=True,
    )
    if r.returncode not in (0, 1):
        return -1
    lines = [ln for ln in (r.stdout or "").splitlines() if ln.strip()]
    return len(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=OUT_DEFAULT)
    ap.add_argument("--gate", action="store_true", help="要求全部 G 达标才 exit 0（当前预期 FAIL）")
    args = ap.parse_args()

    goals: dict = {}

    # G1 开源出 lif_step bit（含 soft-mul lif_open）
    lif_candidates = [
        ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_try_lif_axi.json",
        ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_try_lif_open.json",
        ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_lif_probe.json",
    ]
    soft = ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_try.json"
    g1_ok = False
    g1_note = "no openXC7 lif_step bitstream"
    g1_ev = None
    for lif_probe in lif_candidates:
        if not lif_probe.is_file():
            continue
        d = json.loads(lif_probe.read_text(encoding="utf-8"))
        design = str(d.get("design", "")).lower()
        if d.get("pass_full_open_bit") and "lif" in design:
            g1_ok = True
            g1_note = d.get("conclusion") or "OPEN_BITSTREAM_OK"
            g1_ev = str(lif_probe.relative_to(ROOT))
            break
        g1_note = d.get("conclusion") or g1_note
        g1_ev = str(lif_probe.relative_to(ROOT))
    goals["G1"] = {
        "title": "交付核开源出 bit",
        "ok": g1_ok,
        "note": g1_note,
        "evidence": g1_ev,
    }

    # G2 开源 bit 上板≡金标（需开源 lif bit；点灯上板不算）
    board = ROOT / "docs" / "phase4_poc_evidence" / "fpga_z2_openxc7_board_load.json"
    a2 = ROOT / "docs" / "phase4_poc_evidence" / "fpga_ra_atlas_mlif_inchain_gate.json"
    g2_ok = False
    g2_note = "开源 lif bit 未交付；现入链用 Vivado bit"
    if a2.is_file():
        d = json.loads(a2.read_text(encoding="utf-8"))
        bit = str(d.get("bit") or "")
        if "openxc7" in bit or "openXC7" in bit:
            g2_ok = str(d.get("verdict", "")).startswith("PASS") and float(
                (d.get("compare") or {}).get("pred_match_rate") or 0
            ) >= 1.0
            g2_note = d.get("verdict")
        else:
            g2_note = f"入链 bit 非开源: {bit or 'vivado overlay'}"
    goals["G2"] = {"title": "开源 bit 上板≡金标", "ok": g2_ok, "note": g2_note}

    # G3 金标独立（启发式：verilator gate 是否引用 fixedpoint 模块路径）
    vgate = ROOT / "scripts" / "phase4_fpga_lif_verilator_gate.py"
    text = vgate.read_text(encoding="utf-8") if vgate.is_file() else ""
    g3_ok = "fixedpoint" in text.lower() and "FixedPointLIF" in text
    goals["G3"] = {
        "title": "主信任根金标独立",
        "ok": g3_ok,
        "note": "需 TB 引用 FixedPointLIF 而非内嵌复刻；当前启发式"
        + (" PASS" if g3_ok else " FAIL"),
    }

    # G4 第三方干净机复现
    lock = ROOT / "third_party.lock"
    goals["G4"] = {
        "title": "干净机可复现",
        "ok": lock.is_file(),
        "note": "third_party.lock 缺失" if not lock.is_file() else "lock present",
    }

    # G5 安全基线
    mind = rg_count(r"Mind@123", "scripts")
    ssh_no = rg_count(r"StrictHostKeyChecking=no", "scripts")
    threat = (ROOT / "docs" / "FPGA_威胁模型与安全基线_V0.md").is_file()
    g5_ok = mind == 0 and ssh_no == 0 and threat
    goals["G5"] = {
        "title": "安全基线",
        "ok": g5_ok,
        "note": f"Mind@123={mind}, StrictHostKeyChecking=no={ssh_no}, threat_doc={threat}",
    }

    # G6 加速/整网名副其实 — 文档诚实披露即「流程达标」；性能正加速仍否
    page = ROOT / "docs" / "Phase4.1_FPGA双路线平台可用性_总裁一页.md"
    page_t = page.read_text(encoding="utf-8") if page.is_file() else ""
    honest = ("板内整网" in page_t or "Zynq 板内" in page_t) and (
        "负增益" in page_t or "功能连通" in page_t or "卸载路径" in page_t
    )
    goals["G6"] = {
        "title": "加速/整网名副其实（或诚实披露）",
        "ok": honest,
        "note": "要求正加速比仍未达标；本项先验措辞是否诚实",
        "perf_positive_speedup": False,
    }

    # G7 证据不自覆盖 + 关键门在 CI
    try_py = (ROOT / "scripts" / "phase4_fpga_z2_openxc7_try.py").read_text(encoding="utf-8")
    out_by_design = "fpga_z2_openxc7_try_{" in try_py or "try_{args.design}" in try_py or (
        "f\"fpga_z2_openxc7_try_{args.design}.json\"" in try_py
        or "f'fpga_z2_openxc7_try_{args.design}.json'" in try_py
    )
    baseline = json.loads((ROOT / "config" / "neuro-qa-gate-baseline.json").read_text(encoding="utf-8"))
    ids = {g["id"] for g in baseline.get("gates", [])}
    ci_has = "N-CI-S2-EVAL" in ids and "N-CI-BOTH-EVIDENCE" in ids
    goals["G7"] = {
        "title": "证据不可覆盖 + 验收门进 CI",
        "ok": out_by_design and ci_has,
        "note": f"out_by_design={out_by_design}, ci_s2_and_both={ci_has}",
    }

    # G8 目标降级书面授权
    goals["G8"] = {
        "title": "目标降级有书面授权",
        "ok": "待 D1" in page_t or "D1" in page_t and "批准分阶段" in page_t,
        "note": "总裁一页须显式待 D1/D2/D3，不得把 F6 全链路勾成已完成",
    }

    score = sum(1 for g in goals.values() if g.get("ok"))
    report = {
        "schema": "phase4.1-fpga-goal-verify-G1-G8-v0",
        "generated_at": datetime.now(timezone.utc).astimezone().isoformat(),
        "agent": "ChenZhengGong",
        "source": "docs/FPGA_按项目目标_独立评审_Opus_V0.md",
        "goals": goals,
        "score": f"{score}/8",
        "pass_all": score == 8,
        "honesty": "0/8 或低分不等于没干活；表示与目标成功标准未对齐",
    }
    # soft blinky note
    if soft.is_file():
        report["blinky_open_bit"] = json.loads(soft.read_text(encoding="utf-8")).get(
            "pass_full_open_bit"
        )

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"GOAL_SCORE {report['score']} pass_all={report['pass_all']}")
    for k, g in goals.items():
        print(f"  {k}: {'OK' if g['ok'] else 'NO'}  {g['title']} — {g.get('note','')}")
    print(f"wrote {args.out}")
    if args.gate:
        return 0 if report["pass_all"] else 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
