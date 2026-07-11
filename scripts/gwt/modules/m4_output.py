from __future__ import annotations

import sys
from pathlib import Path
from dataclasses import dataclass
from typing import Any

import numpy as np

_SCRIPTS = Path(__file__).resolve().parents[1]
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))

from gwt_workspace import Workspace, WriteCandidate

from ._base import make_candidate, project_features


@dataclass
class EmitDecision:
    class_id: int
    confidence: float
    source: str = "M4:workspace_read"


class M4Output:
    module_id = "M4"

    def __init__(self, d: int = 256, num_classes: int = 10) -> None:
        self.d = d
        self.num_classes = num_classes

    def local_step(
        self,
        sensory_input: Any,
        workspace: Workspace,
    ) -> tuple[np.ndarray, WriteCandidate | None]:
        vec = project_features(np.array([workspace.active_count()], dtype=np.float32), self.d, "M4:status")
        score = 0.1
        return vec, make_candidate(self.module_id, vec, score)

    def read_emit(self, workspace: Workspace) -> EmitDecision:
        if not workspace.active_mask.any():
            return EmitDecision(class_id=0, confidence=0.0)

        active = workspace.W[workspace.active_mask]
        pooled = active.mean(axis=0)
        logits = np.array(
            [float(np.dot(pooled, project_features(np.array([i], dtype=np.float32), self.d, f"cls:{i}"))) for i in range(self.num_classes)],
            dtype=np.float32,
        )
        ex = logits - logits.max()
        probs = np.exp(ex)
        probs /= probs.sum() + 1e-8
        cid = int(np.argmax(probs))
        return EmitDecision(class_id=cid, confidence=float(probs[cid]))
