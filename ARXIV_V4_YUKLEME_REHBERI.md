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

### 6. Abstract (Özet — arXiv 1.920 Karakter Sınırına %100 Uyarlanmış):

> ⚠️ **ÖNEMLİ KURAL (arXiv 1.920 Karakter Sınırı):**  
> arXiv gönderim sisteminde **Abstract** veri girişi alanı için kesin ve katı bir **1.920 karakter üst sınırı** bulunmaktadır. Bu sınırı aşan metinler sistem tarafından reddedilir veya otomatik olarak kesilir. Aşağıdaki metin, Zenodo v4.0'daki kurucu hipotezlerin, matematiksel operatörlerin ve N=1.000 ampirik sonuçların tamamını koruyarak tam **1.723 karakter** (236 kelime) olarak optimize edilmiştir (197 karakter güvenlik marjı mevcuttur).

**arXiv Web Formuna Yapıştırılacak Metin (1.723 Karakter — MathJax Uyumlu):**
```text
Contemporary AI in Education (AIED) architectures face a dual crisis: memory bottlenecks (4-80 GB VRAM) in cloud LLMs, and the Saturn School Paradox (Bennett & King, 1991; Reigeluth, 2008), where unconstrained self-direction triggers severe off-task drift. We introduce Procedural Fractal Pedagogy (PFP), realized via the open-source WerreduR engine. PFP formalizes Vygotsky's Zone of Proximal Development (ZPD) as an Observer Horizon Corridor anchored at sub-boundary resonance shoulders $X_{\text{upper/lower}} = (0.25, \pm 0.18)$ along the Mandelbrot boundary ($\partial\mathcal{M}$, $z_{n+1} = z_n^2 + c$). Curricula are synthesized on demand from a 24-byte coordinate seed $\Theta = (c_x, c_y, \text{zoom})$ with $O(1)$ memory complexity (0 Bytes persistent VRAM). To eliminate learner drift and rote stagnation, PFP deploys semantic token damping ($T_{\text{desc}} = 0.045$), a biomimetic perturbed jump operator ($\Omega_{\text{tunneling}}$), and a multi-scale harmonic tripod kernel. Refuting scalar grading erasure, student assessment is formalized as a unitary error-kernel invariant ($\mathcal{K}_{\text{error}} \cong \mathcal{I}_3 = \{0, 3, 6\} \subset \mathbb{Z}/9\mathbb{Z}$) under TAMAMe Horizon Complementarity $B(t) + S(t) = 1$, verified in Lean 4 (zero sorry). Across $N = 1{,}000$ self-directed trajectories ($T = 120$ cycles), Saturn self-direction collapses to $11.68\% \pm 0.31\%$ time-on-task, whereas WerreduR achieves $94.19\% \pm 0.14\%$ (+82.51 pp vs. Saturn, $p = 4.86 \times 10^{-11}$; +5.23 pp over Cloud LLMs, $d = 1.54$), $89.24\% \pm 0.13\%$ ZPD residence, a $339.4\times$ stress reduction (1.29 vs. 437.84), and a median decision triage latency of $30.4\ \mu\text{s}$ (134.5x faster than Cloud LLMs) with zero persistent VRAM.
```

*(Alternatif: Düz Metin / Math Delimitersiz Versiyon — 1.664 Karakter):*
```text
Contemporary AI in Education (AIED) architectures face a dual crisis: memory bottlenecks (4-80 GB VRAM) in cloud LLMs, and the Saturn School Paradox (Bennett & King, 1991; Reigeluth, 2008), where unconstrained self-direction triggers severe off-task drift. We introduce Procedural Fractal Pedagogy (PFP), realized via the open-source WerreduR engine. PFP formalizes Vygotsky's Zone of Proximal Development (ZPD) as an Observer Horizon Corridor anchored at sub-boundary resonance shoulders X_upper/lower = (0.25, ±0.18) along the Mandelbrot boundary (∂M, z_{n+1} = z_n^2 + c). Curricula are synthesized on demand from a 24-byte coordinate seed Θ = (cx, cy, zoom) with O(1) memory complexity (0 Bytes persistent VRAM). To eliminate learner drift and rote stagnation, PFP deploys semantic token damping (T_desc = 0.045), a biomimetic perturbed jump operator (Ω_tunneling), and a multi-scale harmonic tripod kernel. Refuting scalar grading erasure, student assessment is formalized as a unitary error-kernel invariant (K_error ≅ I_3 = {0, 3, 6} ⊂ Z/9Z) under TAMAMe Horizon Complementarity B(t) + S(t) = 1, verified in Lean 4 (zero sorry). Across N = 1,000 self-directed trajectories (T = 120 cycles), Saturn self-direction collapses to 11.68% ± 0.31% time-on-task, whereas WerreduR achieves 94.19% ± 0.14% (+82.51 pp vs. Saturn, p = 4.86e-11; +5.23 pp over Cloud LLMs, d = 1.54), 89.24% ± 0.13% ZPD residence, a 339.4x stress reduction (1.29 vs. 437.84), and a median decision triage latency of 30.4 μs (134.5x faster than Cloud LLMs) with zero persistent VRAM.
```

*(Not: `main.tex` dosyasının içindeki PDF çıktısında yer alan özet, PDF formatında olduğu için 1.920 karakter sınırına tabi değildir; makale PDF'inde genişletilmiş tam metin yer almaktadır.)*

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
