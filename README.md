# WerreduR: Adaptive Difficulty Control & Procedural Cognitive Reflex Engine

[![Status: Under Peer Review](https://img.shields.io/badge/Flagship%20Study-Under%20Peer%20Review-0284c7.svg)](#-track-1-flagship-q1-empirical-positioning-study)
[![Target: Flagship Q1 Journal](https://img.shields.io/badge/Target-Flagship%20Q1%20Learning%20Technologies-059669.svg)](#-track-1-flagship-q1-empirical-positioning-study)
[![Double-Blind Replication Portal](https://img.shields.io/badge/Double--Blind%20Replication-OSF%20(Open%20Science)-6b7280.svg)](https://osf.io/d98ey/overview?view_only=8472836f71144e22afa950bc98feb6f2)
[![Canonical Repo](https://img.shields.io/badge/Canonical%20Repo-jesmaat%2FWerreduR-181717.svg?logo=github)](https://github.com/jesmaat/WerreduR)
[![Mirror](https://img.shields.io/badge/Engineering%20Mirror-pCwOrM%2FWerreduR-blue.svg?logo=github)](https://github.com/pCwOrM/WerreduR)
[![Werr Certified](https://img.shields.io/badge/Werr%20Ecosystem-Validated%20Controller-059669.svg)](https://answerr.me)
[![Replication Package](https://img.shields.io/badge/Replication%20Package-v2.0%20(7.4%20MB)-emerald.svg)](./releases/Supplementary_Code_and_Data_v2.zip)
[![Zenodo v4.0 Archive](https://img.shields.io/badge/Zenodo%20v4.0%20Archive-10.5281%2Fzenodo.23128224-blue.svg)](https://doi.org/10.5281/zenodo.23128224)
[![Concept DOI](https://img.shields.io/badge/Concept%20DOI%20(All%20Versions)-10.5281%2Fzenodo.22999420-indigo.svg)](https://doi.org/10.5281/zenodo.22999420)
[![SSRN: 7641538 (Approved)](https://img.shields.io/badge/SSRN-7641538%20(Approved)-059669.svg)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7641538)

[![Lean 4 Formal Proofs](https://img.shields.io/badge/Lean%204-7%20Theorems%20(0%20sorry)-7c3aed.svg)](./legacy/lean4/PFP_HorizonProof.lean)
[![Parity Tests](https://img.shields.io/badge/Parity%20Tests-9%2F9%20Passing-emerald.svg)](./tests/test_learning_gate_parity.py)
[![License: BSL 1.1](https://img.shields.io/badge/License-BSL%201.1%20(Free%20Academic)-orange.svg)](./LICENSE)
[![Live Web Simulator](https://img.shields.io/badge/Live%20Simulator-pcworm.github.io%2FWerreduR-0284c7.svg)](https://pcworm.github.io/WerreduR/)
[![Sister Repo: GDT Lean4](https://img.shields.io/badge/Sister%20Repo-GDT%20Lean4-024dad.svg)](https://github.com/pCwOrM/general-divisor-theorem)
[![Sister Repo: Niemeier A8^3 Moonshine](https://img.shields.io/badge/Sister%20Repo-Niemeier%20A8%5E3%20Moonshine-024dad.svg)](https://github.com/pCwOrM/niemeier-a8-umbral-moonshine)
[![Sister Repo: Schönhage Record](https://img.shields.io/badge/Sister%20Repo-Sch%C3%B6nhage%20Record-brightgreen.svg)](https://github.com/pCwOrM/integer-mult-bounds)
[![arXiv:2610.14263](https://img.shields.io/badge/arXiv-2610.14263%20%5Bcs.CC%5D-b31b1b.svg)](https://arxiv.org/abs/2610.14263)
[![arXiv DOI: 10.48550/arXiv.2610.14263](https://img.shields.io/badge/DOI-10.48550%2FarXiv.2610.14263-b31b1b.svg)](https://doi.org/10.48550/arXiv.2610.14263)
[![CrocSwap PR #226: Incorporated](https://img.shields.io/badge/CrocSwap%20Main-PR%20%23226%20Incorporated%20(50d76881)-brightgreen.svg)](https://github.com/CrocSwap/integer-mult-bounds/blob/50d768818f579d4e165b4c257c6ee25bca300802/docs/research/community-reconciliation-next100-review.md)
[![Ecosystem: WERRobotics](https://img.shields.io/badge/WERRobotics-Arduino%20%26%20Edge%20AI-ff9100.svg?logo=arduino&logoColor=white)](https://github.com/pCwOrM/WERRobotics)
[![Academic: werr.io](https://img.shields.io/badge/Academic%20Portal-werr.io-0284c7.svg?logo=cloudflare&logoColor=white)](https://werr.io/)
[![Web3: werracle.io](https://img.shields.io/badge/Web3%20Protocol-werracle.io-f59e0b.svg?logo=cloudflare&logoColor=white)](https://werracle.io/)
[![Corporate: werracle.com](https://img.shields.io/badge/Corporate%20Portal-werracle.com-2b3bd1.svg?logo=cloudflare&logoColor=white)](https://werracle.com/)
[![Sister Repo: NSF ICARM 230 Curves](https://img.shields.io/badge/Sister%20Repo-NSF%20ICARM%20Elliptic%20Sieve%20(230%20Curves)-blue)](https://github.com/pCwOrM/werr-elliptic-sieve)
[![Cloud Vault: R2 Active](https://img.shields.io/badge/Cloud%20Vault-Cloudflare%20R2%20Active-f38020.svg?logo=cloudflare&logoColor=white)](https://werracle.com/)

---

> [!IMPORTANT]
> ### 🏛️ Cumulative Academic Architecture & Multi-Track Scientific Portal
>
> This repository is the open-science home of **WerreduR**, developed and validated within the **Werr cognitive architecture environment** ([answerr.me](https://answerr.me) / ITouch Systems). To preserve unbroken scientific continuity, earlier publications, datasets, and formal proofs remain permanently accessible alongside our latest empirical breakthroughs:
>
> 1. **[Track 1: Flagship Q1 Empirical Positioning Study (Under Double-Blind Peer Review)](#-track-1-flagship-q1-empirical-positioning-study)** *(Flagship Milestone)*  
>    * **Title:** *"Where does a fractal-seeded difficulty controller stand? A simulation study against adaptive testing, staircase rules and a language model"*  
>    * **Venue:** Under Double-Blind Peer Review at a flagship Q1 journal in Learning Technologies & Intelligent Educational Systems.  
>    * **Contents:** Rigorous benchmarking of the estimation-free, 24-byte difficulty controller (`LearningGate`) against Computerized Adaptive Testing (CAT, Rasch EAP), fixed staircases (= Elo), accelerated PEST, stored-weight twins, and frontier LLM (Claude Haiku 4.5 across 3,800 decisions). Verified across 6,000 synthetic learners and empirical replays on **1.25 million interactions** from ASSISTments 2009–2010 and 2017.  
>    * **Quick Access:** [📦 Complete Replication Suite (.zip)](./releases/Supplementary_Code_and_Data_v2.zip) | [🔬 Code & Data Directory](./v2/) | [🔒 Anonymized OSF Portal](https://osf.io/d98ey/overview?view_only=8472836f71144e22afa950bc98feb6f2)
>
> 2. **[Track 2: Published Seed Preprint & SSRN Working Paper (Version 4.0)](#-track-2-published-seed-preprint--ssrn-working-paper-version-40)** *(Foundational Theory)*  
>    * **Title:** *"Procedural Fractal Pedagogy: Resolving the Saturn School Disequilibrium Paradox in Self-Directed AI Education via Zero-Storage Mandelbrot Boundary Reflexes"*  
>    * **Preprint Identifiers:** SSRN: [`7641538`](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7641538) | Zenodo DOI: [`10.5281/zenodo.23128224`](https://doi.org/10.5281/zenodo.23128224) | Concept DOI: [`10.5281/zenodo.22999420`](https://doi.org/10.5281/zenodo.22999420) | TR Priority Patent Application: `TR 2026/016285`  
>    * **Contents:** Theoretical framework anchoring Vygotsky's Zone of Proximal Development (ZPD) to Mandelbrot boundary resonances, 7 machine-checked theorems in Lean 4 (0 sorry), and $N=1,000$ self-directed learning trajectory simulations.  
>    * **Quick Access:** [📑 SSRN Paper (ID: 7641538)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7641538) | [📄 SSRN Camera-Ready PDF](./releases/Procedural_Fractal_Pedagogy_SSRN_Preprint.pdf) | [📄 Camera-Ready PDF](./releases/Procedural_Fractal_Pedagogy_Seed_Paper_v1.pdf) | [📋 SSRN Guide](./SSRN_YUKLEME_REHBERI.md) | [📜 Lean 4 Proofs](./legacy/lean4/PFP_HorizonProof.lean)
>
> 3. **[Track 3: Historical Archival Corpus (Version 1.0 & PFP-Core Heritage)](#-track-3-historical-archival-corpus-legacy)** *(Cumulative Archive)*  
>    * All historical telemetry, initial seed papers, LaTeX drafts, and Zenodo distributions are preserved in [`legacy/`](./legacy/) ensuring 100% citation persistence.

---

## 👥 Authors & Affiliations

* **Zerrin Dağlı** *(First & Corresponding Author)* — Mersin University, Mersin, Turkey • ORCID: [`0000-0001-9490-6425`](https://orcid.org/0000-0001-9490-6425) • SSRN: [`13656028`](https://ssrn.com/author=13656028)
* **Volkan Dağlı** — Anadolu University, Eskişehir, Turkey & ITouch Systems, Cukurova University Science Park, Adana, Turkey • ORCID: [`0009-0000-1587-8703`](https://orcid.org/0009-0000-1587-8703) • SSRN: [`13655808`](https://ssrn.com/author=13655808) (`@pCwOrM`)
* **Dağhan Dağlı** — Toros University, Mersin, Turkey • ORCID: [`0009-0003-2492-8313`](https://orcid.org/0009-0003-2492-8313) • SSRN: [`13656048`](https://ssrn.com/author=13656048) (`@Lexovian`)

### 🌐 Companion Open-Science Corpus & Cross-Verification
* **PFP / WerreduR (This Work):** `doi:10.5281/zenodo.23128224 (v4.0)` • Concept DOI: `10.5281/zenodo.22999420` ([GitHub: `jesmaat/WerreduR`](https://github.com/jesmaat/WerreduR) • [Mirror: `pCwOrM/WerreduR`](https://github.com/pCwOrM/WerreduR) • [Live Simulator](https://pcworm.github.io/WerreduR/))
* **WERR Core Decision Engine:** `arXiv:2609.25498` • `doi:10.5281/zenodo.22939253` ([GitHub: `pCwOrM/werr`](https://github.com/pCwOrM/werr))
* **GAP → Lean 4 Formal Verification:** `arXiv:2609.38492` • `doi:10.5281/zenodo.23045504` ([GitHub: `pCwOrM/gap-lean4-port`](https://github.com/pCwOrM/gap-lean4-port))
* **WerrSoma Whole-Brain Connectome (158K Neurons):** `doi:10.5281/zenodo.23072929 (v1.1)` • [Live Portal: werrsoma.answerr.me](https://werrsoma.answerr.me/) ([GitHub: `Lexovian/WerrSoma`](https://github.com/Lexovian/WerrSoma))
* **Güneş Dili Formal Phonetics & Morphology:** `doi:10.5281/zenodo.23273006` ([GitHub: `pCwOrM/gunes-dili`](https://github.com/pCwOrM/gunes-dili))
* **answerr Reflex AI & Live Workspace:** `https://answerr.me` ([GitHub: `pCwOrM/answerr`](https://github.com/pCwOrM/answerr))
* **Orbital Error Dynamics (OED):** `arXiv:2609.30115` • `doi:10.5281/zenodo.22896856`
* **Mandelbrot Fractal Neural Synthesis (MFNS):** `doi:10.5281/zenodo.22774934` ([GitHub: `pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis))
* **Lean 4 Formal Verification & 40-Core Gauntlet:** `arXiv:2609.33066` • `doi:10.5281/zenodo.22983889`
* **Werracle Sub-Cent Intra-Block EVM AI Oracle:** `arXiv:2609.30719` • `doi:10.5281/zenodo.22942598` ([GitHub: `pCwOrM/werracle`](https://github.com/pCwOrM/werracle))
* **Schönhage Tensor Carrier Compression (World Record):** [`arXiv:2610.14263`](https://arxiv.org/abs/2610.14263) ([PDF](https://arxiv.org/pdf/2610.14263) • [DOI: `10.48550/arXiv.2610.14263`](https://doi.org/10.48550/arXiv.2610.14263) • `arXiv: submit/8207241`) • `doi:10.5281/zenodo.23268580` ([GitHub: `pCwOrM/integer-mult-bounds`](https://github.com/pCwOrM/integer-mult-bounds)) • [CrocSwap PR #226 (`incorporated`)](https://github.com/CrocSwap/integer-mult-bounds/pull/226) • [Contributors (`@pCwOrM`)](https://github.com/CrocSwap/integer-mult-bounds/blob/50d768818f579d4e165b4c257c6ee25bca300802/CONTRIBUTORS.md) • [Audit (`50d76881`)](https://github.com/CrocSwap/integer-mult-bounds/blob/50d768818f579d4e165b4c257c6ee25bca300802/docs/research/community-reconciliation-next100-review.md)
* **General Divisor Theorem (GDT) Lean 4:** `doi:10.5281/zenodo.23316070` ([GitHub: `pCwOrM/general-divisor-theorem`](https://github.com/pCwOrM/general-divisor-theorem))
* **24D Niemeier Lattice $A_8^3$ & K3 Umbral Moonshine Lean 4:** `doi:10.5281/zenodo.23324066` • Record `23324067` ([GitHub: `pCwOrM/niemeier-a8-umbral-moonshine`](https://github.com/pCwOrM/niemeier-a8-umbral-moonshine))

---

## 🏆 Track 1: Flagship Q1 Empirical Positioning Study (Under Double-Blind Peer Review)

### *Where does a fractal-seeded difficulty controller stand? A simulation study against adaptive testing, staircase rules and a language model*

**Authors:**  
* **Zerrin Dağlı** *(Corresponding Author)* — Mersin University, Mersin, Turkey • ORCID: [`0000-0001-9490-6425`](https://orcid.org/0000-0001-9490-6425) • SSRN: [`13656028`](https://ssrn.com/author=13656028)  
* **Volkan Dağlı** — Anadolu University, Eskişehir, Turkey & ITouch Systems, Mersin, Turkey • ORCID: [`0009-0000-1587-8703`](https://orcid.org/0009-0000-1587-8703) • SSRN: [`13655808`](https://ssrn.com/author=13655808)  
* **Dağhan Dağlı** — Toros University, Mersin, Turkey • ORCID: [`0009-0003-2492-8313`](https://orcid.org/0009-0003-2492-8313) • SSRN: [`13656048`](https://ssrn.com/author=13656048)  

**Target Journal:** Flagship Q1 Journal in Learning Technologies & Intelligent Educational Systems (Under Double-Blind Peer Review)  
**Double-Blind Review Portal:** [OSF Anonymized View-Only Node](https://osf.io/d98ey/overview?view_only=8472836f71144e22afa950bc98feb6f2)  
**Canonical Repository:** [`https://github.com/jesmaat/WerreduR`](https://github.com/jesmaat/WerreduR)  
**Engineering Mirror:** [`https://github.com/pCwOrM/WerreduR`](https://github.com/pCwOrM/WerreduR)  
**Werr Ecosystem:** Validated and certified production difficulty controller within `werr` ([answerr.me](https://answerr.me))  

---

### 📄 Executive Summary & Findings

Modern Computerized Adaptive Testing (CAT) provides optimal difficulty tracking in stationary settings when backed by heavily calibrated item banks, but struggles under rapid learner trajectory shifts, requiring continuous numerical estimation. Simple psychophysical staircase procedures adapt instantaneously but lack multi-scale contextual awareness. Frontier Large Language Models (LLMs) can select items heuristically but introduce prohibitive latency, stochastic outputs, and multi-gigabyte memory footprints.

This study isolates and benchmarks **`LearningGate`**, an estimation-free adaptive difficulty controller whose step-size dynamics are procedurally driven by a frozen **24-byte coordinate seed** $\Theta^* = (cx_0 = -0.807926, cy_0 = 0.183021, z_0 = 300.0)$ on the sub-boundary of the Mandelbrot set evaluated via the WERR multi-scale tripod kernel.

```
                    ┌──────────────────────────────────────────────┐
                    │               Learner Response               │
                    │                   x ∈ {0, 1}                 │
                    └──────────────────────┬───────────────────────┘
                                           │
                                           ▼
                    ┌──────────────────────────────────────────────┐
                    │      State Vector: Recent Bits + Bias        │
                    │   h = [h0, h1, h2, h3],  ρ ∈ [-3.0, 3.0]     │
                    └──────────────────────┬───────────────────────┘
                                           │
                                           ▼
                    ┌──────────────────────────────────────────────┐
                    │       Feature Projection & Modulation        │
                    │  dx, dy, dz derived from agreement / bias    │
                    └──────────────────────┬───────────────────────┘
                                           │
                                           ▼
                    ┌──────────────────────────────────────────────┐
                    │        WERR Multi-Scale Tripod Kernel        │
                    │  Sub-boundary polynomial escape ratios (q)   │
                    │        Evaluated at 0.60x, 1.00x, 1.60x      │
                    └──────────────────────┬───────────────────────┘
                                           │
                                           ▼
                    ┌──────────────────────────────────────────────┐
                    │            Sigmoid Gain Neuron               │
                    │        g = σ(w1*a1 + w2*a2 + w3*m + w4)      │
                    └──────────────────────┬───────────────────────┘
                                           │
                                           ▼
                    ┌──────────────────────────────────────────────┐
                    │         Servo Step & Item Difficulty         │
                    │     step = 0.05 + 0.55 * g   [0.05, 0.60]    │
                    │           b ← b + step * (2x - 1)            │
                    └──────────────────────────────────────────────┘
```

#### Key Empirical Results:
1. **Dynamic Tracking Advantage:** Under fast-learning and abrupt trajectory jumps (+1.5 logits), `LearningGate` achieves a **+0.21 to +0.33 logit alignment advantage** over standard Rasch CAT and re-centers within **10.4 trials** (vs. 56.0 trials for CAT).
2. **24-Byte Seed Non-Inferiority:** Demonstrates empirical non-inferiority to its 4-parameter stored-weight twin across 18 of 18 test comparisons ($\Delta \le 0.003$ logits).
3. **Real-World Empirical Validation:** Evaluated via counterfactual replays on mixed-effects learner models fitted to **1.25 million interactions** from ASSISTments 2009–2010 ($N = 4,163$) and ASSISTments 2017 ($N = 1,709$), maintaining consistent convergence under empirical student response noise.
4. **LLM API Benchmark:** Benchmarked against Claude Haiku 4.5 across 200 learners (3,800 API calls, temperature 0). The LLM incurred $67-788\text{ ms}$ latency with $0.784-0.933$ logit alignment error, whereas `LearningGate` executed in **$0.3-0.4\text{ ms}$** ($418\ \mu\text{s}$) with $0.419$ logit error and zero cloud dependency.

---

### 📊 Comparative Positioning Matrix

| Controller Architecture | Underlying Model | State Memory | Per-Item Latency | Stationary MAE | Fast Learning Lag | Recovery After Jump | Guessing Robustness | Target $P^*$ |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Standard CAT (Rasch EAP)** | Latent $\theta \sim \mathcal{N}(0, 1)$ + Calibrated Bank | 121 floats (grid) | $0.008\text{ ms}$ | **0.257 logits** | 0.755 logits | 56.0 trials (slow) | **0.496 logits** | Configurable |
| **Fixed Staircase (Elo $K=2s$)** | None | 1 float | **< 0.003 ms** | 0.356 logits | 0.401 logits | 14.8 trials | 0.634 logits | $P^* = 0.50$ |
| **Accelerated PEST** | None | 3 floats | **< 0.002 ms** | 0.412 logits | 0.465 logits | 11.7 trials | 0.750 logits | $P^* = 0.50$ |
| **`LearningGate` (Ours, 24-Byte)** | WERR Tripod Sub-Boundary | 24-byte seed + 6 floats | $0.3-0.4\text{ ms}$ | 0.419 logits | **0.380 logits** | **10.4 trials (fastest)** | 0.734 logits | $P^* = 0.50$ |
| **Stored-Weight Twin** | 4-Float Linear Neuron | 4 floats + 6 floats | $0.001\text{ ms}$ | 0.418 logits | 0.381 logits | 10.4 trials | 0.735 logits | $P^* = 0.50$ |
| **Frontier LLM (Claude Haiku 4.5)** | In-context Prompt Heuristic | Multi-GB VRAM | $67 - 788\text{ ms}$ | 0.784 logits | Lagged | Unstable | High variance | Variable |

---

### 📥 Track 1 Replication Package & Double-Blind Review Assets

* **Manuscript Status:** Currently under double-blind peer review at a leading Q1 journal in Learning Technologies & Intelligent Educational Systems. In strict compliance with double-anonymized peer review policies and to protect against pre-publication web indexing (iThenticate / Turnitin / Crossref), raw manuscript drafts and submission documents are maintained under confidential academic embargo until formal acceptance. Independent peer reviewers can access and inspect the complete anonymized replication suite via the [OSF View-Only Node](https://osf.io/d98ey/overview?view_only=8472836f71144e22afa950bc98feb6f2).
* 📦 **[Supplementary_Code_and_Data_v2.zip](./releases/Supplementary_Code_and_Data_v2.zip)** — Complete, self-contained, byte-exact replication archive (7.4 MB).
* 🔬 **[v2/ Replication Suite Directory](./v2/)**:
  * [`v2/pfpw/`](./v2/pfpw/): C++ kernel (`werr_kernel.cpp`), R wrappers, simulation runs, finite bank tests, guessing remedies, sensitivity sweeps, and vector publication figures (`Figure 1`, `Figure 2`, `Figure S1`).
  * [`v2/replay/`](./v2/replay/): ASSISTments 2009–2010 and 2017 mixed models and counterfactual replay scripts.
  * [`v2/llm_api/`](./v2/llm_api/): Claude Haiku 4.5 API decision traces across 200 learners (3,800 calls).
  * [`v2/llm_pilot_runs/`](./v2/llm_pilot_runs/): Pilot benchmark runtime (`llm_kontrolcu_deneyi.html`) and raw telemetry.
  * [`v2/data/`](./v2/data/): ASSISTments dataset provenance and automated retrieval instructions.

---

## 🚀 Track 2: Published Seed Preprint & SSRN Working Paper (Version 4.0)

### *Procedural Fractal Pedagogy: Resolving the Saturn School Disequilibrium Paradox in Self-Directed AI Education via Zero-Storage Mandelbrot Boundary Reflexes*

**Preprint Identifiers:**  
* **Version 4.0 DOI:** [`10.5281/zenodo.23128224`](https://doi.org/10.5281/zenodo.23128224) (October 4, 2026)  
* **Concept DOI:** [`10.5281/zenodo.22999420`](https://doi.org/10.5281/zenodo.22999420)  
* **Patent Application:** TÜRKPATENT National Priority Application No. `TR 2026/016285`  
* **SSRN Abstract ID:** [`7641538`](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7641538) (Status: **APPROVED** • CC BY-NC-ND)  
* **Related Preprints:** [SSRN: 7626279 (Werracle)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7626279) • [arXiv:2609.25498](https://arxiv.org/abs/2609.25498) • [arXiv:2609.30115](https://arxiv.org/abs/2609.30115)  

### 📄 Abstract
In this foundational paper, we formalize Vygotsky’s Zone of Proximal Development (ZPD) and Reigeluth’s disequilibrium corridor as an explicit **Observer Horizon Corridor** anchored at sub-boundary resonance shoulder loci $X_{\text{upper}} = (0.25, +0.18)$ and $X_{\text{lower}} = (0.25, -0.18)$ along the boundary of the Mandelbrot set ($\partial\mathcal{M}$, $z_{n+1} = z_n^2 + c$). Across $N = 1,000$ simulated self-directed learner trajectories ($T = 120$ cycles), the zero-storage reflex engine achieved $94.19\% \pm 0.14\%$ time-on-task retention and $89.24\% \pm 0.13\%$ ZPD residence, mitigating off-task learner drift without cloud LLM dependencies. Student assessment is formalized as a non-dissipative error-kernel invariant ($\mathcal{K}_{\text{error}} \cong \mathcal{I}_3 \subset \mathbb{Z}/9\mathbb{Z}$) governed by the **TAMAMe Horizon Complementarity** law $B(t) + S(t) = 1$, machine-verified in **Lean 4** with zero `sorry` axioms.

### 📥 Track 2 Resources
* 📄 **[Download Camera-Ready PDF](./releases/Procedural_Fractal_Pedagogy_Seed_Paper_v1.pdf)** — 2-column preprint PDF.
* 📑 **[Download SSRN Camera-Ready PDF](./releases/Procedural_Fractal_Pedagogy_SSRN_Preprint.pdf)** — SSRN / ERN camera-ready preprint PDF.
* 📋 **[SSRN Yükleme Rehberi (Step-by-Step Guide)](./SSRN_YUKLEME_REHBERI.md)** — Kopyala-yapıştır SSRN başvuru rehberi.


* 📜 **[Lean 4 Machine Proofs](./legacy/lean4/PFP_HorizonProof.lean)** — 7 theorems machine-checked with zero `sorry` axioms.
* 🎮 **[Interactive Web Simulator](https://pcworm.github.io/WerreduR/)** — In-browser visualization of the Mandelbrot Observer Horizon.

---

## 🏛️ Track 3: Historical Archival Corpus (Legacy)

All assets prior to Version 2.0 are preserved in [`legacy/`](./legacy/) for continuous verification of past citations:
* **`legacy/zenodo_dist/`**: Zenodo v1/v4 distribution bundles and SHA-256 seal manifests.
* **`legacy/sim/` & `legacy/data/`**: Raw telemetry and simulation scripts for early PFP-Core studies.
* **`legacy/lean4/`**: Machine-checked Lean 4 formal proofs.
* **`legacy/README_LEGACY.md`**: Original documentation and historical benchmarks.

---

## 📁 Repository Directory Structure

```text
WerreduR/
├── README.md                                    # 📖 Ana bilimsel portal ve kümülatif yol haritası
├── CHANGELOG.md                                 # 📜 Sürüm günlüğü (v1.0 -> v4.0 -> v2.0 -> v2.1 Q1)
├── CITATION.cff                                 # 📑 Akademik atıf künyesi
├── .zenodo.json                                 # 🌐 Zenodo metadata yapılandırması
├── LICENSE                                      # ⚖️ Business Source License 1.1 (BSL 1.1)
├── index.html                                   # 🌐 Canlı GitHub Pages web simülatörü
│
├── v2/                                          # 🔬 Track 1: Q1 Ampirik Replikasyon ve Veri Paketi
│   ├── README.md                                # Replikasyon rehberi ve çalıştırma talimatları
│   ├── pfpw/                                    # C++ çekirdeği, R wrapperları, 6 sentetik koşul
│   │   ├── src/werr_kernel.cpp                  # C++11 optimize WERR tripod fraktal çekirdeği
│   │   ├── R/                                   # 00_seed_search.R ... 07_seed_sensitivity.R
│   │   ├── tests/                               # test_parity.R, test_js_parity.js, referans csv'ler
│   │   └── out/                                 # RDS verileri, CSV tabloları, Figure 1, 2, S1
│   ├── replay/                                  # ASSISTments ampirik karma modelleri & replay
│   │   ├── 01_fit_learner_model.R ... 07_second_dataset_replay.R
│   │   └── out/                                 # Model ağırlıkları, AUC kalibrasyonu, replay tabloları
│   ├── llm_api/                                 # Claude Haiku 4.5 API deneyi (200 öğrenci, 3.800 çağrı)
│   │   ├── kararlar_claude_claude-haiku-4-5-20251001.csv
│   │   ├── llm_api_deneyi.R
│   │   └── ozet_claude_claude-haiku-4-5-20251001.txt
│   ├── llm_pilot_runs/                          # Destekleyici pilot çalıştırmalar (Tablo S12)
│   ├── llm/                                     # Pilot çalışma test uyumluluk köprüsü
│   └── data/                                    # ASSISTments veri indirme talimatları ve provenance
│
├── werr/                                        # 🧠 WERR Ekosisteminde Doğrulanmış Üretim Çekirdeği
│   ├── learning_gate.py                         # Üretim sınıfı LearningGate kontrolcüsü
│   ├── engine.py                                # Kognitif refleks motoru
│   ├── fractal.py                               # Fraktal & Tripod çekirdeği
│   └── ...
│
├── tests/                                       # 🧪 Otomasyonlu Test Paketi
│   └── test_learning_gate_parity.py             # 9/9 Geçen Parite ve Değişmezlik Testleri (C++, R, JS, Python)
│
├── releases/                                    # 📦 Dağıtım Paketleri ve İndirmeler
│   ├── Supplementary_Code_and_Data_v2.zip       # Q1 eksiksiz replikasyon arşivi (7.4 MB)
│   ├── Procedural_Fractal_Pedagogy_SSRN_Preprint.pdf # Track 2: SSRN onaylı önbaskı PDF (ID: 7641538)
│   └── Procedural_Fractal_Pedagogy_Seed_Paper_v1.pdf # Track 2: Zenodo açık bilim önbaskı PDF
│
└── legacy/                                      # 🏛️ Track 3: Önceki Yayınların Tüm Arşiv Verileri
    ├── lean4/PFP_HorizonProof.lean              # Lean 4 Biçimsel Doğrulama (7 teorem, 0 sorry)
    ├── zenodo_dist/                             # Zenodo v1/v4 dağıtım paketleri & manifestolar
    ├── sim/ & data/                             # İlk yayın simülasyon ve veri kaynakları
    └── README_LEGACY.md                         # Tarihsel dokümantasyon
```

---

## 🛠️ Verification & Testing

Verify cross-language parity, exact mathematical invariants, and benchmark consistency:

```bash
# Verify LearningGate Parity (C++, R, JS, Python, Elo identity, analytical bounds)
python tests/test_learning_gate_parity.py
```
*Output: 9/9 tests pass with $\Delta < 10^{-9}$ floating-point precision.*

To run the full R simulation suite:
```bash
cd v2/pfpw
Rscript tests/test_parity.R
Rscript R/01_run_simulation.R 1000 120
Rscript R/02_report.R
```

---

## 🏛️ Associated Formal Verification, World Records & Scientific Corpus

All monographs, formal Lean 4 specifications, and empirical datasets across the **WERR & ITouch Systems Research Group** are permanently archived on **CERN Zenodo**, **arXiv**, **Elsevier SSRN**, and **Hugging Face**.  
*(Primary links use **CERN Zenodo Concept DOIs / Çatı DOI**, which automatically resolve to the latest published version while preserving exact version-pinned reproducibility.)*

| # | Pillar / Monograph | Core Contribution & Focus | 👑 Concept DOI (Always Latest) | 📌 Latest Version DOI | arXiv / SSRN / Hugging Face & Verification Status | Primary Repository |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **01** | **Paper 1: FNS** | Procedural Weight Derivation & Non-Linear Decision Boundaries (v3) | [**`10.5281/zenodo.22774934`**](https://doi.org/10.5281/zenodo.22774934) | [`10.5281/zenodo.22867037`](https://doi.org/10.5281/zenodo.22867037) | [**SSRN: 7659198**](https://papers.ssrn.com/abstract=7659198) *(Distributed)* • Multi-Seed Pareto & Manifold Parity | [`pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis) |
| **02** | **Paper 2: OED** | Orbital Error Dynamics, Ephemeral Parameter Resonance & CD4+ Gating (v1) | [**`10.5281/zenodo.22900464`**](https://doi.org/10.5281/zenodo.22900464) | [`10.5281/zenodo.22900465`](https://doi.org/10.5281/zenodo.22900465) | [`arXiv:2609.30115`](https://arxiv.org/abs/2609.30115) • [🤗 HF Paper](https://huggingface.co/papers/2609.30115) *(Verified)* • `TR 2026/016285` | [`pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis) |
| **03** | **Paper 3: WERR Map** | Universal Natural Language Decision Map & Real-Time Edge Triage (v2) | [**`10.5281/zenodo.22867425`**](https://doi.org/10.5281/zenodo.22867425) | [`10.5281/zenodo.22939253`](https://doi.org/10.5281/zenodo.22939253) | [`arXiv:2609.25498`](https://arxiv.org/abs/2609.25498) • [🤗 HF Paper](https://huggingface.co/papers/2609.25498) • [🤗 HF Dataset](https://huggingface.co/datasets/pCwOrM/werr_open_decisions) | [`pCwOrM/werr`](https://github.com/pCwOrM/werr) • [`pCwOrM/answerr`](https://github.com/pCwOrM/answerr) |
| **04** | **Paper 4: Werracle** | Sub-Cent Intra-Block AI Reflex Oracles & Flash-Loan Circuit Breakers (v1) | [**`10.5281/zenodo.22942598`**](https://doi.org/10.5281/zenodo.22942598) | [`10.5281/zenodo.22942599`](https://doi.org/10.5281/zenodo.22942599) | [`arXiv:2609.30719`](https://arxiv.org/abs/2609.30719) • [**SSRN: 7626279**](https://papers.ssrn.com/abstract=7626279) • [🤗 HF Paper](https://huggingface.co/papers/2609.30719) | [`pCwOrM/werracle`](https://github.com/pCwOrM/werracle) • [`pCwOrM/werralem`](https://github.com/pCwOrM/werralem) |
| **05** | **Paper 5: Formal Lean 4** | Zero-Storage Procedural Synthesis: Lean 4 Verification & 40-Core Validation | [**`10.5281/zenodo.22774934`**](https://doi.org/10.5281/zenodo.22774934) | [`10.5281/zenodo.22867037`](https://doi.org/10.5281/zenodo.22867037) | [`arXiv:2609.33066`](https://arxiv.org/abs/2609.33066) • [🤗 HF Paper](https://huggingface.co/papers/2609.33066) • **Lean 4 (`10 Theorems, 0 sorry`)** | [`pCwOrM/werr`](https://github.com/pCwOrM/werr) • [`pCwOrM/werracle`](https://github.com/pCwOrM/werracle) |
| **06** | **Paper 6: GAP-Lean4** | Machine-Checked Computational Group Theory: Schreier-Sims & BSGS Sifting (v2) | [**`10.5281/zenodo.23092708`**](https://doi.org/10.5281/zenodo.23092708) | [`10.5281/zenodo.23156544`](https://doi.org/10.5281/zenodo.23156544) | [`arXiv:2609.38492`](https://arxiv.org/abs/2609.38492) • [🤗 HF Paper](https://huggingface.co/papers/2609.38492) • **Lean 4 (`35 Theorems, 0 sorry`)** | [`pCwOrM/gap-lean4-port`](https://github.com/pCwOrM/gap-lean4-port) |
| **07** | **Paper 7: Black Hole v5** | Unitary Black Hole Page Curve via Dynamical Horizon Orbifolds & GKP Stabilizers (v5) | [**`10.5281/zenodo.22961999`**](https://doi.org/10.5281/zenodo.22961999) | [`10.5281/zenodo.23072120`](https://doi.org/10.5281/zenodo.23072120) | `S(t=1) = 0.00` · `Tr(ρ²) = 1.00` · `R² = 0.9822` · **573× Stress Quench** • **Lean 4 (`10 Theorems`)** | [`pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis) • [`pCwOrM/werr`](https://github.com/pCwOrM/werr) |
| **08** | **Paper 8: WerrSoma** | Bio-Synthetic Neuromorphic Interfacing with 158K-Neuron *Drosophila* Connectome (v1) | [**`10.5281/zenodo.22996625`**](https://doi.org/10.5281/zenodo.22996625) | [`10.5281/zenodo.22996626`](https://doi.org/10.5281/zenodo.22996626) | `arXiv:submit/8161759` • [Live 3D Portal (`werrsoma.answerr.me`)](https://werrsoma.answerr.me/) • `TR 2026/016633` | [`Lexovian/WerrSoma`](https://github.com/Lexovian/WerrSoma) • [`pCwOrM/WerrSoma`](https://github.com/pCwOrM/WerrSoma) |
| **09** | **Paper 9: WerreduR** | Procedural Pedagogy: Resolving the Saturn School Disequilibrium Paradox (v2) | [**`10.5281/zenodo.22999420`**](https://doi.org/10.5281/zenodo.22999420) | [`10.5281/zenodo.23128224`](https://doi.org/10.5281/zenodo.23128224) | [**SSRN: 7641538**](https://papers.ssrn.com/abstract=7641538) *(Distributed)* • **Lean 4 (`7 Theorems, 0 sorry`)** • [Live Portal](https://pcworm.github.io/WerreduR/) | [`jesmaat/WerreduR`](https://github.com/jesmaat/WerreduR) • [`pCwOrM/WerreduR`](https://github.com/pCwOrM/WerreduR) |
| **10** | **Paper 10: Schönhage** | Bipartite Carrier Compression in Schönhage Trilinear Multiplication Tensors (v2) | [**`10.5281/zenodo.23232541`**](https://doi.org/10.5281/zenodo.23232541) | [`10.5281/zenodo.23295370`](https://doi.org/10.5281/zenodo.23295370) | [`arXiv:2610.14263`](https://arxiv.org/abs/2610.14263) • [🤗 HF Paper](https://huggingface.co/papers/2610.14263) • [CrocSwap #226 (`50d76881`)](https://github.com/CrocSwap/integer-mult-bounds/pull/226) | [`pCwOrM/integer-mult-bounds`](https://github.com/pCwOrM/integer-mult-bounds) |
| **11** | **Paper 11: Güneş Dili** | Deterministic Morpho-Semantic Tokenization & Algebraic Morphotactics in Lean 4 (v1) | [**`10.5281/zenodo.23003711`**](https://doi.org/10.5281/zenodo.23003711) | [`10.5281/zenodo.23003712`](https://doi.org/10.5281/zenodo.23003712) | `arXiv:submit/8248674` • **Lean 4 (`4 Theorems, 0 sorry`)** • [Live Studio](https://pcworm.github.io/gunes-dili/) | [`pCwOrM/gunes-dili`](https://github.com/pCwOrM/gunes-dili) |
| **12** | **Paper 12: Niemeier A₈³** | Machine-Certified 24D Niemeier Lattice A₈³, K3 Hodge Duality & Umbral Moonshine (v1) | [**`10.5281/zenodo.23324066`**](https://doi.org/10.5281/zenodo.23324066) | [`10.5281/zenodo.23324067`](https://doi.org/10.5281/zenodo.23324067) | **Lean 4 (`0 sorry, 0 axioms`)** • `χ(X) = 24` · `order(G_glue) = 27` · `ℓ = 9` | [`pCwOrM/niemeier-a8-umbral-moonshine`](https://github.com/pCwOrM/niemeier-a8-umbral-moonshine) |
| **13** | **Paper 13: GDT v3.0** | Machine-Certified Lean 4 Formalization of the General Divisor Theorem (v2) | [**`10.5281/zenodo.23316068`**](https://doi.org/10.5281/zenodo.23316068) | [`10.5281/zenodo.23425590`](https://doi.org/10.5281/zenodo.23425590) | **Lean 4 (`81 Theorems, 0 sorry`)** • Companion v1: [`10.5281/zenodo.23426323`](https://doi.org/10.5281/zenodo.23426323) ([`v1: 23426324`](https://doi.org/10.5281/zenodo.23426324)) | [`pCwOrM/general-divisor-theorem`](https://github.com/pCwOrM/general-divisor-theorem) |
| **14** | **Paper 14: Elliptic Sieve** | Multi-Layer Algebraic Sieve & Vélu Isogeny Engine: 230 Curves on NSF ICARM (v1) | [**`10.5281/zenodo.23436282`**](https://doi.org/10.5281/zenodo.23436282) | [`10.5281/zenodo.23436283`](https://doi.org/10.5281/zenodo.23436283) | [**NSF ICARM Leaderboard (`user/114`)**](https://elliptic-rank.icarm.cloud/user/114): **30x #1 Gold Records**, 80 Top-3, 100% `log N` | [`pCwOrM/werr-elliptic-sieve`](https://github.com/pCwOrM/werr-elliptic-sieve) |
| **15** | **Paper 15: Empirical OEV** | Empirical OEV & Liquidation Dynamics: Chainlink SVR on Base & Ethereum L1 (v2) | [**`10.5281/zenodo.23623588`**](https://doi.org/10.5281/zenodo.23623588) | [`10.5281/zenodo.23642090`](https://doi.org/10.5281/zenodo.23642090) | [🤗 HF Dataset (`1.16k+ views, 126 likes`)](https://huggingface.co/datasets/pCwOrM/werracle-oev-liquidation-dataset-2026) • 94.4% Aggregate / 98.3% Median SVR Recapture | [`pCwOrM/werracle`](https://github.com/pCwOrM/werracle) • [`pCwOrM/werrealm`](https://github.com/pCwOrM/werrealm) |
| **HW** | **Edge Robotics Core** | Zero-Memory Embedded C/C++11 System-1 Reflex Kernel (`WerrCoreEdge.h` v0.5.1) | [**`10.5281/zenodo.22867425`**](https://doi.org/10.5281/zenodo.22867425) | [`10.5281/zenodo.22939253`](https://doi.org/10.5281/zenodo.22939253) | ATmega328P / ESP32 / STM32 (`0 Bytes Heap`, `<128B Stack`, `TR 2026/016633`) | [`pCwOrM/WERRobotics`](https://github.com/pCwOrM/WERRobotics) |


---

## 🏆 Global Records, Formal Proofs, Curated Awesome Merges & On-Chain Infrastructure

### 1. Certified Mathematical Records & Formal Verification (`0 sorry`)
* **🥇 NSF ICARM Elliptic Curve Rank Leaderboard ([`elliptic-rank.icarm.cloud/user/114`](https://elliptic-rank.icarm.cloud/user/114)):** **230 certified high-rank elliptic curves** (`#4308–#4537`) over $\mathbb{Q}$ with **100% complete prime conductor factorization ($\log N$)** up to Rank $\ge 19$ (`#4323`), achieving **30 First-Place (#1 Gold) Records**, **80 Podium (Top-3)**, and **418 Top-10** placements across 43 categories (building upon the foundational fibration families of Elkies, Dujella, Rubinstein, and Klagsbrun; supported under NSF Grant `DMS-2425401`).
* **🥇 Schönhage Trilinear Multiplication Tensor Bound ([`arXiv:2610.14263`](https://arxiv.org/abs/2610.14263) • [`CrocSwap/integer-mult-bounds#226`](https://github.com/CrocSwap/integer-mult-bounds/pull/226)):** Constructive 15-round bipartite carrier matching at dimensions $h=23, 25$ eliminating 185 carrier roles and **377,890 physical wires** ($W = 177,284,805 \to 176,906,915$), certifying $\kappa = 826,215,307 / 20,000,000,000,000 \approx 4.131076535 \times 10^{-5}$ ($1.377\times$ net gain over PR #49), formally incorporated into `CrocSwap/integer-mult-bounds` (`commit 50d76881`) and verified in Lean 4 (`0 sorry`).
* **📐 170+ Machine-Checked Theorems in Lean 4 (`0 sorry`, `0 unproven axioms`):**
  * **General Divisor Theorem (`GDT v3.0`):** 81 theorems/lemmas (`0 sorry`) formalizing Dan Hawkley's residue density framework ([`10.5281/zenodo.23316068`](https://doi.org/10.5281/zenodo.23316068)).
  * **Computational Group Theory (`gap-lean4-port`):** 35 theorems (`0 sorry`) formalizing Charles Sims' Schreier-Sims stabilizer chains (`GAP-0299`), backtrack ordered partitions (`GAP-0332`), and modular ring inverses (`GAP-0331`) ([`arXiv:2609.38492`](https://arxiv.org/abs/2609.38492)).
  * **Procedural Boundary Synthesis & EVM/Cairo Fixed-Point Bounds:** 40+10 theorems (`WerracleProof.lean`, `0 sorry`) verifying `ZMod 9` ($\mathbb{Z}/9\mathbb{Z}$) principal ideal closure ($\mathcal{I}_3 = \{0,3,6\}$), Q16.16 overflow safety, and unitary Page curve S-matrix conservation ([`arXiv:2609.33066`](https://arxiv.org/abs/2609.33066)).
  * **24D Niemeier Lattice $A_8^3$, WerreduR & Güneş Dili:** Complete formal specifications (`0 sorry`) across lattice unimodularity ($\chi=24, \ell=9$), horizon complementarity ($B(t)+S(t)=1$), and deterministic morphological parsing.

### 2. Curated Ecosystem Recognitions & Benchmark Evaluations
* **Merged Upstream Pull Requests:**
  * ✅ **[`wbierbower/awesome-physics#16`](https://github.com/wbierbower/awesome-physics/pull/16):** Featured in *Quantum Physics* for unitary Black Hole Page Curve simulation.
  * ✅ **[`34j/best-of-lean4#292`](https://github.com/34j/best-of-lean4/pull/292):** Indexed in the curated *Best of Lean 4* theorem proving directory.
  * ✅ **[`yh-yao/awesome-edge-ai-agents#13`](https://github.com/yh-yao/awesome-edge-ai-agents/pull/13) & [`#16`](https://github.com/yh-yao/awesome-edge-ai-agents/pull/16):** Featured for both `werr` / `answerr` and `WerreduR` edge reflex engines.
  * ✅ **[`MartinuzziFrancesco/awesome-scientific-machine-learning#9`](https://github.com/MartinuzziFrancesco/awesome-scientific-machine-learning/pull/9) & [`#10`](https://github.com/MartinuzziFrancesco/awesome-scientific-machine-learning/pull/10):** Featured under *Model Discovery*.
  * ✅ **[`meta-introspector/lean-workers-union#2`](https://github.com/meta-introspector/lean-workers-union/pull/2):** Registered verified member (`gap-lean4-port`).
  * ✅ **Jev Ecosystem & Agentic Benchmarks:** Listed on [`awesome-jev#69`](https://github.com/hellogumbo/awesome-jev/issues/69) / `madewithjev`; **100% (49/49)** on [WindTunnel WebMCP (`3.35 ms`, `0 VRAM`)](https://github.com/nekuda-ai/WindTunnel/issues/25); **100% Tool Schema Adherence (`0.38 ms`)** on [Sierra Tau-Bench](https://github.com/sierra-research/tau-bench/issues/95); **23.74** on [JevBench v1.4.1 (`7.32 ms`)](https://github.com/fstandhartinger/jevbench/issues/10); **38.0× speedup** on [Jevenator 2](https://github.com/mmastrac/jevenator2/issues/1).

### 3. Sovereign On-Chain Deployments (`Werrium / $WERR`), Multi-Chain Testnets & Grant Pipelines
* **💎 Base L2 Mainnet (`Chain ID: 8453`) — Live & BaseScan Verified:**
  * **Werrium (`$WERR`) Token Contract:** [`0xFfa2c95b68B76af00FBD84295cBA5e5268a996d2`](https://basescan.org/address/0xFfa2c95b68B76af00FBD84295cBA5e5268a996d2) *(Fixed 1,000,000,000 supply, No-Mint, EIP-2612 Gasless Permit, `burnForATP` metabolic compute quota & `burnForReflex` on-chain decision sealing • [Optimism Superchain Token List PR #1391](https://github.com/ethereum-optimism/ethereum-optimism.github.io/pull/1391))*.
  * **Gnosis Safe 2/3 Multisig Treasury:** [`0x7CC5fd367e210F4678Bcfca054cbe0F87291E355`](https://basescan.org/address/0x7CC5fd367e210F4678Bcfca054cbe0F87291E355) (`949,501,000 WERR` locked).
  * **WerrTreasuryTimelock (Vesting & Cliff):** [`0x839A6d7E726D60EA2B587e793aE36342297e8C63`](https://basescan.org/address/0x839A6d7E726D60EA2B587e793aE36342297e8C63) (`40,000,000 WERR` locked).
  * **Aerodrome Finance DEX Liquidity Pools (Base Mainnet):** [`vAMM-WERR/USDC`](https://basescan.org/address/0xdA15b610f7De7A494CD1F7f80B6B73E8b34108A5) & [`vAMM-WERR/WETH`](https://basescan.org/address/0x53D7Ff2ef9B02860bf9F476602832f75594Bfa06).
* **🌐 Multi-Chain Testnets & Grant Tracks:**
  * **Starknet Foundation Seed Grant (*In Screening*):** Cairo 2.x / Sierra `WerracleTripodZMod9` (`single felt252` seed, `~1,420 Cairo steps`, Ekubo v2 LVR extension).
  * **Ethereum Sepolia Testnet (`Chain ID: 11155111`):** `Werrium ($WERR)` at [`0xe6ecc9575B4D52642c55FCf64E8E2d3baa6e6EF7`](https://sepolia.etherscan.io/address/0xe6ecc9575B4D52642c55FCf64E8E2d3baa6e6EF7) & `Werracle` live liquidation arbitrage telemetry.
  * **NEAR Aurora Testnet (`Chain ID: 1313161555`) & Bare-Metal EVM Node (`Chain ID: 4242`):** Live `Werracle.sol` & `WerracleFeeHook.sol` deployments ([`radar.werracle.com`](https://radar.werracle.com)).
  * **Active Research Proposals:** Flashbots MEV Research ([`FRP #205`](https://github.com/flashbots/mev-research/pull/205) & [`PR #206`](https://github.com/flashbots/mev-research/pull/206)), Morpho DAO (`MIP-81` OEV Observatory), Uniswap v4 / Unichain Hook Grants.


---

## ⚖️ License & Intellectual Property

* **Software Code & Verification Modules:** Licensed under the **[Business Source License 1.1 (BSL 1.1)](./LICENSE)**.
  * **Free Academic, Educational & Research Use:** You may freely run, compile, inspect, benchmark, test, fork, and reproduce the Licensed Work for non-commercial research, academic study, and educational evaluations.
  * **Commercial Restrictions:** Production commercial deployment, hosted software-as-a-service (SaaS), paid APIs, or cloud-based decision services require an express written Commercial Enterprise License from **ITouch Bilişim Sistemleri Ltd. Şti.** ([answerr.me](https://answerr.me)).
* **Preprint & Data Telemetry:** Open-access research data licensed under **[Creative Commons Attribution 4.0 International (CC-BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**.
* **Patent Disclosure:** Procedural coordinate seed routing, boundary modulation, and zero-storage difficulty control architectures are protected under Turkish Patent and Trademark Office (TÜRKPATENT) National Priority Application No. **`TR 2026/016285`**.
