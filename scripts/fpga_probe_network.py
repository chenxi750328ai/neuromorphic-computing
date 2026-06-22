#!/usr/bin/env python3
"""PYNQ-Z2 连通性探测（从 WSL 经 Windows 网段或 SSH）。"""
from __future__ import annotations

import argparse
import subprocess
import sys

CANDIDATES = [
    "192.168.2.99",   # PYNQ 直连默认
    "192.168.137.3",  # 与 Atlas 同交换机时常用手动 IP
    "192.168.137.10",
    "192.168.3.99",
]


def win_ping(ip: str) -> bool:
    r = subprocess.run(
        ["powershell.exe", "-NoProfile", "-Command", f"Test-Connection {ip} -Count 1 -Quiet"],
        capture_output=True,
        text=True,
    )
    return r.stdout.strip().lower() == "true"


def try_ssh(ip: str, user: str = "xilinx", timeout: int = 5) -> tuple[bool, str]:
    r = subprocess.run(
        [
            "ssh",
            "-o",
            "StrictHostKeyChecking=no",
            "-o",
            f"ConnectTimeout={timeout}",
            "-o",
            "BatchMode=yes",
            f"{user}@{ip}",
            "hostname && uname -a",
        ],
        capture_output=True,
        text=True,
    )
    out = ((r.stdout or "") + (r.stderr or "")).strip()
    return r.returncode == 0, out[:300]


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--ip", default="")
    args = p.parse_args()
    ips = [args.ip] if args.ip else CANDIDATES

    found = []
    for ip in ips:
        if not win_ping(ip):
            print(f"ping {ip}: FAIL")
            continue
        print(f"ping {ip}: OK")
        for user in ("xilinx", "root"):
            ok, msg = try_ssh(ip, user)
            print(f"  ssh {user}@{ip}: {'OK' if ok else 'FAIL'} {msg[:120]}")
            if ok:
                found.append((ip, user))
                break

    if found:
        ip, user = found[0]
        print(f"\nUSE: ssh {user}@{ip}")
        print(f"Jupyter: http://{ip}:9090/lab")
        return 0
    print("\nNo PYNQ host found. See docs/PYNQ_Z2_配置与连接状态.md", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
