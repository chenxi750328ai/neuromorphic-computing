"""Phase4.2 F7 perf gate JSON 结构单测（不依赖板/torch）."""
from __future__ import annotations

import json
from pathlib import Path

LAT_THRESHOLD = 100.0


def assert_perf_json(d: dict) -> tuple[bool, str]:
    n = int(d.get("n") or 0)
    rate = float(d.get("board_pred_match_rate") or 0)
    lat = d.get("per_sample_ms")
    lat = d.get("p50_ms") if lat is None else lat
    wall = d.get("wall_ms")
    if lat is None and wall is not None and n:
        lat = float(wall) / n
    fc = d.get("fc_on_pl")
    lif = d.get("lif_on_pl")
    if lat is None:
        return False, "missing per_sample_ms|p50_ms|wall_ms"
    ok = float(lat) <= LAT_THRESHOLD and rate >= 1.0 and n >= 20 and fc is True and lif is True
    return ok, f"lat={lat} rate={rate} n={n} fc={fc} lif={lif}"


def test_baseline_perf_json_is_red() -> None:
    root = Path(__file__).resolve().parents[1]
    gate = root / "docs" / "phase4_poc_evidence" / "fpga_rb_fullnet_pl_fc_gate.json"
    if not gate.is_file():
        return
    baseline = json.loads(gate.read_text(encoding="utf-8"))
    board = baseline.get("board") or {}
    d = {
        "n": board.get("n"),
        "board_pred_match_rate": (baseline.get("compare") or {}).get("board_pred_match_rate"),
        "wall_ms": board.get("wall_ms"),
        "fc_on_pl": board.get("fc_on_pl"),
        "lif_on_pl": board.get("lif_on_pl"),
    }
    ok, msg = assert_perf_json(d)
    assert not ok, f"baseline must be red: {msg}"


def test_assert_perf_json_green_shape() -> None:
    ok, _ = assert_perf_json(
        {
            "n": 20,
            "board_pred_match_rate": 1.0,
            "per_sample_ms": 50.0,
            "fc_on_pl": True,
            "lif_on_pl": True,
        }
    )
    assert ok
