# Replication and Analysis Package

**Companion Code and Data for:**  
*"Where does a fractal-seeded difficulty controller stand? A simulation study against adaptive testing, staircase rules and a language model"*  
Submitted to *Computers and Education: Artificial Intelligence (CAEAI)*.

This package provides the complete, self-contained replication environment for all simulations, statistical models, sensitivity analyses, and figure generation scripts reported in the manuscript. All random seeds are fixed in the code to ensure byte-exact reproducibility.

---

## Directory Structure and Manuscript Mapping

The package is organized into dedicated modules aligned with the manuscript's research questions:

| Directory | Contents | Relevant Manuscript Sections |
| :--- | :--- | :--- |
| **`pfpw/`** | C++ kernel, R wrappers, fractal seed optimization (`LearningGate`), benchmark controllers (CAT, staircase/Elo, PEST, stored-weight twin, first version), 6 synthetic conditions (6,000 learners), finite bank, guessing remedy, and recovery/precision trade-off sweep. | **Section 3.3, Section 4.1 (RQ1), Section 4.2 (RQ2, RQ3), Section 4.4 (RQ5), Section 4.6** |
| **`replay/`** | Empirical learner models fitted to **1.25 million responses across ASSISTments 2009–2010 and 2017**, out-of-sample predictive validation, front-loaded learning curves, and counterfactual replay simulations (4,000 sessions). | **Section 3.2.3, Section 3.2.4, Section 4.3 (RQ4)** |
| **`llm_api/`** | Large Language Model (Claude Haiku 4.5 via Messages API) benchmark across 200 learners (3,800 decision calls), frozen parameters (temperature 0), recorded prompt traces, and comparison against baseline controllers. | **Section 3.3.4, Section 4.5 (RQ6)** |
| **`llm_pilot_runs/`** | Earlier pilot and artifact runtime evaluations of the language model reported as supporting evidence (Table S12). | **Section 4.5, Table S12** |
| **`data/`** | Provenance and automated setup instructions for downloading the public ASSISTments benchmark datasets. | **Section 3.2.3, Section 3.2.4** |

---

## System Requirements and Prerequisites

* **R (>= 4.3.0)**
* **Required R packages:** `Rcpp`, `lme4`, `ggplot2`, `httr2` (optional, for LLM API reruns), `jsonlite`
* **C++ Compiler:** Supporting C++11 or higher (standard g++, clang, or Rtools on Windows)
* **Python (>= 3.9):** Optional, for secondary parity checks

Pre-computed simulation outputs (`.rds`, `.csv`, `.log`) and high-resolution figures are already included in the respective `out/` subdirectories. You can inspect the results immediately without re-running long simulations.

---

## Quick Start: Replication Steps

### Step 1: Core Simulation Suite (`pfpw/`)
```bash
cd pfpw

# 1. Verify kernel parity between C++ and R
Rscript tests/test_parity.R

# 2. (Optional) Run evolutionary seed search (~10 min; pre-computed in out/seed_search.rds)
# Rscript R/00_seed_search.R

# 3. Run the primary 6-condition benchmark (6,000 synthetic learners, 120 trials each; ~15 min)
Rscript R/01_run_simulation.R 1000 120

# 4. Generate summary performance tables
Rscript R/02_report.R

# 5. Execute recovery vs. precision sweep (staircase step sizes 0.08–0.50)
Rscript R/03_tradeoff.R

# 6. Generate manuscript publication figures (Figure 1, Figure 2, Figure S1)
Rscript R/06_figures.R

# 7. Evaluate seed sensitivity across independent search optima
Rscript R/07_seed_sensitivity.R report
```
Output figures (`.png` and vector `.pdf`) and CSV tables are deposited in `pfpw/out/`.

---

### Step 2: Realistic Sessions with ASSISTments Data (`replay/`)
```bash
cd ../replay

# 1. Fit additive-factors mixed-effects logistic model to ASSISTments 2009-2010 (~3 min)
Rscript 01_fit_learner_model.R

# 2. Run replay simulations (4,000 sessions with empirical parameters)
Rscript 02_replay.R

# 3. Model predictive validation on held-out responses (AUC, calibration)
Rscript 03_validate_model.R

# 4. Sensitivity check under front-loaded (logarithmic) learning
Rscript 04_saturating_learning.R
Rscript 05_replay_saturating.R

# 5. Cohort replication on ASSISTments 2017
Rscript 06_second_dataset_fit.R
Rscript 07_second_dataset_replay.R
```
Fitted models and comparison tables (`table_replay.csv`, `table_replay_2017.csv`) are written to `replay/out/`.

---

### Step 3: Language Model Benchmark (`llm_api/`)
The exact sequence of difficulties presented and choices returned by Claude Haiku 4.5 across all 3,800 decision calls are recorded in `kararlar_claude_claude-haiku-4-5-20251001.csv` and `ozet_claude_claude-haiku-4-5-20251001.txt`.

To inspect or rerun:
```bash
cd ../llm_api
# Review the instructions in llm_api/README.md
```

---

## Methodological Notes for Independent Auditors

1. **Double-Anonymized Review Compliance:** All references to author names, institutional affiliations, and identifying GitHub repositories have been blinded.
2. **Deterministic Reproducibility:** Every simulation script explicitly sets random seeds (`set.seed(...)`).
3. **Execution Latency:** Compute benchmarks were recorded on a single core of a dedicated testing workstation; per-decision latencies will scale relative to host CPU architecture.
