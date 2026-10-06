# Changelog

All notable changes to the `WerreduR` project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2026-10-07

### Summary: Evolution from "Procedural Fractal Pedagogy" to Empirical Controller Positioning
Version 2.0 represents a major empirical restructuring of the codebase accompanying the research manuscript:
> *"Where Does a Fractal-Seeded Controller Stand? A Simulation Study Positioning a 24-Byte, Estimation-Free Difficulty Controller Against Adaptive Testing, Staircase Rules and a Language Model"*

The repository transitions from an early conceptual position paper asserting "Procedural Fractal Pedagogy (PFP-Core)" to an empirical evaluation of a **24-byte fractal-seeded adaptive difficulty controller (`LearningGate`)** rigorously benchmarked against:
1. Standard & non-stationary Computerized Adaptive Testing (CAT, Rasch model, EAP).
2. Fixed-step staircase rules (Levitt, 1971; equivalent to Elo item calibration at $P^* = 0.50$).
3. Accelerated staircases (PEST-type; Taylor & Creelman, 1967).
4. Stored-weight non-fractal twins (4 explicit float parameters).
5. Frontier Large Language Models (Claude API across 200 learners).
6. Synthetic non-stationary learner regimes and mixed-effects empirical replays fitted to ASSISTments 2009–2010 and 2017 datasets ($N = 5,872$ learners, $1.25M+$ interactions).

---

### Added
- **`v2/controller/` (`v2/pfpw/`)**: Complete R and Rcpp simulation battery:
  - `R/werr_kernel.R` & `src/werr_kernel.cpp`: Reference pure-R and accelerated C++ WERR tripod Mandelbrot kernel.
  - `R/learning_gate.R`: Dynamic state projection, 24-byte boundary coordinate modulation, and sigmoid gain neuron.
  - `R/controllers.R`: Standardized interfaces for all 10 experimental arms.
  - `R/simulate.R`: 6 synthetic evaluation regimes (stationary, slow learning, fast learning, uncalibrated starts, abrupt jumps, unconstrained guessing).
  - `out/`: Frozen reference datasets (`table_metrics.csv`, `table_noninferiority.csv`, `table_tradeoff.csv`, plots, RDS objects).
- **`v2/data_shaped/` (`v2/replay/`)**: Empirical mixed logistic regression models (`glmer`, `lme4`):
  - Calibrated against ASSISTments 2009–2010 ($4,163$ learners, $123$ skills) and ASSISTments 2017 ($1,709$ learners, $102$ skills).
  - Out-of-sample split validation ($\text{AUC} = 0.719 - 0.722$).
  - Constant and saturating logarithmic learning dynamics.
- **`v2/llm/` (`v2/llm_deneyi/`)**: Empirical LLM evaluation suite:
  - Interactive benchmark runtime (`llm_kontrolcu_deneyi.html`).
  - Standalone JavaScript kernel port (`werr_cekirdek_js_portu.js`).
  - Frozen execution logs and raw trial responses (`ham_sonuclar_varsayilan_kademe_200_ogrenci.json`).
- **`werr/learning_gate.py`**: Production Python implementation of `LearningGate`, `Staircase`, `PEST`, `CAT`, and `PFPCore`.
- **`tests/test_learning_gate_parity.py`**: Full parity and invariant test battery verifying:
  - Kernel parity across 200 coordinates ($< 10^{-9}$ max error; measured $\sim 10^{-15}$).
  - Gain parity across 256 response histories ($< 10^{-9}$ max error; measured $\sim 10^{-15}$).
  - Exact response-flip symmetry ($g(\text{hist}) \equiv g(1 - \text{hist})$).
  - Mathematical equivalence of unconstrained PFP-Core ($\kappa = 0$) to a $0.50$ fixed staircase.
  - Analytical proof that legacy PFP-Core difficulty is bounded to $[-1.136, +1.136]$ logits.
  - Elo item calibration identity ($s \equiv K = 2s$).
  - Full execution of Node.js parity suite.
  - Exact matching of empirical LLM condition error means ($0.784$ and $0.933$).
- **`extras/`**: Exploratory multi-skill embedding (`multi/`) and empirical fractal fluctuation analysis (`lens/`), clearly delineated as beyond the manuscript's core empirical scope.

---

### Changed
- **Repository Architecture**: Reorganized into clean modular tiers (`v2/`, `werr/`, `legacy/`, `extras/`, `tests/`).
- **Academic Integrity Archival**: Archived all v1/PFP-Core code, data, LaTeX manuscripts, Lean 4 proofs, and figures into `legacy/` to maintain 100% reproducibility for citations referencing Zenodo Version v4.0 ([10.5281/zenodo.23128224](https://doi.org/10.5281/zenodo.23128224)) and Concept DOI ([10.5281/zenodo.22999420](https://doi.org/10.5281/zenodo.22999420)).
- **Documentation Alignment**: Rewrote root `README.md` to remove unverified claims and reflect exact empirical simulation numbers and trade-off matrices.

---

### Removed / Corrected
- Purged term *"Procedural Fractal Pedagogy"* from the primary controller title (a controller is an algorithmic policy, not an instructional theory).
- Purged unmeasured latency assertions ("30.4 $\mu$s", "CAT > 100 ms") and replaced them with benchmarked execution timings (Fractal controller: $\approx 0.3-0.4\text{ ms}$; CAT: $\approx 0.004-0.008\text{ ms}$; Staircase: $< 0.003\text{ ms}$; LLM API: $67-788\text{ ms}$).
- Purged unsupported claims regarding "ability gain maximization" and "bounding frustration cascades" via $+J$ jump resets (empirical evidence demonstrated $+J$ exacerbated difficulty drift in struggling learners).
- Purged claims of pre-registration or formal verification of v2 claims (the study is exploratory and simulation-grounded).

---

## [1.0.0] - 2026-10-04 (Archived in `legacy/`)
- Initial release accompanying Zenodo v4.0 distribution (`10.5281/zenodo.23128224`).
- Introduced PFP-Core concept based on fixed anchor pullback $\kappa = 0.44$.
- Formalized Lean 4 proof of Z/9Z algebraic invariants (`lean4/PFP_HorizonProof.lean`).
- Preserved for exact historical and academic reproducibility in `legacy/`.
