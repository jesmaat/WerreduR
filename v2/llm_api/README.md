# Large Language Model Benchmark (Claude Haiku 4.5 API)

This directory contains the script, input learner histories, and recorded decision logs for the empirical comparison between the procedural controllers and a modern large language model (Claude Haiku 4.5).

The benchmark was conducted under strictly controlled API conditions on 6 and 7 October 2026.

---

## Benchmark Design

* **Model Identifier:** `claude-haiku-4-5-20251001` (Anthropic Messages API)
* **Sampling Parameters:** Temperature = 0 (deterministic greedy decoding), maximum output tokens = 1,024
* **Sample Size:** 200 learners, 20 problems each (3,800 decision calls total):
  * **Group A (100 learners):** Empirical parameters derived from ASSISTments (student unknown)
  * **Group B (100 learners):** Stable proficiency undergoing an abrupt +1.5 logit jump before problem 11
* **Information Given to the Model:** Full history of difficulties and outcomes for that learner, the response model form, and scale. (True latent ability was never shown).

---

## Files in this Directory

* **`llm_api_deneyi.R`:** Execution script querying the API for each learner decision sequentially.
* **`ogrenciler.csv` / `learners.csv`:** Starting abilities, problem sequences, and random draws for all 200 learners.
* **`referans_kollar.csv` / `reference_controllers.csv`:** Recorded responses and tracking trajectories of the reference controllers on the exact same 200 learners.
* **`kararlar_claude_claude-haiku-4-5-20251001.csv`:** Full record of difficulties chosen by Claude Haiku across all 3,800 decisions.
* **`ozet_claude_claude-haiku-4-5-20251001.txt`:** Execution summary including mean absolute distance, paired differences, timing metrics, and token consumption statistics.

---

## Replication / Independent Verification

The full record of decisions is provided in `kararlar_claude_claude-haiku-4-5-20251001.csv`, allowing immediate verification of Table 8 in the manuscript without incurring API costs.

To run additional models or replicate using your own Anthropic API key:
1. Set your API key in your environment: `export ANTHROPIC_API_KEY="your_api_key"` (or via `Sys.setenv` in R).
2. Configure `SAGLAYICI` and `MODEL` parameters in `llm_api_deneyi.R`.
3. Run `Rscript llm_api_deneyi.R`.
