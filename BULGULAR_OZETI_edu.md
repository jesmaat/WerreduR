# Werredu / PFP — Analizler ve Kümülatif Akademik Bulgular Özeti

**Son Güncelleme:** 03.10.2026 · Hakem Denetimi (Round 3) ve Kesinleşmiş Ampirik Izgara Sonuçları.  
Bu belge, araştırmanın başlangıcından nihai dergi teslimine kadar olan 3 aşamalı kümülatif akademik gelişim seyrini, karşılaştırmalı verileri ve kesinleşmiş bulguları içerir. Tüm sayılar kod tabanındaki simülasyon betiklerinin doğrudan çıktısıdır.

---

## 1. Kümülatif Akademik Gelişim Seyri (3 Aşama)

Akademik dürüstlük ve yöntemsel şeffaflık gereğince, araştırmanın evrildiği 3 aşama kronolojik olarak muhafaza edilmiştir:

1. **Aşama 1 (Kurucu Keşif & Heuristik Karşılaştırma - 2026 Başı):**
   - Standart CAT'in motivasyonel $P^* \approx 0.70$ seviyesine ayarlandığı ilk simülasyonlar.
   - PFP-Core'un öğrenciyi $P \approx 0.50$ (Dengesizlik Koridoru) bandında CAT'e kıyasla 3 kat daha uzun tutabildiği (%29.6'ya karşı %7.5) gözlendi.
   - Bu aşama, karmaşık sistem dinamiklerinin pedagojiye aktarımı için kurucu bir hipotez teşkil etti.

2. **Aşama 2 (Psikometrik Eşitlik & Bileşen Ayrıştırması - Eylül 2026):**
   - Standart Rasch Fisher bilgisi $I = P(1-P)$ fonksiyonunun $P^*=0.50$'de maksimize olduğu gerçeğiyle yüzleşildi ve adil CAT ($P^*=0.50$) kontrol kolu eklendi.
   - Eşleştirilmiş tohum tasarımı ($N=1.000$, $T=120$) ve Mandelbrot ablasyonu (Offset kontrolü) yapıldı.
   - *Bulgu:* Mandelbrot kaçış süresi teriminin ek bir pedagojik fayda sağlamadığı, sabit bir kaydırma (offset) gibi davrandığı tespit edildi (null finding). Durağan yavaş rejimde adil CAT'in üstünlüğü belgelendi.

3. **Aşama 3 (Adil Izgara & Non-Stationarity Altında Reaktif Üstünlük - Ekim 2026):**
   - **Elo = Merdiven Özdeşliği:** $P^* = 0.50$ hedefinde Elo ($K=0.30$) algoritmasının cebirsel ve ampirik olarak adım boyu $s = K/2 = 0.15$ olan 1-yukarı/1-aşağı merdiven yöntemiyle (Kaernbach, 1991) özdeş olduğu kanıtlandı.
   - **Kestirim Gecikmesi & Adil Izgara ($s \times W \times \eta$):** Non-stationary (hızlı öğrenen, $\eta = 0.10$) rejimde statik CAT çökerken, hafızasız tek satırlık merdiven kuralının en iyi pencereli (Windowed) MAP-CAT'i dahi geride bıraktığı keşfedildi.
   - **Emniyet Bariyeri (+J):** Mandelbrot yüzeyinden bağımsız olarak, 3 ardışık hata sonrası devreye giren durum atlama (+J) kuralının maksimum engellenme/hüsran serilerini < 4.0 seviyesine kilitlediği izole edildi.

---

## 2. Adlandırma ve Model Hiyerarşisi

| Model | Algoritmik Mekanizma | Parametrik Kestirim (θ̂) | Hafıza / Pencere |
|---|---|:---:|:---:|
| **Statik MAP-CAT** | Newton-Raphson MAP (Prior: N(0,1)) + Fisher Max Info | Var | Sonsuz ($T=120$) |
| **Pencereli MAP-CAT** | Son $W$ yanıta dayalı yerel Newton-Raphson MAP | Var | Son $W \in [10, 50]$ adım |
| **Elo ($K=0.30$)** | Lojistik güncelleme: $\Delta b = K(y - 0.50) = \pm 0.15$ | Var (Dolaylı) | Adım-adım ($W=1$) |
| **Saf Merdiven ($s$)** | 1-yukarı / 1-aşağı (Kaernbach, 1991): $\Delta b = \mp s$ | Yok (Model-Free) | Hafızasız |
| **Merdiven + Emniyet (+J)** | Saf merdiven + 3 ardışık yanlışta $b \leftarrow b - 0.40$ | Yok (Model-Free) | Son 3 Yanıt |
| **PFP-Core ($\kappa = 0.44$)** | Sızıntılı merdiven: $\Delta b = \mp 0.50 - 0.44 \cdot b_t$ | Yok | Çapaya Çekim ($b_0=0$) |
| **PFP-M1 / M2** | PFP-Core + Mandelbrot kaçış yüzeyi ablasyonu | Yok | Çapa + Kaçış Süresi |

---

## 3. Aşama 1 vs. Aşama 2: Başlangıç ve Düzeltilmiş Karşılaştırma Tablosu

| Metrik | Rastgele (Satürn) | Sabit (Fabrika) | CAT ($P^*=0.70$) [Aşama 1] | CAT ($P^*=0.50$) [Aşama 2] | PFP-Core ($\kappa=0.44$) |
|---|:---:|:---:|:---:|:---:|:---:|
| **Kural 1 (Simetrik Geri Bildirim)** | | | | | |
| Dengesizlik Koridoru ($0.40 \le P \le 0.60$) | 0.128 | 0.166 | 0.075 | **0.664** | 0.296 |
| ZPD Bandı ($0.50 \le P \le 0.70$) | 0.131 | 0.197 | 0.335 | 0.410 | 0.278 |
| Hüsran / Engellenme ($P < 0.30$) | 0.375 | 0.161 | **0.002** | 0.022 | 0.223 |
| Sıkılma ($P > 0.85$) | 0.234 | 0.287 | 0.049 | 0.024 | 0.061 |
| Yetenek Kazanımı ($\Delta\theta$) | -0.032 | 0.650 | 1.078 | 0.571 | -0.022 |
| Görev-Yetenek Mesafesi ($|b - \theta|$) | 1.869 | 1.486 | 1.016 | **0.349** | 0.892 |
| **Kural 2 (Üretken Başarısızlık / Zorluk Ağırlıklı)** | | | | | |
| Dengesizlik Koridoru ($0.40 \le P \le 0.60$) | 0.134 | 0.269 | 0.102 | **0.664** | 0.366 |
| Hüsran / Engellenme ($P < 0.30$) | 0.338 | 0.074 | **0.002** | 0.022 | 0.116 |
| Yetenek Kazanımı ($\Delta\theta$) | 0.342 | 0.468 | 0.477 | **0.571** | 0.516 |
| Görev-Yetenek Mesafesi ($|b - \theta|$) | 1.682 | 0.941 | 0.944 | **0.349** | 0.687 |

*Akademik Not:* Kural 2 altında PFP-Core, parametrik yetenek kestirimi yapmaksızın Fisher-optimal CAT'in yetenek kazanımının **%90.4'üne (0.516 / 0.571)** ulaşmaktadır. Ancak $P^*=0.70$ referansı kaldırılıp doğru $P^*=0.50$ referansı konulduğunda, CAT koridor kalışında PFP-Core'un önündedir.

---

## 4. Aşama 3: Kesinleşmiş Adil Izgara (Best-vs-Best Grid)

Hakem talebi doğrultusunda, merdiven adım büyüklüğü ($s \in [0.05, 0.50]$) ile pencereli MAP-CAT pencere genişliği ($W \in [10, \infty]$) tüm öğrenme hızı rejimlerinde ($\eta \in [0.02, 0.05, 0.10]$) eşleştirilmiştir ($N=1.000$, $T=120$, 5-tohum eşleştirilmiş tasarım):

| Öğrenme Hızı Rejimi | Algoritma ve Yapılandırma | Dengesizlik Koridoru ($0.40 \le P \le 0.60$) | Yetenek Kazanımı ($\Delta\theta$) | Takip Hatası ($\|b - \theta\|$) |
|---|---|:---:|:---:|:---:|
| **Yavaş ($\eta = 0.02$)** | **Statik MAP-CAT (Teorik Tavan)** | **0.759** | **0.581** | **0.290** |
| | Pencereli MAP-CAT ($W = 30$) | 0.704 | 0.575 | 0.320 |
| | Merdiven ($s = 0.10$) | 0.722 *(MAP'in %95.1'i)* | 0.576 *(MAP'in %99.1'i)* | 0.309 |
| | Merdiven ($s = 0.15$ / Elo) | 0.667 | 0.574 | 0.345 |
| **Orta ($\eta = 0.05$)** | Statik MAP-CAT | 0.441 | 1.341 | 0.518 |
| | En İyi Pencereli MAP-CAT ($W = 30$) | 0.638 | 1.431 | 0.364 |
| | **Merdiven ($s = 0.10$)** | **0.665** | **1.431** | **0.349** |
| | Merdiven ($s = 0.15$ / Elo) | 0.661 | 1.428 | 0.350 |
| **Hızlı ($\eta = 0.10$)** | Statik MAP-CAT (Gecikmeli Çöküş) | 0.197 | 2.552 | 0.757 |
| | En İyi Pencereli MAP-CAT ($W = 20$) | 0.429 | 2.750 | 0.510 |
| | **Merdiven ($s = 0.15$ / Elo)** | **0.579** | **2.833** | **0.400** |
| | PFP-Core ($\kappa = 0.44$, Sabit Çapa Kısıtı) | 0.217 | 2.285 | 1.007 |

---

## 5. Elo ve Merdiven Algoritmik Özdeşliği

Maksimum bilgi hedefi $P^* = 0.50$ iken görev zorluğu doğrudan anlık kestirime eşitlendiğinde ($b = \hat{\theta}$):
$$\hat{\theta} - b = 0 \implies P = \frac{1}{1 + e^0} = 0.50$$
Elo güncelleme kuralı:
$$\Delta b = K \cdot (y - 0.50) = \begin{cases} +K/2 = +0.15, & y = 1 \\ -K/2 = -0.15, & y = 0 \end{cases}$$
Bu denklem, adım büyüklüğü $s = K/2 = 0.15$ olan simetrik 1-yukarı/1-aşağı merdiven yöntemiyle (Kaernbach, 1991) cebirsel olarak özdeştir. Simülasyonumuzda virgülden sonra üç basamakta özdeşlik doğrulanmıştır ($0.667$, $0.574$, $0.345$).

---

## 6. Durum Atlama (+J) Emniyet Mekanizmasının İzolasyonu

PFP mimarisinden ayrıştırılan 3 ardışık hata sonrası zorluğu 0.40 logit düşüren durum atlama (+J) kuralı test edilmiştir:

| Model Tabanı | Emniyet (+J) Durumu | Dengesizlik Koridoru | Yetenek Kazanımı | Maksimum Ardışık Hata Serisi |
|---|:---:|:---:|:---:|:---:|
| **Merdiven ($s = 0.15$)** | Yok | 0.667 | 0.574 | 5.63 |
| **Merdiven ($s = 0.15$)** | **+J Devrede** | 0.662 | 0.573 | **3.98** |
| **PFP-Core ($\kappa = 0.44$)** | Yok | 0.366 | 0.516 | 4.46 |
| **PFP-Core ($\kappa = 0.44$)** | **+J Devrede** | 0.361 | 0.514 | **3.44** |

*Sonuç:* +J kuralı, genel koridor ve kazanım başarısını zedelemeden öğrencinin peş peşe yaşadığı engellenme/hüsran kilitlenmesini 4 sorunun altına sınırlandırmaktadır.

---

## 7. Raporlanan Betikler ve Dosya Konumları

- Adil Izgara ve +J Betiği: `sim/sim_rigorous_revision_suite.py`
- Claude 3-Deney Betiği: `sim/sim_claude_3exp.py`
- Rasch Eşleştirilmiş Benchmark: `sim/rasch_fair_benchmark.py`
- Mandelbrot Ablasyon Betiği: `sim/rasch_ablation_mandelbrot.py`
- Nihai Makale Dokümanı: `CAEAI_Manuscript_Final_Submission.docx`
- Körlenmemiş Başlık Sayfası: `CAEAI_Title_Page_Author_Details.docx`
- Resmi Hakem Raporu (PDF): `CAEAI_Hakem_Elestirisi_Cozum_ve_Revizyon_Raporu.pdf`
