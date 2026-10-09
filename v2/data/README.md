# Veri (pakete dahil değildir; boyut ve lisans nedeniyle)

Betikler veriyi bu klasörde şu adlarla bekler:

    git clone --depth 1 https://github.com/jhljx/GKT        # data/GKT/data/skill_builder_data.csv  (ASSISTments 2009-2010)
    git clone --depth 1 https://github.com/jakubkuzilek/oulad  # data/oulad/data/*.rda               (OULAD, R paketi)

Aynı veri setlerinin Kaggle kopyaları da kullanılabilir (nicolaswattiez/skillbuilder-data-2009-2010 ve
anlgrbz/student-demographics-online-education-dataoulad); o durumda dosya yollarını betiklerin başında düzeltin.
skill_builder_data.csv: 525.534 satır olmalıdır.

İkinci veri seti (ASSISTments 2017, Ghosh ve ark. 2020 deposundaki işlenmiş hali):
    git clone --depth 1 https://github.com/arghosh/AKT       # data/AKT/data/assist2017_pid/*
Uzun biçime çevirme: replay/06_second_dataset_fit.R'ın beklediği data/assist2017_long.csv dosyası,
assist2017_pid_{train1,valid1,test1}.csv dosyalarının (her öğrenci 4 satır: başlık, soru, beceri, yanıt)
birleştirilmesiyle elde edilir; sütunlar: user_id, t, problem_id, skill_id, correct (942.816 satır).
