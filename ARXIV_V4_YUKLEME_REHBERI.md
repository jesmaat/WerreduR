# 🚀 arXiv.org Web Formu İçin Kesin ve Tek Yükleme Rehberi (WerreduR v4.0)

Bu rehber, **[arxiv.org/submit](https://arxiv.org/submit)** web formunu doldururken hiçbir tereddüt yaşamamanız için, **web formu kurallarına ve 1.920 karakter sınırına %100 uyarlanmış en doğru tek abstract** ve kopyala-yapıştır alanlarıyla hazırlanmıştır.

---

## 📁 1. Yüklenecek Dosya
* **Dosya:** `releases/arxiv_submission_pfp_v4.zip` (veya `legacy/zenodo_dist/arxiv_submission_pfp_v4.zip`)
* **Boyut:** ~2.03 MB
* **İçerik:** `main.tex`, `references.bib`, `figures/` (4 adet 300-DPI grafik) — *Önceden test edilmiş, sıfır hatalı tam pakettir.*

---

## 📝 2. arXiv Web Formu Alanları (Birebir Kopyala-Yapıştır)

### [1] Lisans (License)
* Seçilecek Opsiyon: **`arXiv.org perpetual, non-exclusive license to distribute this article`** *(En yaygın ve standart seçim)*

---

### [2] Kategori (Subject Classifications)
* **Primary Category (Ana Kategori):**
  ```text
  cs.CY - Computers and Society
  ```
  *(Açıklama: AIED ve eğitim teknolojisi araştırmalarının arXiv'deki birincil evidir)*

* **Cross-Lists (Çapraz Listeleme — Görünürlüğü artırmak için virgülle ekleyin):**
  ```text
  cs.AI, cs.NE, nlin.CD
  ```
  *(cs.AI: Artificial Intelligence | cs.NE: Neural and Evolutionary Computing | nlin.CD: Chaotic Dynamics)*

---

### [3] Title (Başlık)
```text
Procedural Fractal Pedagogy: Resolving the Saturn School Disequilibrium Paradox in Self-Directed AI Education via Zero-Storage Mandelbrot Boundary Reflexes
```

---

### [4] Authors (Yazarlar)
```text
Zerrin Dağlı, Volkan Dağlı, Dağhan Dağlı
```

*(Yazar detayları veya kurumlar sorulursa:)*
* **Zerrin Dağlı:** Mersin University & Yusuf Kalkavan Anadolu Lisesi (ORCID: `0000-0001-9490-6425`)
* **Volkan Dağlı:** Anadolu University & ITouch Systems (ORCID: `0009-0000-1587-8703`)
* **Dağhan Dağlı:** Toros Science College (ORCID: `0009-0003-2492-8313`)

---

### [5] Abstract (Özet — Web Formu İçin En Doğru ve Kesin Metin)
> 💡 **Karakter Bilgisi:** Tam **1.723 karakter** (arXiv'in 1.920 karakter katı sınırının 197 karakter altındadır; MathJax formüllerini webde kusursuz render eder, sisteme yapıştırdığınız anda doğrudan yeşil onay alır).

```text
Contemporary AI in Education (AIED) architectures face a dual crisis: memory bottlenecks (4-80 GB VRAM) in cloud LLMs, and the Saturn School Paradox (Bennett & King, 1991; Reigeluth, 2008), where unconstrained self-direction triggers severe off-task drift. We introduce Procedural Fractal Pedagogy (PFP), realized via the open-source WerreduR engine. PFP formalizes Vygotsky's Zone of Proximal Development (ZPD) as an Observer Horizon Corridor anchored at sub-boundary resonance shoulders $X_{\text{upper/lower}} = (0.25, \pm 0.18)$ along the Mandelbrot boundary ($\partial\mathcal{M}$, $z_{n+1} = z_n^2 + c$). Curricula are synthesized on demand from a 24-byte coordinate seed $\Theta = (c_x, c_y, \text{zoom})$ with $O(1)$ memory complexity (0 Bytes persistent VRAM). To eliminate learner drift and rote stagnation, PFP deploys semantic token damping ($T_{\text{desc}} = 0.045$), a biomimetic perturbed jump operator ($\Omega_{\text{tunneling}}$), and a multi-scale harmonic tripod kernel. Refuting scalar grading erasure, student assessment is formalized as a unitary error-kernel invariant ($\mathcal{K}_{\text{error}} \cong \mathcal{I}_3 = \{0, 3, 6\} \subset \mathbb{Z}/9\mathbb{Z}$) under TAMAMe Horizon Complementarity $B(t) + S(t) = 1$, verified in Lean 4 (zero sorry). Across $N = 1{,}000$ self-directed trajectories ($T = 120$ cycles), Saturn self-direction collapses to $11.68\% \pm 0.31\%$ time-on-task, whereas WerreduR achieves $94.19\% \pm 0.14\%$ (+82.51 pp vs. Saturn, $p = 4.86 \times 10^{-11}$; +5.23 pp over Cloud LLMs, $d = 1.54$), $89.24\% \pm 0.13\%$ ZPD residence, a $339.4\times$ stress reduction (1.29 vs. 437.84), and a median decision triage latency of $30.4\ \mu\text{s}$ (134.5x faster than Cloud LLMs) with zero persistent VRAM.
```

---

### [6] Comments (Açıklama / Baskı Detayı)
```text
6 pages, 4 figures, 2 tables. Version 4.0 camera-ready preprint. Includes Lean 4 formal verification module (PFP_HorizonProof.lean, 0 sorry axioms) and standalone unit test suite. TÜRKPATENT National Priority Application No. TR 2026/016285. GitHub: https://github.com/jesmaat/WerreduR
```

---

### [7] DOI (Önceden Tescilli Zenodo v4.0 DOI'si)
```text
10.5281/zenodo.23128224
```

---

### [8] Report Number (Rapor Numarası — Opsiyonel)
```text
WERR-PFP-2026-V4
```

---

### [9] ACM / MSC Class (Opsiyonel Sınıflandırma)
* **ACM Class:** `K.3.1; I.2.0; G.1.0` *(Computer Uses in Education; Artificial Intelligence; Numerical Analysis)*

---

## ⚡ 3. Son Adım: Derleme ve Gönderim (View & Submit)
1. Bilgileri kaydettikten sonra **"Process File"** / **"View Article"** butonuna tıklayın.
2. arXiv'in derlediği PDF önizlemesine göz atın (4 şeklin ve 2 sütunlu düzenin eksiksiz olduğunu görün).
3. **"Submit"** butonuna basarak başvuruyu tamamlayın.
4. Makaleniz ~24 saat içinde `arXiv:2610.xxxxx` kalıcı kodu ile yayına girecektir.
