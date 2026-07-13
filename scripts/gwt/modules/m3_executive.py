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


class M3Executive:
    module_id = "M3"

    def __init__(self, d: int = 256) -> None:
        self.d = d

    def local_step(
        self,
        sensory_input: Any,
        workspace: Workspace,
    ) -> tuple[np.ndarray, WriteCandidate | None]:
        tick = workspace.tick
        ctx = np.array([tick, workspace.active_count()], dtype=np.float32)
        vec = project_features(ctx, self.d, "M3:exec")
        score = 0.25 + tick * 0.02
        return vec, make_candidate(self.module_id, vec, score)
