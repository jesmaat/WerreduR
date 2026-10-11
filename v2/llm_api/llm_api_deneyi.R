# =============================================================================
# llm_api_deneyi.R
# Dil modelini zorluk kontrolcüsü olarak, resmi API üzerinden ve HER ÖĞRENCİ İÇİN
# AYRI SORGUYLA sınar. Öğrenciler makaledeki 200 öğrencinin aynısıdır
# (ogrenciler.csv); diğer kontrolcülerin sonuçları referans_kollar.csv içindedir.
#
# Kullanım (ayrıntı: OKU_BENI.md):
#   1) Aşağıdaki AYARLAR bölümünü düzenle
#   2) R'de:  source("llm_api_deneyi.R")
# API anahtarı bu dosyaya YAZILMAZ; ortam değişkeninden okunur.
# =============================================================================

# ------------------------------- AYARLAR -------------------------------------
SAGLAYICI <- "claude"                      # "claude", "gemini" ya da "sahte" (anahtarsız deneme)
MODEL     <- "claude-haiku-4-5-20251001"   # sağlayıcının güncel model adını yaz
N_OGRENCI <- 4                             # önce 4 ile dene; tam deney için 200
SICAKLIK  <- 0                             # 0 = en az rastgelelik
MAX_CIKTI <- 1024                          # yanıt için en çok token (düşünen modellerde 4096 yap)
BEKLEME   <- 0                             # çağrılar arası bekleme (saniye); hız sınırına takılırsan 1-2 yap
# -----------------------------------------------------------------------------

for (p in c("httr2", "jsonlite")) if (SAGLAYICI != "sahte" && !requireNamespace(p, quietly = TRUE))
  stop("Eksik paket: ", p, "  ->  install.packages('", p, "')")

ogr <- read.csv("ogrenciler.csv"); ref <- read.csv("referans_kollar.csv")
TUR <- max(ogr$tur); stopifnot(nrow(ogr) == 200 * TUR)
# N_OGRENCI kadar öğrenci: yarısı A (veriden biçimlenen), yarısı B (ani sıçrama) grubundan, sırayla
secim <- c(head(unique(ogr$ogrenci[ogr$grup == "A"]), ceiling(N_OGRENCI / 2)),
           head(unique(ogr$ogrenci[ogr$grup == "B"]), floor(N_OGRENCI / 2)))

etiket   <- gsub("[^A-Za-z0-9._-]", "_", paste(SAGLAYICI, MODEL, sep = "_"))
f_karar  <- paste0("kararlar_", etiket, ".csv")
f_ozet   <- paste0("ozet_", etiket, ".txt")

istem <- function(gecmis) paste0(
  "You are the difficulty controller of a practice system. Choose the difficulty of the NEXT problem ",
  "for one learner so that the learner's chance of answering correctly is as close to 50% as possible.\n\n",
  "Facts you may use:\n",
  "- Difficulty and ability are on the same logit scale. P(correct) = 1 / (1 + exp(-(ability - difficulty))).\n",
  "- A typical problem has difficulty 0. Abilities in the population are spread around 0 with a standard deviation of roughly 1.\n",
  "- Ability can change during a session, gradually or suddenly.\n",
  "- You never see ability. You see only past difficulties and outcomes (1 = correct, 0 = incorrect).\n\n",
  "History so far, as [difficulty, outcome] pairs in order:\n", gecmis, "\n\n",
  "Reply with only one number: the next difficulty. No other text.")

sicaklik_kullan <- TRUE      # model sıcaklık parametresini reddederse otomatik kapanır ve özete yazılır

cagri_claude <- function(metin) {
  govde <- list(model = MODEL, max_tokens = MAX_CIKTI, messages = list(list(role = "user", content = metin)))
  if (sicaklik_kullan) govde$temperature <- SICAKLIK
  r <- httr2::request("https://api.anthropic.com/v1/messages") |>
    httr2::req_headers("x-api-key" = Sys.getenv("ANTHROPIC_API_KEY"), "anthropic-version" = "2023-06-01") |>
    httr2::req_body_json(govde) |> httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_timeout(300) |> httr2::req_perform()
  j <- tryCatch(httr2::resp_body_json(r), error = function(e) list())
  list(durum = httr2::resp_status(r), hata = if (!is.null(j$error)) paste(j$error$type, j$error$message) else "",
       metin = paste(unlist(lapply(j$content, function(b) if (identical(b$type, "text")) b$text)), collapse = " "),
       girdi = if (is.null(j$usage$input_tokens)) NA else j$usage$input_tokens,
       cikti = if (is.null(j$usage$output_tokens)) NA else j$usage$output_tokens,
       model = if (is.null(j$model)) NA else j$model)
}

cagri_gemini <- function(metin) {
  cfg <- list(maxOutputTokens = MAX_CIKTI); if (sicaklik_kullan) cfg$temperature <- SICAKLIK
  r <- httr2::request(paste0("https://generativelanguage.googleapis.com/v1beta/models/", MODEL, ":generateContent")) |>
    httr2::req_headers("x-goog-api-key" = Sys.getenv("GEMINI_API_KEY")) |>
    httr2::req_body_json(list(contents = list(list(parts = list(list(text = metin)))), generationConfig = cfg)) |>
    httr2::req_error(is_error = function(resp) FALSE) |> httr2::req_timeout(300) |> httr2::req_perform()
  j <- tryCatch(httr2::resp_body_json(r), error = function(e) list())
  um <- j$usageMetadata; ek <- function(x) if (is.null(x)) 0 else x
  list(durum = httr2::resp_status(r), hata = if (!is.null(j$error)) paste(j$error$status, j$error$message) else "",
       metin = paste(unlist(lapply(j$candidates[[1]]$content$parts, function(p) p$text)), collapse = " "),
       girdi = if (is.null(um$promptTokenCount)) NA else um$promptTokenCount,
       cikti = if (is.null(um)) NA else ek(um$candidatesTokenCount) + ek(um$thoughtsTokenCount),
       model = if (is.null(j$modelVersion)) NA else j$modelVersion)
}

# Anahtarsız deneme: 0.30 adımlı merdiven gibi davranan sahte "model"
cagri_sahte <- function(metin) {
  g <- regmatches(metin, gregexpr("\\[-?[0-9.]+,[01]\\]", metin))[[1]]; son <- as.numeric(strsplit(gsub("\\[|\\]", "", tail(g, 1)), ",")[[1]])
  list(durum = 200, hata = "", metin = sprintf("%.2f", son[1] + 0.30 * (2 * son[2] - 1)), girdi = nchar(metin) %/% 4, cikti = 3, model = "sahte")
}

# Tek karar: geçici hatalarda bekleyip yeniden dener; sayı çıkmazsa bir kez daha sorar
karar <- function(gecmis) {
  metin <- istem(gecmis); fn <- switch(SAGLAYICI, claude = cagri_claude, gemini = cagri_gemini, sahte = cagri_sahte)
  sure <- 0; girdi <- 0; cikti <- 0; deneme <- 0; model <- NA; ham <- ""
  for (k in 1:8) {
    t0 <- proc.time()[["elapsed"]]; y <- tryCatch(fn(metin), error = function(e) list(durum = -1, hata = conditionMessage(e), metin = "", girdi = NA, cikti = NA, model = NA))
    gecen <- proc.time()[["elapsed"]] - t0; deneme <- deneme + 1
    if (y$durum == 400 && grepl("temperature", y$hata, ignore.case = TRUE) && sicaklik_kullan) {
      sicaklik_kullan <<- FALSE; message("Model sıcaklık ayarını kabul etmedi; ayarsız devam ediliyor."); next }
    if (y$durum %in% c(-1, 408, 429, 500, 502, 503, 504, 529)) {
      bekle <- min(120, 5 * 2^(k - 1)); message(sprintf("  geçici hata (%s %s); %d sn bekleniyor", y$durum, substr(y$hata, 1, 80), bekle)); Sys.sleep(bekle); next }
    if (y$durum != 200) stop(sprintf("API hatası %s: %s\nAyarları (anahtar, model adı, kredi) kontrol et.", y$durum, y$hata))
    sure <- sure + gecen; girdi <- girdi + ifelse(is.na(y$girdi), 0, y$girdi); cikti <- cikti + ifelse(is.na(y$cikti), 0, y$cikti); model <- y$model; ham <- y$metin
    s <- regmatches(ham, gregexpr("-?[0-9]+\\.?[0-9]*", ham))[[1]]
    if (length(s)) return(list(b = max(-6, min(6, as.numeric(tail(s, 1)))), gecerli = TRUE, sure = sure, girdi = girdi, cikti = cikti, deneme = deneme, model = model, ham = ham))
    if (k >= 2) break                                  # iki kez sayı gelmediyse vazgeç
  }
  # Hiç başarılı yanıt alınamadıysa (sunucu sürekli meşgul): kararı "geçersiz" saymak yerine dur.
  # Bu öğrenci kaydedilmez; betik yeniden çalıştırılınca baştan sorulur.
  if (is.na(model)) stop("Sunucu art arda yanıt vermedi (", y$durum, " ", substr(y$hata, 1, 100), ").\n",
                         "Deney durduruldu; tamamlanan öğrenciler kayıtlı. Bir süre sonra betiği yeniden çalıştır.")
  list(b = NA, gecerli = FALSE, sure = sure, girdi = girdi, cikti = cikti, deneme = deneme, model = model, ham = ham)
}

if (SAGLAYICI == "claude" && Sys.getenv("ANTHROPIC_API_KEY") == "") stop("ANTHROPIC_API_KEY tanımlı değil (OKU_BENI.md, adım 3).")
if (SAGLAYICI == "gemini" && Sys.getenv("GEMINI_API_KEY") == "") stop("GEMINI_API_KEY tanımlı değil (OKU_BENI.md, adım 3).")

# Kaldığı yerden devam: tamamlanmış öğrenciler atlanır
bitmis <- if (file.exists(f_karar)) { k0 <- read.csv(f_karar); as.integer(names(which(table(k0$ogrenci) == TUR))) } else integer(0)
if (file.exists(f_karar) && length(bitmis)) { k0 <- k0[k0$ogrenci %in% bitmis, ]; write.csv(k0, f_karar, row.names = FALSE) } else if (file.exists(f_karar)) file.remove(f_karar)
yapilacak <- setdiff(secim, bitmis)
cat(sprintf("Sağlayıcı: %s | model: %s | öğrenci: %d (tamamlanmış %d, kalan %d) | çağrı: yaklaşık %d\n",
            SAGLAYICI, MODEL, length(secim), length(intersect(secim, bitmis)), length(yapilacak), length(yapilacak) * (TUR - 1)))

for (i in yapilacak) {
  o <- ogr[ogr$ogrenci == i, ]; o <- o[order(o$tur), ]; b <- 0; ciftler <- character(0); satirlar <- vector("list", TUR)
  for (t in 1:TUR) {
    k <- list(b = b, gecerli = TRUE, sure = 0, girdi = 0, cikti = 0, deneme = 0, model = NA, ham = "")
    if (t > 1) { k <- karar(paste0("[", paste(ciftler, collapse = ","), "]")); if (k$gecerli) b <- k$b; if (BEKLEME > 0) Sys.sleep(BEKLEME) }   # geçersizse önceki zorluk korunur
    x <- as.integer(o$u[t] < plogis(o$theta[t] - b)); ciftler <- c(ciftler, sprintf("[%.2f,%d]", b, x))
    satirlar[[t]] <- data.frame(ogrenci = i, grup = o$grup[t], tur = t, zorluk = b, yanit = x, theta = o$theta[t], uzaklik = abs(b - o$theta[t]),
      gecerli = k$gecerli, sure_sn = k$sure, girdi_token = k$girdi, cikti_token = k$cikti, deneme = k$deneme,
      model = ifelse(is.na(k$model), "", as.character(k$model)), ham_yanit = substr(gsub("[\r\n,]+", " ", k$ham), 1, 200))
  }
  d <- do.call(rbind, satirlar)
  write.table(d, f_karar, sep = ",", row.names = FALSE, col.names = !file.exists(f_karar), append = file.exists(f_karar), qmethod = "double")
  cat(sprintf("öğrenci %3d (%s) tamam | ortalama uzaklık %.3f | karar başına %.2f sn\n", i, d$grup[1], mean(d$uzaklik), mean(d$sure_sn[-1])))
}

# ------------------------------- ÖZET ----------------------------------------
K <- read.csv(f_karar); K <- K[K$ogrenci %in% secim, ]
ga <- function(x) { m <- mean(x); if (length(x) < 2) return(sprintf("%.3f", m)); h <- qt(.975, length(x) - 1) * sd(x) / sqrt(length(x)); sprintf("%.3f [%.3f, %.3f]", m, m - h, m + h) }
fark <- function(x) { m <- mean(x); if (length(x) < 2) return(sprintf("%+.3f", m)); h <- qt(.975, length(x) - 1) * sd(x) / sqrt(length(x)); sprintf("%+.3f [%.3f, %.3f]", m, m - h, m + h) }
cagrilar <- K[K$tur > 1, ]
satir <- c(sprintf("Dil modeli API deneyi | %s | %s", SAGLAYICI, MODEL), sprintf("Tarih: %s", format(Sys.time(), "%Y-%m-%d %H:%M")),
  sprintf("API'nin bildirdiği model sürümü: %s", paste(unique(K$model[K$model != ""]), collapse = "; ")),
  sprintf("Öğrenci: %d (A: %d, B: %d) | tur: %d | öğrenci başına ayrı sorgu | sıcaklık: %s", length(unique(K$ogrenci)), length(unique(K$ogrenci[K$grup == "A"])),
          length(unique(K$ogrenci[K$grup == "B"])), TUR, if (sicaklik_kullan) SICAKLIK else "model kabul etmedi (varsayılan kullanıldı)"),
  sprintf("Karar sayısı: %d | geçersiz yanıt (önceki zorluk korundu): %d | yeniden deneme gerektiren: %d", nrow(cagrilar), sum(!cagrilar$gecerli), sum(cagrilar$deneme > 1)),
  sprintf("Karar başına süre (sn): ortalama %.3f | ortanca %.3f | %%95'lik %.3f | en uzun %.3f", mean(cagrilar$sure_sn), median(cagrilar$sure_sn), quantile(cagrilar$sure_sn, .95), max(cagrilar$sure_sn)),
  sprintf("Token: girdi toplam %d (karar başına %.0f) | çıktı toplam %d (karar başına %.0f)", sum(cagrilar$girdi_token), mean(cagrilar$girdi_token), sum(cagrilar$cikti_token), mean(cagrilar$cikti_token)), "")
for (g in c("A", "B")) { kg <- K[K$grup == g, ]; if (!nrow(kg)) next
  dm <- tapply(kg$uzaklik, kg$ogrenci, mean); ids <- as.integer(names(dm))
  satir <- c(satir, sprintf("%s (n = %d): dil modeli ortalama uzaklık %s", if (g == "A") "Veriden biçimlenen öğrenciler" else "Ani sıçrama", length(dm), ga(dm)))
  for (kol in c("Fraktal_kontrolcu", "Sakli_agirlikli_ikiz", "CAT_standart", "CAT_unutmali", "Merdiven_0.30", "Merdiven_0.50", "PEST", "PFP_Core")) {
    rk <- ref[ref$kol == kol & ref$ogrenci %in% ids, ]; rm_ <- tapply(rk$uzaklik, rk$ogrenci, mean)[as.character(ids)]
    satir <- c(satir, sprintf("   %-22s %.3f | eksi dil modeli: %s", kol, mean(rm_), fark(rm_ - dm))) }
  if (g == "B") { tur_ort <- function(d) paste(sprintf("%.2f", tapply(d$uzaklik[d$tur >= 11], d$tur[d$tur >= 11], mean)), collapse = " ")
    satir <- c(satir, paste("   Sıçramadan sonraki turlarda dil modeli:   ", tur_ort(kg)),
               paste("   Aynı turlarda fraktal kontrolcü:          ", tur_ort(ref[ref$kol == "Fraktal_kontrolcu" & ref$ogrenci %in% ids, ])),
               paste("   Aynı turlarda CAT (standart):             ", tur_ort(ref[ref$kol == "CAT_standart" & ref$ogrenci %in% ids, ]))) }
  satir <- c(satir, "") }
satir <- c(satir, "(Eksi değer: ilk yazılan kol öğrenciye dil modelinden daha yakın.)")
writeLines(satir, f_ozet); cat("\n", paste(satir, collapse = "\n"), "\n\nDosyalar: ", f_karar, ", ", f_ozet, "\n", sep = "")
