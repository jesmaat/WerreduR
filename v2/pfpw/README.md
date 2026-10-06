# PFP-W: WERR/MFNS tabanlı uyarlanabilir zorluk kontrolcüsü (R)

WERR (github.com/pCwOrM/werr, commit f80883a) fraktal çekirdeğinin R portu ve bunun üzerine
kurulu, yalnızca ikili yanıtları gören bir zorluk servosu. Theta kestirimi, madde parametresi
ve popülasyon ön bilgisi kullanılmaz.

## Çalıştırma
    Rscript tests/test_parity.R            # R ve Rcpp portu, Python WERR ile birebir mi?
    Rscript R/00_seed_search.R             # LearningGate tohumu (bir kez; ~10 dk)
    Rscript R/01_run_simulation.R 1000 120 # ana deney (~15 dk)
    Rscript R/02_report.R                  # tablolar ve şekiller -> out/
    Rscript R/03_tradeoff.R                # toparlanma hızı - hassasiyet dengesi (adım büyüklüğü taraması)
Gerekenler: R >= 4.3, Rcpp, ggplot2, C++ derleyici.
Python referansını yeniden üretmek için: python tests/export_python_reference.py <werr yolu> tests/python_reference.csv

## Dosyalar
- R/werr_kernel.R, src/werr_kernel.cpp : yama, sınır düzeltmeli 4 çeyrek, tripod füzyonu
- R/learning_gate.R : LearningGate (durum projeksiyonu, koordinat modülasyonu, MFNS nöronu, tohum araması)
- R/controllers.R   : CAT 0.5 (EAP), unutmalı CAT, merdiven/Elo, PEST tipi, saklı ağırlıklı kapı, PFP-W türevleri,
                      özgün PFP-Core ve PFP-Core+J (jesmaat/WerreduR, commit 4251db9 kodundan yeniden yazıldı)
- R/simulate.R      : senaryolar, eşli tohumlu simülasyon, ölçütler
- tests/werr_seed_swap_test.py : WERR'in kendi kararlarının tohuma bağlılığını ölçer
- out/              : sonuç tabloları (CSV), şekiller (PNG), ham sonuçlar (RDS), günlükler

## Tasarım kararları ve açıklanması gerekenler
- Kazanç nöronunun hedef tablosu öğrenci verisi içermez: P = 0.50 altında k uzunluklu dizinin
  olasılığı 2^-(k-1); hedef = max(0, 1 - 4 * 2^-(k-1)).
- Hedef tablo, 60 öğrencilik ilk denemeden sonra BİR KEZ değiştirildi (ilk hali 2'li dizilere
  aşırı tepki veriyordu). Ana deney farklı rastgele tohumlarla koşuldu.
- Adım sınırları (0.05, 0.60), rho sızıntısı (1/3) ve merdiven adımı (0.15) ayarlanmadı.
- Non-inferiority marjı (0.10 logit) yer tutucudur; ön kayıtta sabitlenmelidir.
- Madde bankası sürekli varsayılır (istenen b'de madde hep var). Sonlu banka test edilmedi.
- "Saklı ağırlıklı kapı" kontrolünün ağırlıkları MFNS aralığına ([-3, 3]) sınırlandı ve hedef
  tabloya uyduruldu; performansa göre ayarlanmış bir fraktalsız kontrol değildir.

## Kaynaklar
Kaernbach (1991) Percept. Psychophys. 49, 227-229. Levitt (1971) JASA 49, 467-477.
Pelánek (2016) Comput. Educ. 98, 169-179. Taylor & Creelman (1967) JASA 41, 782-787.
