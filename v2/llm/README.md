# Supporting Pilot Runs: Language Model Evaluations via Artifact Runtime

This directory contains the logs, interface files, and outputs of the two earlier pilot evaluations conducted through the claude.ai artifact runtime, reported as supporting evidence in Section 4.5 and Table S12 of the manuscript.

These runs evaluated the same 200 learners using batched requests (50 and 100 learners per call) across default and extended reasoning modes.

---

## Files in this Directory

* **`llm_kontrolcu_deneyi.html`:** Browser-based interface used to coordinate batched requests and record controller decisions.
* **`werr_cekirdek_js_portu.js`:** JavaScript port of the procedural fractal controller used for client-side benchmarking.
* **`ham_sonuclar_varsayilan_kademe_200_ogrenci.json`:** Raw JSON responses and difficulty sequences from the default-tier run.
* **`sonuclar_6_ekim_2026.txt`:** Summary benchmark report comparing default-tier and extended-reasoning pilot runs against reference rules.
