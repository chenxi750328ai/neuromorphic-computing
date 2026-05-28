#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
读取 reports/daily_progress.md，截取最近一段「当日」内容，通过飞书机器人 Webhook 发送。

环境变量：
  NEUROMORPHIC_FEISHU_WEBHOOK  必填，飞书自定义机器人 Webhook 完整 URL
  NEUROMORPHIC_REPORT_PATH     可选，默认仓库内 reports/daily_progress.md
"""
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_REPORT = ROOT / "reports" / "daily_progress.md"


def load_report_text() -> str:
    path = Path(os.environ.get("NEUROMORPHIC_REPORT_PATH", str(DEFAULT_REPORT)))
    if not path.is_file():
        return f"（未找到报告文件: {path}）"
    return path.read_text(encoding="utf-8", errors="replace")


def excerpt_for_message(full: str, max_chars: int = 3500) -> str:
    """取第一个 ## 标题块之后到下一个 ## 之前，作为「今日摘要」；否则发送全文截断。"""
    lines = full.splitlines()
    start = 0
    for i, line in enumerate(lines):
        if line.startswith("## ") and i + 1 < len(lines):
            start = i
            break
    chunk: list[str] = []
    for j in range(start, len(lines)):
        if j > start and lines[j].startswith("## "):
            break
        chunk.append(lines[j])
    body = "\n".join(chunk).strip() or full.strip()
    if len(body) > max_chars:
        body = body[: max_chars - 20] + "\n…(已截断)"
    return body


def feishu_text_payload(text: str) -> bytes:
    # 飞书自定义机器人 text 消息
    # https://open.feishu.cn/document/client-docs/bot-v3/add-custom-bot
    data = {"msg_type": "text", "content": {"text": text}}
    return json.dumps(data, ensure_ascii=False).encode("utf-8")


def main() -> int:
    url = (os.environ.get("NEUROMORPHIC_FEISHU_WEBHOOK") or "").strip()
    if not url:
        print("请设置 NEUROMORPHIC_FEISHU_WEBHOOK", file=sys.stderr)
        return 2

    today = datetime.now().strftime("%Y-%m-%d")
    full = load_report_text()
    excerpt = excerpt_for_message(full)
    text = f"【类脑计算 · 进展日报 {today}】\n\n{excerpt}"

    req = urllib.request.Request(
        url,
        data=feishu_text_payload(text),
        headers={"Content-Type": "application/json; charset=utf-8"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=25) as resp:
            raw = resp.read().decode("utf-8", errors="replace")
            print(f"HTTP {resp.status} {raw}")
    except urllib.error.URLError as e:
        print(f"请求失败: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
