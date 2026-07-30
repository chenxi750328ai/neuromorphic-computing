"""FPGA 实验室 SSH/口令公共约定（陈正共）— 口令不进源码默认值。

环境变量：
  PYNQ_PASS / NEURO_PYNQ_PASS
  ATLAS_PASS / NEURO_ATLAS_PASS
SSH：StrictHostKeyChecking=accept-new（禁止 =no）
"""
from __future__ import annotations

import os

SSH_OPTS = [
    "-o",
    "StrictHostKeyChecking=accept-new",
    "-o",
    "ConnectTimeout=8",
]


def env_pass(*keys: str) -> str:
    for k in keys:
        v = os.environ.get(k)
        if v:
            return v
    return ""


def require_pass(label: str, *keys: str) -> str:
    v = env_pass(*keys)
    if not v:
        raise SystemExit(
            f"FAIL missing {label} password; set one of env: {', '.join(keys)}"
        )
    return v


def ssh_cmd(user: str, host: str, password: str) -> list[str]:
    return ["sshpass", "-p", password, "ssh", *SSH_OPTS, f"{user}@{host}"]


def scp_cmd(password: str) -> list[str]:
    return ["sshpass", "-p", password, "scp", *SSH_OPTS]
