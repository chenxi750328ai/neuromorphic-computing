from __future__ import annotations

import sys
from pathlib import Path
from typing import Any

import numpy as np

_SCRIPTS = Path(__file__).resolve().parents[1]
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))

from gwt_workspace import Workspace, WriteCandidate

from ._base import make_candidate, project_features


class M1Perception:
    module_id = "M1"

    def __init__(self, d: int = 256) -> None:
        self.d = d

    def encode(self, sensory_input: Any) -> np.ndarray:
        if isinstance(sensory_input, np.ndarray):
            flat = sensory_input.astype(np.float32).reshape(-1)
            if flat.size >= 28 * 28:
                flat = flat[: 28 * 28]
            return flat
        if isinstance(sensory_input, (list, tuple)):
            return np.asarray(sensory_input, dtype=np.float32).reshape(-1)
        if isinstance(sensory_input, dict):
            return np.array([float(sensory_input.get("label", 0))], dtype=np.float32)
        return np.zeros(1, dtype=np.float32)

    def local_step(
        self,
        sensory_input: Any,
        workspace: Workspace,
    ) -> tuple[np.ndarray, WriteCandidate | None]:
        feat = self.encode(sensory_input)
        vec = project_features(feat, self.d, "M1:perception")
        score = float(np.linalg.norm(feat)) + 0.1
        return vec, make_candidate(self.module_id, vec, score)
