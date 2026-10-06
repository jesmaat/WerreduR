"""
tests/test_learning_gate_parity.py
==================================
Comprehensive Parity, Invariant, and Benchmark Tests for LearningGate v2
Matching Section 7 of WERREDUR_V2_TALIMATNAME.md.
"""

import os
import sys
import csv
import json
import subprocess
import unittest
import numpy as np

# Ensure project root is on sys.path
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from werr.learning_gate import (
    LearningGate,
    Staircase,
    PEST,
    CAT,
    PFPCore,
    werr_tripod,
    gate_gain,
    agree,
    project_state,
    modulate_seed,
    GATE_SEED,
    TWIN_W,
    S_MIN,
    S_MAX,
)


class TestLearningGateParity(unittest.TestCase):
    """Verifies parity between Python, R, C++, and JS implementations."""

    def test_tripod_kernel_parity_200_coords(self):
        """Test tripod kernel against python_reference.csv (200 coordinates)."""
        ref_path = os.path.join(PROJECT_ROOT, "v2", "pfpw", "tests", "python_reference.csv")
        self.assertTrue(os.path.exists(ref_path), f"Reference file not found: {ref_path}")

        with open(ref_path, "r", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            rows = list(reader)

        self.assertEqual(len(rows), 200, "Reference CSV should contain 200 rows")
        max_diff = 0.0

        for row in rows:
            cx = float(row["cx"])
            cy = float(row["cy"])
            zoom = float(row["zoom"])
            ref_q = np.array([float(row[f"q{i}"]) for i in range(1, 5)], dtype=np.float64)

            calc_q = werr_tripod(cx, cy, zoom)
            diff = np.max(np.abs(calc_q - ref_q))
            if diff > max_diff:
                max_diff = diff

        self.assertLess(max_diff, 1e-9, f"Max tripod diff {max_diff} exceeded 1e-9")

    def test_gate_gain_parity_256_histories(self):
        """Test gate gain against gate_gain_reference_R.csv (256 response histories)."""
        ref_path = os.path.join(PROJECT_ROOT, "v2", "pfpw", "tests", "gate_gain_reference_R.csv")
        self.assertTrue(os.path.exists(ref_path), f"Reference file not found: {ref_path}")

        with open(ref_path, "r", encoding="utf-8") as f:
            reader = csv.reader(f)
            header = next(reader)
            rows = list(reader)

        self.assertEqual(len(rows), 256, "Reference CSV should contain 256 rows")
        max_diff = 0.0

        for row in rows:
            responses = [int(x) for x in row[:8]]
            ref_gain = float(row[8])

            gate = LearningGate(mode="werr")
            for x in responses:
                gate.update(x)

            diff = abs(gate.last_gain - ref_gain)
            if diff > max_diff:
                max_diff = diff

        self.assertLess(max_diff, 1e-9, f"Max gain diff {max_diff} exceeded 1e-9 (measured: {max_diff:.3e})")

    def test_response_flip_symmetry(self):
        """Test symmetry: g(hist) must equal g(1 - hist) with exactly 0 asymmetry."""
        rng = np.random.default_rng(2026)
        max_asym = 0.0

        # Test on all 256 8-bit combinations
        for val in range(256):
            bits = [(val >> b) & 1 for b in range(8)]
            flipped = [1 - b for b in bits]

            g1 = LearningGate(mode="werr")
            g2 = LearningGate(mode="werr")
            for b in bits:
                g1.update(b)
            for b in flipped:
                g2.update(b)

            asym = abs(g1.last_gain - g2.last_gain)
            if asym > max_asym:
                max_asym = asym

        self.assertEqual(max_asym, 0.0, f"Asymmetry under response inversion: {max_asym}")

    def test_twin_weights_exact_match(self):
        """Test that explicit-weight twin matches Section 4.2 four constants."""
        expected = (0.031895461427411224, 1.067104626736044, 3.0, -3.0)
        self.assertEqual(len(TWIN_W), 4)
        for val, exp in zip(TWIN_W, expected):
            self.assertAlmostEqual(val, exp, places=12)

    def test_pfp_core_analytical_pullback_bound(self):
        """Test that PFP-Core difficulty is strictly bounded by |b| <= 0.05 / 0.44 * 10 = 1.13636..."""
        theoretical_bound = (0.05 / 0.44) * 10.0
        rng = np.random.default_rng(2026)
        pfp = PFPCore(jump=False, kappa=0.44, delta=0.05, beta=10.0)

        # 10,000 random steps
        for _ in range(10000):
            x = int(rng.integers(0, 2))
            pfp.update(x)
            self.assertLessEqual(abs(pfp.difficulty), theoretical_bound + 1e-12)

        # 100 consecutive correct responses (saturation edge)
        pfp.reset()
        for _ in range(100):
            pfp.update(1)
        self.assertAlmostEqual(pfp.difficulty, theoretical_bound, places=5)

        # 100 consecutive incorrect responses (saturation edge)
        pfp.reset()
        for _ in range(100):
            pfp.update(0)
        self.assertAlmostEqual(pfp.difficulty, -theoretical_bound, places=5)

    def test_pfp_core_kappa_zero_equals_staircase(self):
        """When kappa = 0, PFP-Core is identical to a fixed staircase with step = 0.50."""
        rng = np.random.default_rng(2026)
        pfp = PFPCore(jump=False, kappa=0.0, delta=0.05, beta=10.0)
        stair = Staircase(step=0.50)

        for _ in range(500):
            x = int(rng.integers(0, 2))
            b_pfp = pfp.update(x)
            b_stair = stair.update(x)
            self.assertAlmostEqual(b_pfp, b_stair, places=10)

    def test_elo_staircase_identity(self):
        """Staircase with step s is mathematically identical to Elo item update with K = 2s at P* = 0.50."""
        step = 0.20
        K = 2.0 * step
        P_target = 0.50

        stair = Staircase(step=step)
        elo_b = 0.0

        for x in [1, 1, 0, 1, 0, 0, 1, 0, 1, 1]:
            stair.update(x)
            # Elo item difficulty update: b <- b + K * (x - P_target)
            elo_b += K * (x - P_target)
            self.assertAlmostEqual(stair.difficulty, elo_b, places=12)

    def test_js_node_parity_runner(self):
        """Run Node.js parity test script (test_js_parity.js)."""
        js_path = os.path.join(PROJECT_ROOT, "v2", "pfpw", "tests", "test_js_parity.js")
        self.assertTrue(os.path.exists(js_path), f"JS test file not found: {js_path}")

        proc = subprocess.run(
            ["node", js_path],
            cwd=os.path.dirname(js_path),
            capture_output=True,
            text=True,
        )
        self.assertEqual(proc.returncode, 0, f"JS test failed: {proc.stderr}\n{proc.stdout}")
        self.assertIn("OK", proc.stdout)

    def test_llm_json_summary_verification(self):
        """Verify LLM benchmark raw JSON file has the exact documented group means (0.784 and 0.933)."""
        json_path = os.path.join(
            PROJECT_ROOT, "v2", "llm", "ham_sonuclar_varsayilan_kademe_200_ogrenci.json"
        )
        self.assertTrue(os.path.exists(json_path), f"LLM JSON not found: {json_path}")

        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        self.assertIn("llm", data)
        self.assertIn("err", data["llm"])
        llm_err = data["llm"]["err"]
        self.assertEqual(len(llm_err), 200)

        # First 100 students: data-shaped condition; Next 100 students: jump condition
        mean_data_shaped = float(np.mean(llm_err[:100]))
        mean_jump = float(np.mean(llm_err[100:]))

        self.assertAlmostEqual(mean_data_shaped, 0.784, places=3)
        self.assertAlmostEqual(mean_jump, 0.933, places=3)

        # Also verify baseline presence
        self.assertIn("baselines", data)
        gate_baseline = next(
            (b for b in data["baselines"] if "Fraktal kapı" in b["name"]), None
        )
        self.assertIsNotNone(gate_baseline)
        self.assertAlmostEqual(float(np.mean(gate_baseline["err"][:100])), 0.722, places=3)
        self.assertAlmostEqual(float(np.mean(gate_baseline["err"][100:])), 0.842, places=3)


if __name__ == "__main__":
    unittest.main()
