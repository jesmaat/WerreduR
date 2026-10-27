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
* **Dağhan Dağlı** — Toros Science High School, MEV (Toros University), Mersin, Turkey • ORCID: [`0009-0003-2492-8313`](https://orcid.org/0009-0003-2492-8313) • SSRN: [`13656048`](https://ssrn.com/author=13656048) (`@Lexovian`)

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
* **Zerrin Dağlı** *(Corresponding Author)* — Mersin University & Yusuf Kalkavan Anatolian High School, Mersin, Turkey • ORCID: [`0000-0001-9490-6425`](https://orcid.org/0000-0001-9490-6425) • SSRN: [`13656028`](https://ssrn.com/author=13656028)  
* **Volkan Dağlı** — Anadolu University, Eskişehir, Turkey & ITouch Systems, Mersin, Turkey • ORCID: [`0009-0000-1587-8703`](https://orcid.org/0009-0000-1587-8703) • SSRN: [`13655808`](https://ssrn.com/author=13655808)  
* **Dağhan Dağlı** — Toros Science High School, MEV (Toros University), Mersin, Turkey • ORCID: [`0009-0003-2492-8313`](https://orcid.org/0009-0003-2492-8313) • SSRN: [`13656048`](https://ssrn.com/author=13656048)  

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
                    │  Procedural fractal sub-boundary escape ratios (q)   │
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
│   ├── arxiv_submission_pfp_v4.zip              # Track 2: arXiv v4.0 TeX/PNG paketi
│   └── Procedural_Fractal_Pedagogy_Seed_Paper_v1.pdf # Track 2: Kamera hazır önbaskı PDF
│
├── arxiv_pfp_v4/                                # 📄 Track 2: Açık TeX & BibTeX Kaynakları
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

## 🏛️ Associated Formal Verification & Scientific Corpus

WerreduR represents Paper 3 in the unified open-science corpus spanning fractal neural synthesis, formal verification, biophysical modeling, and decentralized reflex intelligence:

| Makale / Sütun | Başlık / Katkı | En Son Sürüm DOI | Çatı / Konsept DOI | arXiv / Doğrulama Durumu | Birincil Depo |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Paper 1: MFNS** | Mandelbrot Fractal Neural Synthesis | [`10.5281/zenodo.22867037`](https://doi.org/10.5281/zenodo.22867037) | [`10.5281/zenodo.22774934`](https://doi.org/10.5281/zenodo.22774934) | Açık Bilim Önbaskısı (Revizyonda) | [`pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis) |
| **Paper 2: OED** | Orbital Error Dynamics (OED v3) | [`10.5281/zenodo.22900465`](https://doi.org/10.5281/zenodo.22900465) | [`10.5281/zenodo.22896855`](https://doi.org/10.5281/zenodo.22896855) | [`arXiv:2609.30115`](https://arxiv.org/abs/2609.30115) • [HF Paper](https://huggingface.co/papers/2609.30115) | [`pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis) |
| **Paper 3: WerreduR** | Procedural Fractal Pedagogy (v4.0) | [`10.5281/zenodo.23128224`](https://doi.org/10.5281/zenodo.23128224) | [`10.5281/zenodo.22999420`](https://doi.org/10.5281/zenodo.22999420) | [SSRN: 7641538](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7641538) • Hedef: Q1 Learning Technologies (Hakemde) • [Canlı Simülatör](https://pcworm.github.io/WerreduR/) | [`jesmaat/WerreduR`](https://github.com/jesmaat/WerreduR) (Mirror: [`pCwOrM/WerreduR`](https://github.com/pCwOrM/WerreduR)) |
| **Paper 4: BH Page** | Black Hole Page Curve & Quantum Gravity (v5) | [`10.5281/zenodo.23072120`](https://doi.org/10.5281/zenodo.23072120) | [`10.5281/zenodo.22961999`](https://doi.org/10.5281/zenodo.22961999) | CERN Record 22978460 • Stabilizer Kodları | [`pCwOrM/fractal-neural-synthesis`](https://github.com/pCwOrM/fractal-neural-synthesis) |
| **Paper 5: Formal** | Lean 4 40-Core Gauntlet (v2) | [`10.5281/zenodo.22983889`](https://doi.org/10.5281/zenodo.22983889) | [`10.5281/zenodo.22974543`](https://doi.org/10.5281/zenodo.22974543) | [`arXiv:2609.33066`](https://arxiv.org/abs/2609.33066) • [HF Paper](https://huggingface.co/papers/2609.33066) | [`pCwOrM/werr`](https://github.com/pCwOrM/werr) & [`werracle`](https://github.com/pCwOrM/werracle) |
| **Paper 6: WerrSoma** | Drosophila Connectome (158K Nöron, v1.1) | [`10.5281/zenodo.23072929`](https://doi.org/10.5281/zenodo.23072929) | [`10.5281/zenodo.22996625`](https://doi.org/10.5281/zenodo.22996625) | `arXiv:submit/8161759` [on hold] • [3D Portal](https://werrsoma.answerr.me/) | [`Lexovian/WerrSoma`](https://github.com/Lexovian/WerrSoma) (Mirror: [`pCwOrM/WerrSoma`](https://github.com/pCwOrM/WerrSoma)) |
| **Paper 7: Werracle** | Sub-Cent Intra-Block EVM AI Oracle (v1) | [`10.5281/zenodo.22942599`](https://doi.org/10.5281/zenodo.22942599) | [`10.5281/zenodo.22942598`](https://doi.org/10.5281/zenodo.22942598) | [`arXiv:2609.30719`](https://arxiv.org/abs/2609.30719) • [HF Paper](https://huggingface.co/papers/2609.30719) | [`pCwOrM/werracle`](https://github.com/pCwOrM/werracle) & [`werralem`](https://github.com/pCwOrM/werralem) |
| **Paper 8: Schönhage**| Tensor Taşıyıcı Sıkıştırma ($W=176M$) | [`10.5281/zenodo.23268580`](https://doi.org/10.5281/zenodo.23268580) | [`10.5281/zenodo.23268579`](https://doi.org/10.5281/zenodo.23268579) | [`arXiv:2610.14263`](https://arxiv.org/abs/2610.14263) ([PDF](https://arxiv.org/pdf/2610.14263) • [DOI: `10.48550/arXiv.2610.14263`](https://doi.org/10.48550/arXiv.2610.14263) • `submit/8207241` [published]) • [CrocSwap #226 (Incorporated)](https://github.com/CrocSwap/integer-mult-bounds/pull/226) • [Contributors](https://github.com/CrocSwap/integer-mult-bounds/blob/50d768818f579d4e165b4c257c6ee25bca300802/CONTRIBUTORS.md) • [Audit `50d76881`](https://github.com/CrocSwap/integer-mult-bounds/blob/50d768818f579d4e165b4c257c6ee25bca300802/docs/research/community-reconciliation-next100-review.md) | [`pCwOrM/integer-mult-bounds`](https://github.com/pCwOrM/integer-mult-bounds) |
| **Paper 9: Güneş Dili**| Deterministik Morfoloji & 53 Koma | [`10.5281/zenodo.23273006`](https://doi.org/10.5281/zenodo.23273006) | [`10.5281/zenodo.23273005`](https://doi.org/10.5281/zenodo.23273005) | Lean 4 Doğrulanmış • [Canlı Portal](https://pcworm.github.io/gunes-dili/) | [`pCwOrM/gunes-dili`](https://github.com/pCwOrM/gunes-dili) |
| **Paper 10: GDT** | Genel Bölen Teoremi & Kalan Koşullanması | [`10.5281/zenodo.23316070`](https://doi.org/10.5281/zenodo.23316070) | [`10.5281/zenodo.23316070`](https://doi.org/10.5281/zenodo.23316070) | Lean 4 Doğrulanmış (2.287 Kontrol PASS) | [`pCwOrM/general-divisor-theorem`](https://github.com/pCwOrM/general-divisor-theorem) |
| **Paper 11: Niemeier**| 24D Niemeier $A_8^3$ & K3 Umbral Moonshine | [`10.5281/zenodo.23324066`](https://doi.org/10.5281/zenodo.23324066) | [`10.5281/zenodo.23324066`](https://doi.org/10.5281/zenodo.23324066) | Lean 4 Sertifikalı (0 sorry, 0 aksiyom) • Kayıt 23324067 | [`pCwOrM/niemeier-a8-umbral-moonshine`](https://github.com/pCwOrM/niemeier-a8-umbral-moonshine) |
| **Motor: WERR** | Zero-VRAM Gauntlet & JevBench Intake | [`10.5281/zenodo.22939253`](https://doi.org/10.5281/zenodo.22939253) | [`10.5281/zenodo.22867425`](https://doi.org/10.5281/zenodo.22867425) | [`arXiv:2609.25498`](https://arxiv.org/abs/2609.25498) • [HF Paper](https://huggingface.co/papers/2609.25498) • [HF Dataset](https://huggingface.co/datasets/pCwOrM/werr_open_decisions) | [`pCwOrM/werr`](https://github.com/pCwOrM/werr) |
| **Platform: answerr**| Reflex AI & Canlı Çalışma Alanı | Canlı: [`answerr.me`](https://answerr.me) | - | Çift Bilişsel Refleks Platformu & API | [`pCwOrM/answerr`](https://github.com/pCwOrM/answerr) |
| **Ayrık Alg** | GAP-Lean4 Biçimsel Doğrulanmış Port (35 Teorem)| [`10.5281/zenodo.23045504`](https://doi.org/10.5281/zenodo.23045504) | [`10.5281/zenodo.23045503`](https://doi.org/10.5281/zenodo.23045503) | [`arXiv:2609.38492`](https://arxiv.org/abs/2609.38492) • [HF Paper](https://huggingface.co/papers/2609.38492) | [`pCwOrM/gap-lean4-port`](https://github.com/pCwOrM/gap-lean4-port) |
| **Robotik: WERRobotics** | Sıfır-Bellek Arduino & Gömülü Edge AI Çekirdeği (`v0.5.1`) | [`10.5281/zenodo.22939253`](https://doi.org/10.5281/zenodo.22939253) | [`10.5281/zenodo.22867425`](https://doi.org/10.5281/zenodo.22867425) | ATmega328P / ESP32 / STM32 (`0 Byte Heap`, `TR 2026/016633`) | [`pCwOrM/WERRobotics`](https://github.com/pCwOrM/WERRobotics) |

---

## 📜 Citation & Open Science

### 1. Citing the Flagship Q1 Empirical Positioning Study (Under Review)
```bibtex
@article{dagli2026learninggate,
  author    = {Da{\u{g}}l{\i}, Zerrin and Da{\u{g}}l{\i}, Volkan and Da{\u{g}}l{\i}, Da{\u{g}}han},
  title     = {Where does a fractal-seeded difficulty controller stand? A simulation study against adaptive testing, staircase rules and a language model},
  journal   = {Under Peer Review},
  year      = {2026},
  note      = {Flagship Empirical Study; Replication package: \url{https://github.com/jesmaat/WerreduR}}
}
```

### 2. Citing the Foundational Seed Paper (Version 4.0 Archive)
```bibtex
@article{dagli2026pfpv4,
  author    = {Da{\u{g}}l{\i}, Zerrin and Da{\u{g}}l{\i}, Volkan and Da{\u{g}}l{\i}, Da{\u{g}}han},
  title     = {Procedural Fractal Pedagogy: Resolving the Saturn School Disequilibrium Paradox in Self-Directed {AI} Education via Zero-Storage Mandelbrot Boundary Reflexes},
  journal   = {Zenodo Open Science Archive},
  year      = {2026},
  month     = {October},
  doi       = {10.5281/zenodo.23128224},
  note      = {Version 4.0; Concept DOI: 10.5281/zenodo.22999420; \url{https://zenodo.org/records/23128224}}
}
```

---

## ⚖️ License & Intellectual Property

* **Software Code & Verification Modules:** Licensed under the **[Business Source License 1.1 (BSL 1.1)](./LICENSE)**.
  * **Free Academic, Educational & Research Use:** You may freely run, compile, inspect, benchmark, test, fork, and reproduce the Licensed Work for non-commercial research, academic study, and educational evaluations.
  * **Commercial Restrictions:** Production commercial deployment, hosted software-as-a-service (SaaS), paid APIs, or cloud-based decision services require an express written Commercial Enterprise License from **ITouch Bilişim Sistemleri Ltd. Şti.** ([answerr.me](https://answerr.me)).
* **Preprint & Data Telemetry:** Open-access research data licensed under **[Creative Commons Attribution 4.0 International (CC-BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**.
* **Patent Disclosure:** Procedural coordinate seed routing, boundary modulation, and zero-storage difficulty control architectures are protected under Turkish Patent and Trademark Office (TÜRKPATENT) National Priority Application No. **`TR 2026/016285`**.
