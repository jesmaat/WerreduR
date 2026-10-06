# Where Does a Fractal-Seeded Controller Stand?

**A Simulation Study Positioning a 24-Byte, Estimation-Free Difficulty Controller Against Adaptive Testing, Staircase Rules and a Language Model**

[![Status: Prepared for Q1 AIED Submission](https://img.shields.io/badge/Target-Flagship%20Q1%20AIED%20Journal-059669.svg)](#)
[![Concept DOI](https://img.shields.io/badge/Concept%20DOI-10.5281%2Fzenodo.22999420-indigo.svg)](https://doi.org/10.5281/zenodo.22999420)
[![Zenodo v4.0 Archive](https://img.shields.io/badge/Zenodo%20Archive-10.5281%2Fzenodo.23128224-blue.svg)](https://doi.org/10.5281/zenodo.23128224)
[![GitHub Repository](https://img.shields.io/badge/GitHub-pCwOrM%2FWerreduR-181717.svg?logo=github)](https://github.com/pCwOrM/WerreduR)
[![Python & Node Parity](https://img.shields.io/badge/Parity%20Tests-9%2F9%20Passing-success.svg)](./tests/test_learning_gate_parity.py)
[![Legacy Reproducibility](https://img.shields.io/badge/Legacy%20v1%20Archive-legacy%2F-lightgrey.svg)](./legacy/README_LEGACY.md)

---

## Abstract

We evaluate an adaptive item-difficulty controller whose step-size policy is procedurally generated from a 24-byte coordinate seed on the boundary of the Mandelbrot set via the WERR fractal kernel. Positioning this estimation-free controller against standard and non-stationary Computerized Adaptive Testing (CAT), fixed-step staircases, PEST-type rules, a stored-weight matched twin, and a frontier language model across six synthetic regimes and two empirical ASSISTments datasets, we find that the fractal-seeded rule achieves robust tracking under abrupt ability shifts and fast learning while executing in 0.3 ms per item with zero persistent tensor storage.

---

## 1. Where Does the Controller Stand? (Positioning Matrix)

The controller evaluated here is not an instructional theory or pedagogical panacea; it is a **fast, memory-bounded, estimation-free step-size controller** for item selection. The following positioning matrix summarizes its empirical operational characteristics relative to established paradigms:

| Dimension | Standard CAT (Rasch EAP) | Fixed Staircase (= Elo $K=2s$) | Accelerated Staircase (PEST-type) | Fractal-Seeded Controller (`LearningGate`) | Frontier Language Model (API) |
|---|---|---|---|---|---|
| **Underlying model** | Latent trait $\theta \sim \mathcal{N}(0, 1)$ | None | None | None | In-context heuristic |
| **Information required** | Calibrated item bank + prior | Binary outcome $x \in \{0, 1\}$ | Binary outcome $x \in \{0, 1\}$ | Binary outcome $x \in \{0, 1\}$ | Prompt history + items |
| **Tracking stationary ability** | **Best** ($0.257$ logits MAE) | Moderate ($0.356$ logits) | Moderate ($0.412$ logits) | Moderate ($0.419$ logits) | Coarse ($0.784$ logits) |
| **Tracking fast learning** | Weak ($0.755$ logits lag) | Strong ($0.401$ logits) | Moderate ($0.465$ logits) | **Strongest** ($0.421$ logits) | Lagged |
| **Recovery after jump (+1.5 logit)** | Very slow ($56.0$ trials) | Moderate ($14.8$ trials) | Fast ($11.7$ trials) | **Fastest** ($10.4$ trials) | Unstable |
| **Handling guessing** | Robust ($0.496$ logits) | Moderate ($0.634$ logits) | Vulnerable ($0.750$ logits) | Vulnerable ($0.734$ logits) | Vulnerable |
| **Decision latency** | $0.008\text{ ms}$ ($8.0\ \mu\text{s}$) | $< 0.003\text{ ms}$ ($2.0\ \mu\text{s}$) | $< 0.002\text{ ms}$ ($1.3\ \mu\text{s}$) | $0.3-0.4\text{ ms}$ ($418\ \mu\text{s}$) | $67 - 788\text{ ms}$ |
| **Persistent state size** | Grid posterior ($121$ floats) | $1$ float | $3$ floats | 24-byte seed + $6$ floats | Multi-GB tensor memory |
| **Target success rate** | Configurable ($P^*$) | $P^* = 0.50$ | $P^* = 0.50$ | $P^* = 0.50$ (symmetric) | Variable |

---

## 2. Controller Architecture & Mathematical Definition

### 2.1 State Representation & Update
Each learner maintains a presentation difficulty $b$ (logits), the last four binary response bits $h = [h_0, h_1, h_2, h_3]$, and a leaky response-balance accumulator $\rho \in [-3, 3]$. State initializes to $b = 0$, $h = [\text{None}, \text{None}, \text{None}, \text{None}]$, $\rho = 0$.

Upon observing response $x \in \{0, 1\}$:
$$\begin{aligned}
h &\leftarrow [x, h_0, h_1, h_2] \\
\rho &\leftarrow \frac{2}{3} \rho + (2x - 1)
\end{aligned}$$

### 2.2 Feature Projection & Boundary Modulation
Latent agreement and imbalance features are computed:
$$\begin{aligned}
a_1 &= \text{agree}(h_0, h_1), \quad a_2 = \text{agree}(h_1, h_2), \quad a_3 = \text{agree}(h_2, h_3) \\
m &= \frac{2 |\rho|}{3} - 1, \quad \text{net\_risk} = |\rho| - 1
\end{aligned}$$
where $\text{agree}(p, q) = 0$ if either is missing, $+1$ if $p = q$, and $-1$ if $p \neq q$.

The 24-byte seed $\Theta = (cx_0, cy_0, z_0)$ is modulated by boundary offsets:
$$\begin{aligned}
\text{scale} &= \frac{1}{z_0} \\
dx &= \tanh\left(\text{net\_risk} \text{ if } \text{net\_risk} \neq 0 \text{ else } \frac{a_1 + m}{2}\right) \cdot \text{scale} \cdot 0.45 \\
dy &= \tanh\left(\frac{a_2 + a_3}{2}\right) \cdot \text{scale} \cdot 0.45 \\
cx &= cx_0 + dx, \quad cy = cy_0 + dy, \quad z = z_0 \cdot (1 + 0.1 \sin(a_1 + a_2 + m + a_3))
\end{aligned}$$

### 2.3 Tripod Mandelbrot Pass & Step Size Servo
The WERR tripod multi-scale kernel evaluates 3 zoom levels ($0.60\times, 1.00\times, 1.60\times$) with weights $(0.25, 0.50, 0.25)$ on a $36 \times 36$ grid ($36$ maximum iterations, bandwidth $0.12$). Bounded quadrant escape-time ratios $q \in [0, 1]^4$ define dynamic neuron weights:
$$w_{1..4} = (q - 0.5) \cdot 6$$
The gain $g \in [0, 1]$ schedules the servo step size symmetrically:
$$\begin{aligned}
g &= \sigma\left(\text{clamp}(w_1 a_1 + w_2 a_2 + w_3 m + w_4, -50, 50)\right) \\
b &\leftarrow b + (0.05 + 0.55 \cdot g) \cdot (2x - 1)
\end{aligned}$$

### 2.4 Frozen 24-Byte Seed
The optimized coordinate seed is a frozen artifact:
$$\Theta^* = \left(cx_0 = -0.80792578443908969,\ cy_0 = 0.18302136198124994,\ z_0 = 300.0\right)$$
Validating `seed_loss(Theta*, canonical_patterns(8))` yields exactly `0.0233722`.

---

## 3. Empirical Results

### 3.1 Synthetic Evaluation Regimes ($N = 1,000, T = 120$)
Mean absolute error (MAE in logits) between presented difficulty $b$ and learner ability:

| Arm | Stationary Ability | Slow Learning ($\eta = 0.02$) | Fast Learning ($\eta = 0.10$) | Uncalibrated Start ($+2.0$) | Sudden Jump ($+1.5$) | Guessing ($g = 0.25$) |
|---|---|---|---|---|---|---|
| **LearningGate (Fractal)** | 0.419 | 0.405 | **0.421** | 0.500 | 0.477 | 0.734 |
| **Stored-Weight Twin** | 0.429 | 0.415 | 0.428 | 0.507 | 0.486 | 0.748 |
| **Standard CAT** | **0.257** | **0.286** | 0.755 | 0.448 | 0.683 | **0.496** |
| **CAT with Forgetting** | 0.317 | 0.306 | 0.585 | 0.601 | 0.523 | 0.494 |
| **Fixed Staircase (0.15)** | 0.356 | 0.341 | 0.401 | 0.494 | 0.453 | 0.634 |
| **PEST-type Rule** | 0.412 | 0.403 | 0.465 | **0.474** | 0.497 | 0.750 |
| **Legacy PFP-Core** | 0.682 | 0.653 | 1.028 | 1.547 | 0.936 | 0.702 |
| **Legacy PFP-Core + J** | 0.709 | 0.670 | 1.035 | 1.546 | 0.948 | 0.710 |

*Recovery time (trials to re-acquire ability corridor after sudden jump):*
- **LearningGate:** **10.4 trials**
- **PEST:** 11.7 trials
- **Fixed Staircase (0.15):** 14.8 trials
- **CAT with Forgetting:** 28.5 trials
- **Standard CAT:** 56.0 trials

### 3.2 Real-Data Replay (ASSISTments 2009–2010 and 2017)
Mixed logistic regression models (`glmer`, $N = 5,872$ learners, $225$ skills) evaluated under unknown vs. known student baseline:

| Arm | 2009–2010 Constant | 2009–2010 Logarithmic | 2017 Constant | 2017 Logarithmic |
|---|---|---|---|---|
| **LearningGate (Fractal)** | 0.899 / **0.595** | 0.914 / **0.651** | 0.563 / **0.456** | 0.564 / **0.465** |
| **Stored-Weight Twin** | 0.908 / 0.600 | 0.922 / 0.657 | 0.569 / 0.457 | 0.571 / 0.467 |
| **Standard CAT** | 0.867 / 0.644 | 0.854 / 0.649 | 0.607 / 0.543 | 0.557 / 0.490 |
| **CAT (Data-matched Prior)** | **0.836** / 0.653 | **0.808** / 0.681 | 0.610 / 0.524 | 0.562 / 0.494 |
| **CAT with Forgetting** | 0.867 / 0.634 | 0.863 / 0.647 | 0.593 / 0.522 | 0.556 / 0.484 |
| **Fixed Staircase (0.30)** | 0.821 / 0.584 | 0.841 / 0.624 | **0.556** / 0.482 | **0.557** / 0.488 |
| **Legacy PFP-Core** | 0.997 / 0.710 | 1.002 / 0.735 | 0.712 / 0.616 | 0.681 / 0.583 |

*Key finding:* Supplying an empirical initial ability prior improves tracking accuracy by **0.16–0.33 logits across all methods**—a substantially larger margin than switching between controller policies.

### 3.3 Large Language Model Comparison ($N = 200$ Learners)
Benchmarked against Claude API across 20 rounds of batched item recommendation:
- **Default Tier:** $0.784$ MAE (data-shaped) / $0.933$ MAE (jump condition); $787.7\text{ ms}$ per decision.
- **Fast Tier:** $0.954$ MAE (data-shaped) / $1.323$ MAE (jump condition); $66.5\text{ ms}$ per decision.
- **LearningGate:** $0.722$ MAE (data-shaped) / $0.842$ MAE (jump condition); $0.4\text{ ms}$ per decision.

---

## 4. Repository Structure

```text
WerreduR/
├── README.md                   # Empirical positioning matrix & replication documentation
├── CHANGELOG.md                # Evolution log from v1 to v2
├── CITATION.cff                # Citation metadata referencing Zenodo Concept DOI
├── .zenodo.json                # Zenodo archive metadata configuration
├── index.html                  # Interactive GitHub Pages visual documentation
├── werr/                       # Production Python controller package
│   ├── learning_gate.py        # LearningGate, Staircase, PEST, CAT, PFPCore implementations
│   ├── engine.py               # WerrEngine execution runtime
│   ├── fractal.py              # Pure Python Mandelbrot & tripod quadrant extractor
│   └── gates/                  # Upstream WERR domain gates
├── tests/                      # Verification test suites
│   ├── test_learning_gate_parity.py  # Cross-language parity (Python/R/JS) & mathematical invariant suite
│   └── test_werredu_werr_core.py     # Upstream WERR engine unit tests
├── v2/                         # Complete empirical replication battery
│   ├── controller/             # R, Rcpp, seed search, trade-off sweeps (pfpw)
│   ├── data_shaped/            # Mixed logistic regression ASSISTments replay pipeline (replay)
│   ├── llm/                    # Language model benchmark runtime, JS port, frozen logs
│   └── data/README.md          # Data acquisition instructions and SHA-256 checksums
├── extras/                     # Exploratory research components outside the paper scope
│   ├── multi/                  # Multi-skill graph embedding and table compression
│   └── lens/                   # Real-data fractal fluctuation analysis
└── legacy/                     # Zenodo v4.0 archival directory preserving exact reproducibility
    ├── README_LEGACY.md        # Original v1 conceptual documentation
    ├── sim/                    # Legacy simulation scripts (PFP-Core)
    ├── lean4/                  # Formal Lean 4 verification of Z/9Z modular algebra
    ├── Procedural_Fractal_Pedagogy_Seed_Paper_v1.pdf  # Archived v1 preprint
    └── zenodo_dist/            # Frozen v1-v4 release packages
```

---

## 5. Reproduction & Verification

### 5.1 Python Parity & Invariant Battery
Run the verified cross-language parity suite directly:
```bash
python -m unittest tests/test_learning_gate_parity.py
python -m unittest discover tests
```
The test suite validates:
1. Multi-scale tripod escape ratios across 200 coordinates ($\Delta < 10^{-9}$; measured $\sim 10^{-15}$).
2. Sigmoid gate gains across 256 response histories ($\Delta < 10^{-9}$; measured $4.27 \times 10^{-15}$).
3. Strict response-flip symmetry ($g(\text{hist}) \equiv g(1 - \text{hist})$).
4. Analytical bounds of legacy PFP-Core ($|b| \le 1.13636$ logits due to $\kappa = 0.44$).
5. Analytical equivalence of PFP-Core with $\kappa = 0$ to a $0.50$ fixed staircase.
6. Equivalence of staircase rule to Elo item updates ($K = 2s$).
7. Node.js JavaScript port parity.
8. Group error means of the empirical LLM benchmark dataset ($0.784$ and $0.933$).

### 5.2 R Simulation Battery (Manuscript Record)
The R pipeline (`R >= 4.3`, `Rcpp`, `lme4`) generates the primary scientific numbers of the manuscript:
```bash
cd v2/controller
Rscript tests/test_parity.R
node tests/test_js_parity.js
Rscript R/01_run_simulation.R 1000 120
Rscript R/02_report.R
Rscript R/03_tradeoff.R
```

### 5.3 ASSISTments Replay
```bash
cd v2/data_shaped
Rscript 01_fit_learner_model.R
Rscript 02_replay.R
Rscript 03_validate_model.R
Rscript 04_saturating_learning.R
Rscript 05_replay_saturating.R
Rscript 06_second_dataset_fit.R
Rscript 06b_auc2017.R
Rscript 07_second_dataset_replay.R
```
*Note: Public datasets must be acquired following instructions in [`v2/data/README.md`](./v2/data/README.md).*

---

## 6. Limitations

1. **Simulation Bounds:** The study evaluates synthetic learners and empirical replays driven by mixed logistic regression; it does not report live clinical trials with human students.
2. **Item Pool Continuity:** Difficulty $b$ is treated as a continuous logit variable; real-world discrete item pools require nearest-neighbor retrieval or calibration offsets.
3. **Target Horizon:** The symmetric step-size formulation naturally converges to $P^* = 0.50$; educational settings targeting higher success rates ($P^* = 0.70-0.85$) require asymmetric up/down scaling.
4. **Platform Scope:** Both empirical datasets originate from ASSISTments platform variants; generalization to diverse learning platforms remains to be established.
5. **Exploratory Study:** This simulation study was not pre-registered.

---

## 7. Citation & Academic Integrity

This project maintains uninterrupted academic continuity with all published versions under the Zenodo Concept DOI:

- **Concept DOI (all versions):** [10.5281/zenodo.22999420](https://doi.org/10.5281/zenodo.22999420)
- **Version 4.0 Archive DOI:** [10.5281/zenodo.23128224](https://doi.org/10.5281/zenodo.23128224)

```bibtex
@article{dagli2026fractalcontroller,
  title={Where Does a Fractal-Seeded Controller Stand? A Simulation Study Positioning a 24-Byte, Estimation-Free Difficulty Controller Against Adaptive Testing, Staircase Rules and a Language Model},
  author={Da{\u{g}}l{\i}, Zerrin and Da{\u{g}}l{\i}, Volkan and Da{\u{g}}l{\i}, Da{\u{g}}han},
  year={2026},
  doi={10.5281/zenodo.22999420},
  url={https://doi.org/10.5281/zenodo.22999420}
}
```

---

## 8. License & Declarations

- **Code:** MIT License ([LICENSE](./LICENSE) / upstream `werr`).
- **Data & Documentation:** Creative Commons Attribution 4.0 International ([CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)).
- **Legacy Components:** Maintained under their original distribution terms in [`legacy/`](./legacy/).
