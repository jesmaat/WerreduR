# PFP-W: Procedural Fractal-Seeded Difficulty Controller (R & C++)

This directory contains the R and C++ implementation of the fractal-seeded difficulty controller (`LearningGate`), the evolutionary seed optimization algorithm, and the complete simulation testbed comparing it against reference baselines.

The controller operates strictly without latent ability estimation (theta), requires no calibrated item parameters, maintains zero persistent learner states, and relies on no training data from real students.

---

## Execution Instructions

```bash
# Verify parity between native R implementation and Rcpp C++ kernel
Rscript tests/test_parity.R

# Evolutionary seed search (minimizing squared loss against balanced responding gain target)
# Pre-computed seed is stored in out/seed_search.rds; can be skipped
Rscript R/00_seed_search.R

# Primary Monte Carlo simulation: 6 learner conditions, 1,000 learners each, 120 items
Rscript R/01_run_simulation.R 1000 120

# Summary reporting and paired differences table generation
Rscript R/02_report.R

# Precision vs. recovery speed trade-off sweep (8 staircase step sizes)
Rscript R/03_tradeoff.R

# Generate manuscript figures (Figure 1, Figure 2, Figure S1)
Rscript R/06_figures.R

# Seed sensitivity analysis across three independent evolutionary runs (Seeds A, B, and Primary)
Rscript R/07_seed_sensitivity.R report
```

---

## Key Files and Architecture

* **`src/werr_kernel.cpp` & `R/werr_kernel.R`:** Core procedural kernel implementing boundary-corrected complex plane sampling and tripod weight fusion.
* **`R/learning_gate.R`:** `LearningGate` decision unit, input state projection (history running sum $ho$), coordinate shifting, and evolutionary seed optimizer.
* **`R/controllers.R`:** Implementation of all comparison controllers:
  * Computerized Adaptive Testing (CAT) targeting 50% success probability under Rasch IRT
  * CAT with exponential forgetting factor (0.95)
  * CAT with empirical prior matching
  * Fixed-step up-down staircases (equivalent to Elo item selection with $K = 2s$)
  * Adaptive-step PEST-type rule
  * Stored-weight twin (identical architecture with fixed regression weights)
  * Frozen-window and unsearched-seed variants
  * First version controller (Authors, 2026b)
* **`R/simulate.R`:** Simulation scenarios, response generators, common random numbers framework, and performance metric evaluators.
* **`R/06_figures.R`:** Publication-grade figure generation exporting 600-DPI PNG and vector PDF figures to `out/`.
* **`out/`:** Pre-computed simulation outputs, RDS binary artifacts, performance metric CSV tables, and execution logs.

---

## Methodological Notes

* **Non-Inferiority Margin:** The pre-specified non-inferiority margin is fixed at $\Delta = 0.10$ logits (corresponding to ~2.5% success probability deviation at the target).
* **Item Bank:** Standard conditions assume a continuous item pool (items of any requested difficulty $b$ available). Finite bank depletion is evaluated in `R/05_finite_bank.R` and `R/05b_finite_bank_reuse.R`.
* **Anonymization:** In `R/06_figures.R`, `ANONYMISED <- TRUE` ensures that the authors' earlier design is neutrally labeled as *"First version"*, adhering to double-anonymized review.
