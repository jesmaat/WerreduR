# Fraktal mercek: gerçek öğrenci verisinde ölçekten bağımsız dalgalanma (Çalışma A)

Soru: Öğrenci davranışındaki dalgalanmalar fraktal benzeri mi, ve bu özellik sonucu öngörüyor mu?

    Rscript 01_oulad.R                  # OULAD: erken etkinlik -> sonraki bırakma / tamamlamama
    Rscript 02_assistments.R            # ASSISTments 2009-2010: yanıt süresi -> doğruluk
    Rscript 03_assistments_controls.R   # fraktalsız eş (lag-1 otokorelasyon, AR(1) ikizi)

Veri (Kaggle bu ortamdan erişilemedi; aynı veri setleri GitHub kopyalarından alındı):
- OULAD: github.com/jakubkuzilek/oulad (veri setinin ilk yazarının R paketi) -> ../data/oulad
- ASSISTments skill builder 2009-2010: github.com/jhljx/GKT, data/skill_builder_data.csv
  (525.534 satır; order_id'ye göre tekilleştirilince 346.860) -> ../data/GKT

Yöntem: DFA-1 (Peng ve ark., 1994). alpha = 0.5 belleksiz; 1.0 "1/f"; 1.5 rastgele yürüyüş.
Kestirici, üstelleri bilinen yapay serilerle doğrulandı (common.R). Her betiğin başında,
sonuçlara bakılmadan önce yazılmış analiz planı var. Ön kayıt yapılmadı.
