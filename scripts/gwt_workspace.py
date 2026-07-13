#!/usr/bin/env python3
"""GWT workspace bus: compete-write + broadcast-read (Phase6 MVP · 陈正共)."""
from __future__ import annotations

import copy
import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import numpy as np

PROTO_VERSION = 0
DEFAULT_K = 32
DEFAULT_D = 256
DEFAULT_K_ACTIVE = 8


@dataclass
class WriteCandidate:
    module_id: str
    vector: np.ndarray
    score: float
    slot_hint: int | None = None


@dataclass
class WriteLogEntry:
    module_id: str
    score: float
    slot: int
    action: str  # fill | replace


@dataclass
class Workspace:
    """Global workspace W[K,D] per GWT_工作区协议_V0.md."""

    K: int = DEFAULT_K
    D: int = DEFAULT_D
    k_active: int = DEFAULT_K_ACTIVE
    W: np.ndarray = field(init=False)
    active_mask: np.ndarray = field(init=False)
    tick: int = 0
    version: int = PROTO_VERSION

    def __post_init__(self) -> None:
        self.W = np.zeros((self.K, self.D), dtype=np.float32)
        self.active_mask = np.zeros(self.K, dtype=bool)

    def snapshot(self) -> Workspace:
        """Immutable broadcast copy."""
        out = Workspace(K=self.K, D=self.D, k_active=self.k_active)
        out.W = self.W.copy()
        out.active_mask = self.active_mask.copy()
        out.tick = self.tick
        out.version = self.version
        return out

    def active_count(self) -> int:
        return int(self.active_mask.sum())

    def merge(self, candidates: list[WriteCandidate]) -> list[WriteLogEntry]:
        """Compete-write: top-k by score into active slots."""
        if not candidates:
            self.tick += 1
            return []

        ranked = sorted(candidates, key=lambda c: c.score, reverse=True)
        take = min(len(ranked), self.k_active)
        logs: list[WriteLogEntry] = []

        for cand in ranked[:take]:
            vec = _normalize_vector(cand.vector, self.D)
            slot = _pick_slot(self, cand)
            was_active = bool(self.active_mask[slot])
            self.W[slot] = vec
            self.active_mask[slot] = True
            logs.append(
                WriteLogEntry(
                    module_id=cand.module_id,
                    score=cand.score,
                    slot=slot,
                    action="replace" if was_active else "fill",
                )
            )

        self.tick += 1
        return logs

    def to_dict(self) -> dict[str, Any]:
        return {
            "proto": "gwt-workspace-v0",
            "tick": self.tick,
            "K": self.K,
            "D": self.D,
            "k_active": self.k_active,
            "active_mask": self.active_mask.tolist(),
            "active_count": self.active_count(),
            "version": self.version,
        }

    def save_json(self, path: Path) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        payload = self.to_dict()
        path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def _normalize_vector(vec: np.ndarray, d: int) -> np.ndarray:
    v = np.asarray(vec, dtype=np.float32).reshape(-1)
    if v.size != d:
        if v.size > d:
            v = v[:d]
        else:
            pad = np.zeros(d - v.size, dtype=np.float32)
            v = np.concatenate([v, pad])
    norm = float(np.linalg.norm(v))
    if norm > 1e-8:
        v = v / norm
    return v


def _pick_slot(ws: Workspace, cand: WriteCandidate) -> int:
    if cand.slot_hint is not None and 0 <= cand.slot_hint < ws.K:
        if not ws.active_mask[cand.slot_hint]:
            return cand.slot_hint

    empty = np.where(~ws.active_mask)[0]
    if empty.size > 0:
        return int(empty[0])

    active_idx = np.where(ws.active_mask)[0]
    norms = [float(np.linalg.norm(ws.W[i])) for i in active_idx]
    weakest = active_idx[int(np.argmin(norms))]
    return int(weakest)


def run_global_tick(
    modules: list[Any],
    workspace: Workspace,
    sensory_input: Any,
    *,
    log_dir: Path | None = None,
) -> tuple[Workspace, list[WriteLogEntry]]:
    """One global tick: parallel local_step → compete → broadcast."""
    ws_in = workspace.snapshot()
    candidates: list[WriteCandidate] = []
    for mod in modules:
        _, cand = mod.local_step(sensory_input, ws_in)
        if cand is not None:
            candidates.append(cand)

    logs = workspace.merge(candidates)
    ws_out = workspace.snapshot()

    if log_dir is not None:
        log_dir.mkdir(parents=True, exist_ok=True)
        ws_out.save_json(log_dir / f"tick_{ws_out.tick}.json")

    return ws_out, logs
