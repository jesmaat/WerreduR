# Çalışma B: çok becerili yerleştirme ve tablo sıkıştırma (WERR/MFNS tohumu rakiplerine karşı)

    Rscript 01_skill_structure.R   # ASSISTments 2009-2010'dan 48 x 48 beceri ilişki tablosu
    Rscript 02_compress.R          # tabloyu fraktal tohum, rastgele tohum, düşük rank, nicemleme ile saklama
    Rscript 03_simulate.R          # 3.000 sentetik öğrenci, 12 beceri x 15 soru; yeni beceride başlangıç noktası

Veri: github.com/jhljx/GKT, data/skill_builder_data.csv -> ../data/GKT

Bilinmesi gerekenler
- İlişki tablosundaki 1.128 çiftin 356'sında yeterli ortak öğrenci yoktu; ortalama ile dolduruldu.
- Korelasyonlar ölçüm gürültüsü için düzeltildi (güvenirlik medyanı 0.55); düzeltme kabadır.
- "Tam tablo" kolu, öğrencileri üreten tablonun kendisini bilir (üst sınır); gerçekte tablo kestirilir.
- Başlangıç kuralı bir sezgisel kuraldır, en iyi kestirici değildir; tablo kalitesi ile sonuç
  arasındaki ilişki bu yüzden tam tekdüze değildir (1 bitlik tablo örneği).
- Fraktal tohum 24 bayt (3 x float64, MFNS'deki gibi), rastgele tohum 4 bayt sayıldı.
- Ön kayıt yapılmadı; tasarım kararları betik başlıklarında, sonuçlardan önce yazıldı.
