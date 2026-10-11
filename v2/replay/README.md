# Empirical Learner Replay on Real Student Practice Data

This directory replicates and validates the difficulty controllers on simulated learners whose parameters (starting proficiency, learning rates, and session lengths) are empirically estimated from real-world practice sequences.

Two independent benchmark cohorts are evaluated:
1. **ASSISTments 2009–2010 Skill-Builder:** 312,232 practice responses from 4,163 students across 123 skills (Feng et al., 2009).
2. **ASSISTments 2017 Dataset:** 942,816 practice responses from 1,709 students across 102 skills (Ghosh et al., 2020).

---

## Execution Instructions

```bash
# 1. Fit additive-factors mixed-effects logistic regression on ASSISTments 2009-2010 (via lme4)
Rscript 01_fit_learner_model.R

# 2. Run counterfactual replay simulation (4,000 sessions, student known vs. unknown)
Rscript 02_replay.R

# 3. Evaluate model predictive calibration and discrimination (AUC) on held-out sequences
Rscript 03_validate_model.R

# 4. Sensitivity analysis under front-loaded (logarithmic) learning
Rscript 04_saturating_learning.R
Rscript 05_replay_saturating.R

# 5. Cohort replication on ASSISTments 2017 dataset
Rscript 06_second_dataset_fit.R
Rscript 07_second_dataset_replay.R
```

---

## Key Files and Outputs

* **`01_fit_learner_model.R`:** Estimates random student effects ($lpha_s$), skill effects ($eta_k$), student-by-skill deviations ($u_{sk}$), and skill learning rates ($\gamma_k$) on the first 15 opportunities of each sequence using `lme4`.
* **`02_replay.R`:** Resamples session lengths and learning rates to simulate 4,000 learner sessions under both known and unknown initial level conditions.
* **`03_validate_model.R`:** Evaluates out-of-sample predictions on a 20% held-out test split, reporting AUC, Brier score, and calibration curves.
* **`out/`:** Contains fitted model objects (`learner_model.rds`, `learner_model_2017.rds`), validation metrics (`validation_metrics.csv`), and final alignment tables (`table_replay.csv`, `table_replay_2017.csv`, `table_replay_saturating.csv`).
