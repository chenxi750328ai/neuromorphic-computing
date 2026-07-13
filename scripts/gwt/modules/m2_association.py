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


class M2Association:
    module_id = "M2"

    def __init__(self, d: int = 256) -> None:
        self.d = d

    def local_step(
        self,
        sensory_input: Any,
        workspace: Workspace,
    ) -> tuple[np.ndarray, WriteCandidate | None]:
        active = workspace.W[workspace.active_mask]
        if active.size == 0:
            assoc = np.zeros(self.d, dtype=np.float32)
            score = 0.05
        else:
            assoc = active.mean(axis=0)
            score = float(active.shape[0]) * 0.15 + 0.2
        vec = project_features(assoc, self.d, "M2:assoc")
        return vec, make_candidate(self.module_id, vec, score)
