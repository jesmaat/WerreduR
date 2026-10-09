# Çalışma 1'in gerçek veriden biçimlenen öğrencilerle yeniden koşturulması

    Rscript 01_fit_learner_model.R   # ASSISTments 2009-2010'a karma lojistik model (~3 dk, lme4 gerekir)
    Rscript 02_replay.R              # ../pfpw kontrolcüleri, 4.000 oturum

Gerekenler: ../pfpw (kontrolcüler ve tohum), ../data/GKT/data/skill_builder_data.csv
Sınırlar: öğrenme hızı sonuçtan bağımsız her soruya uygulanır; ustalık temelli sistemde başarılı
öğrenciler diziyi erken bıraktığı için yalnızca ilk 15 soru kullanıldı; beceri zorluğu bilinen kabul edildi.
