from __future__ import annotations

import hashlib

import numpy as np

import sys
from pathlib import Path

_SCRIPTS = Path(__file__).resolve().parents[1]
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))

from gwt_workspace import WriteCandidate


def seed_vector(key: str, d: int) -> np.ndarray:
    h = hashlib.sha256(key.encode()).digest()
    rng = np.random.default_rng(int.from_bytes(h[:8], "little"))
    v = rng.standard_normal(d).astype(np.float32)
    n = float(np.linalg.norm(v))
    return v / n if n > 1e-8 else v


def project_features(features: np.ndarray, d: int, tag: str) -> np.ndarray:
    f = np.asarray(features, dtype=np.float32).reshape(-1)
    base = seed_vector(tag, d)
    if f.size == 0:
        return base
    coeff = float(f.mean())
    out = base * (0.5 + abs(coeff)) + seed_vector(tag + ":aux", d) * 0.3
    n = float(np.linalg.norm(out))
    return out / n if n > 1e-8 else out


def make_candidate(module_id: str, vector: np.ndarray, score: float) -> WriteCandidate:
    return WriteCandidate(module_id=module_id, vector=vector, score=score)
