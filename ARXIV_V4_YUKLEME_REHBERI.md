# 🏛️ arXiv v4.0 Kamera-Hazır Yükleme ve Zenodo Eşleşme Rehberi

> **⚡ CANLI YAYIN BİLGİLERİ (Version 4.0):**
> * **Kalıcı DOI (Version 4.0):** [`10.5281/zenodo.23128224`](https://doi.org/10.5281/zenodo.23128224)
> * **Çatı DOI (Concept DOI):** [`10.5281/zenodo.22999420`](https://doi.org/10.5281/zenodo.22999420)
> * **Zenodo Kayıt Sayfası:** [https://zenodo.org/records/23128224](https://zenodo.org/records/23128224)
> * **Resmi GitHub Deposu:** [https://github.com/pCwOrM/WerreduR](https://github.com/pCwOrM/WerreduR)
> * **Canlı Simülatör (GitHub Pages):** [https://pcworm.github.io/WerreduR/](https://pcworm.github.io/WerreduR/)

Bu rehber, Zenodo'da 4 Ekim 2026 tarihinde Version 4.0 olarak yayınlanmış olan *"Procedural Fractal Pedagogy"* çalışmasının birebir eşdeğer (**"hemhâl"**) kamera-hazır paketinin **[arXiv.org](https://arxiv.org/submit)** sistemine sıfır hata ile yüklenmesi için adım adım talimatları ve kopyala-yapıştır alanlarını içerir.

---

## 📦 1. arXiv Yükleme Paketi ve Doğrulama Durumu

arXiv sistemi için üretilmiş ve test edilmiş paket:
* **Paket Konumu:** `releases/arxiv_submission_pfp_v4.zip`
* **Yedek Konum:** `legacy/zenodo_dist/arxiv_submission_pfp_v4.zip`
* **Paket Boyutu:** ~2.03 MB
* **Paket İçeriği:**
  * `main.tex` (46.2 KB — Tamamen bağımsız, UTF-8/ASCII uyumlu, standart TeX Live paketleri)
  * `references.bib` (9.1 KB — Zenodo v4.0 ve tüm companion atıflarını içeren BibTeX dosyası)
  * `figures/fig1_observer_horizon_zpd.png` (Mandelbrot ZPD Gözlemci Ufku — 300 DPI)
  * `figures/fig2_saturn_paradox_trajectories.png` (Satürn Paradoksu 4 Kollu Çözüm — 300 DPI)
  * `figures/fig3_tamame_error_kernel.png` (TAMAMe Ufuk Tamamlayıcılığı & Z/9Z İdeal Sönümleme — 300 DPI)
  * `figures/fig4_edge_latency_memory_pareto.png` (Donanım Gecikmesi & O(1) Bellek Pareto Analizi — 300 DPI)

### ✅ Ön-Doğrulama Sonuçları:
* **Kayıp Atıf (Missing Citations):** `0` (Metindeki 18 atıfın tamamı `references.bib` dosyasında mevcuttur).
* **Kayıp Referans/Etiket (Missing Refs):** `0` (Tüm denklem, tablo ve şekil etiketleri eksiksiz çözümlenmektedir).
* **Standart Olmayan Karakterler:** `0` (LaTeX motorunu çökertebilecek ham Unicode çizgiler ve matematik dışı komutlar temizlenmiştir).
* **Lean 4 Doğrulaması:** 7 çekirdek teorem, `0 sorry` aksiyomuyla makinede doğrulanmıştır (`legacy/lean4/PFP_HorizonProof.lean`).

---

## 🚀 2. arXiv.org Adım Adım Gönderim Süreci

### Adım 1: Giriş Yapın
1. [https://arxiv.org/submit](https://arxiv.org/submit) adresine gidin ve hesabınızla giriş yapın.
2. **"Start New Submission"** butonuna tıklayın.

### Adım 2: Lisans ve Anlaşma (License)
* **License:** `arXiv.org perpetual, non-exclusive license to distribute this article` (Önerilen) veya `Creative Commons Attribution 4.0 International (CC-BY 4.0)`.

### Adım 3: Dosya Yükleme (Files)
* **"Browse"** veya sürükle-bırak ile `releases/arxiv_submission_pfp_v4.zip` dosyasını seçin.
* **"Upload and Continue"** butonuna basın.
* arXiv sistemi zip dosyasını otomatik olarak açacak ve `main.tex`, `references.bib` ile `figures/` klasörünü doğrulayacaktır.

### Adım 4: Kategori Seçimi (Subject Classifications)
* **Primary Category (Ana Kategori):**
  * `cs.CY` — *Computers and Society* (AIED ve eğitim teknolojisi çalışmalarının arXiv'deki birincil evidir)
* **Cross-List Categories (Çapraz Listeleme — Görünürlüğü Maksimize Eder):**
  * `cs.AI` — *Artificial Intelligence*
  * `cs.NE` — *Neural and Evolutionary Computing*
  * `nlin.CD` — *Chaotic Dynamics*

---

## 📋 3. arXiv Üstveri (Metadata) — Kopyala-Yapıştır Alanları

Aşağıdaki alanları arXiv formuna doğrudan yapıştırabilirsiniz:

### 1. Title (Başlık):
```text
Procedural Fractal Pedagogy: Resolving the Saturn School Disequilibrium Paradox in Self-Directed AI Education via Zero-Storage Mandelbrot Boundary Reflexes
```

### 2. Authors (Yazarlar):
```text
Zerrin Dağlı, Volkan Dağlı, Dağhan Dağlı
```
*(Yazar detayları istenirse:)*
* **Zerrin Dağlı:** Mersin University & Yusuf Kalkavan Anadolu Lisesi (ORCID: `0000-0001-9490-6425`)
* **Volkan Dağlı:** Anadolu University & ITouch Systems (ORCID: `0009-0000-1587-8703`)
* **Dağhan Dağlı:** Toros Science College (ORCID: `0009-0003-2492-8313`)

### 3. DOI (Önbaskı DOI'si):
```text
10.5281/zenodo.23128224
```

### 4. Comments (Açıklama / Sayfa Sayısı Notu):
```text
6 pages, 4 figures, 2 tables. Version 4.0 camera-ready preprint. Includes Lean 4 formal verification module (PFP_HorizonProof.lean, 0 sorry axioms) and standalone unit test suite. TÜRKPATENT National Priority Application No. TR 2026/016285. GitHub: https://github.com/pCwOrM/WerreduR
```

### 5. Report Number (Opsiyonel):
```text
WERR-PFP-2026-V4
```

### 6. Abstract (Özet — Zenodo v4.0 ile Birebir Uyumlu):
```text
Background & Problem: Contemporary Intelligent Tutoring Systems (ITS) and Artificial Intelligence in Education (AIED) architectures face a dual infrastructural and pedagogical crisis. Infrastructurally, cloud-hosted Large Language Models (LLMs) and dense Deep Knowledge Tracing (DKT) networks impose severe Von Neumann memory-bandwidth bottlenecks (4–80 GB VRAM), high network latencies (>300 ms), student data privacy risks, and stochastic hallucinations. Pedagogically, systemic educational transformation frameworks grounded in chaos and complexity theory—most notably Reigeluth (2008)—posit that learner empowerment and cognitive disequilibrium are prerequisites for self-organization. However, empirical implementations of unconstrained self-directed learning consistently suffer from the Saturn School Paradox (Bennett & King, 1991; Reigeluth, 2008, p. 34): granting learners autonomous self-direction without mathematical boundary damping precipitates severe reductions in time-on-task and mastery attainment.

Method & Architecture: In this foundational paper, we introduce Procedural Fractal Pedagogy (PFP), realized via the open-source WerreduR zero-storage cognitive reflex engine. Building upon our prior frameworks on zero-storage fractal neural synthesis and Orbital Error Dynamics (OED; arXiv:2609.30115), we formalize Vygotsky’s Zone of Proximal Development (ZPD) and Reigeluth’s disequilibrium corridor as an explicit Observer Horizon Corridor anchored at sub-boundary resonance shoulder loci Xupper = (0.25, +0.18) and Xlower = (0.25, −0.18) along the boundary of the Mandelbrot set (∂M, zn+1 = zn2 + c). Rather than storing gigabyte-scale weight matrices, individualized adaptive curricula are synthesized procedurally on demand from an ultra-compact 24-byte student coordinate seed Θstudent = (cx, cy, zoom) with O(1) constant memory complexity (0 Bytes persistent VRAM). To eliminate Saturn School learner drift and interior rote stagnation simultaneously, PFP deploys a three-operator stabilization kernel: (i) an Information-Theoretic Semantic Token Damping Filter (Tdesc = 0.045) that suppresses off-task distraction spikes; (ii) a Biomimetic Perturbed Jump Operator (Ωtunneling) that deterministically tunnels learners out of non-convex cognitive deadlocks; and (iii) a Multi-Scale Harmonic Tripod evaluator (0.60×, 1.00×, 1.60×). Furthermore, refuting the classical Fallacy of Erasure in scalar grading (L → 0), we formalize student assessment as a unitary, non-dissipative error-kernel invariant (Kerror ≅ I3 = {0, 3, 6} ⊂ ℤ/9ℤ) governed by the TAMAMe Horizon Complementarity law B(t) + S(t) = 1, machine-verified in Lean 4 with zero sorry axioms.

Empirical Results: Across a 5-seed, 4-arm comparative evaluation of N = 1,000 self-directed learning trajectories (T = 120 instructional cycles), unconstrained Saturn School self-direction collapses to 11.68% ± 0.31% time-on-task retention (88.32% off-task drift), while industrial Factory-Model lockstep induces a cognitive stress firewall index of 437.84 ± 3.65 with only 18.47% ± 0.20% ZPD residence. In contrast, PFP (WerreduR) achieves 94.19% ± 0.14% time-on-task retention (+82.51 percentage points vs. the Saturn baseline, p = 4.86 × 10−11; and +5.23 percentage points over Cloud LLM Tutors at p = 2.14 × 10−5, student-level pooled Cohen’s d = 1.54), 89.24% ± 0.13% ZPD residence (d = 1.36 vs. Cloud LLMs), a 339.4× suppression in cognitive burnout stress (1.29 ± 0.00), and a median decision triage latency of 30.4 μs (134.5× faster than Cloud LLMs) with zero persistent tensor storage.
```

---

## 🔍 4. arXiv Derleme Kontrolü (View and Approve)

Dosyaları yükleyip bilgileri girdikten sonra:
1. arXiv **AutoTeX** derleyicisi çalışacaktır.
2. Üretilen PDF önizlemesini ekrandan inceleyin:
   * 4 şeklin (Figure 1, 2, 3, 4) yüksek çözünürlükte ve doğru konumlarda yer aldığını,
   * İki sütunlu akademik düzenin muntazam olduğunu,
   * Kaynakça ve denklem numaralarının eksiksiz çözüldüğünü teyit edin.
3. Her şey eksiksiz göründüğünde **"Submit"** butonuna basarak işlemi tamamlayın.
4. Gönderimden yaklaşık 24–48 saat sonra makaleniz `arXiv:2610.xxxxx` formatında kalıcı olarak yayına girecektir.

---

## 📌 5. Akademik İlişki Ağı: İki Farklı Çalışmanın Ayrımı

| Özellik | Kol 1: CANLI YAYIN (Zenodo v4.0 & arXiv) | Kol 2: DEVAM EDEN ÇALIŞMA (Q1 Makalesi) |
|---|---|---|
| **Başlık** | *Procedural Fractal Pedagogy: Resolving the Saturn School Disequilibrium Paradox...* | *Where Does a Fractal-Seeded Controller Stand? An Empirical Assessment...* |
| **Durum** | **CANLI & YAYINLANDI** (Zenodo DOI: `10.5281/zenodo.23128224`) | **GELİŞTİRME AŞAMASINDA** (Henüz hakeme gönderilmedi) |
| **Rolü** | Kurucu / Tohum Teori & Sınır Refleksleri Önbaskısı | 200.000 Öğrenci & Gerçek Veri (ASSISTments) Ampirik Konumlandırma |
| **Paket** | `releases/arxiv_submission_pfp_v4.zip` | `v2/` ve `werr/learning_gate.py` |
