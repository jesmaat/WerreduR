# =============================================================================
# Study A1 -- OULAD: does the fractal scaling of early activity predict later outcome?
# ANALYSIS PLAN (written before looking at any result)
#  Unit      : student x course presentation (Kuzilek, Hlosta & Zdrahal, 2017).
#  Window    : course days 0..119. Daily series = total clicks per day (0 if none).
#  Inclusion : still registered on day 119 AND at least 20 active days in the window.
#  Series    : log(1 + clicks). PRIMARY: weekday-adjusted (student's own mean for each
#              day-of-week removed), because a 7-day rhythm distorts DFA. SENSITIVITY: raw.
#  Fractal   : DFA-1 exponent alpha, window sizes 4, 6, 8, 12, 16, 24, 30 days.
#  Outcomes  : (1) withdrawal after day 119; (2) not completing (Withdrawn or Fail).
#  Baseline  : active days, log total clicks, trend (slope of activity over the window),
#              day-to-day SD, course module. These are what any analyst would use first.
#  Question  : does alpha add predictive value BEYOND the baseline?
#              5-fold cross-validated AUC, baseline vs baseline + alpha, 20 repeats.
#  Check     : alpha of each student's shuffled series (memory destroyed) for reference.
# =============================================================================
source("common.R"); set.seed(2026)
for (f in c("student_vle", "student", "student_registration")) load(file.path("../data/oulad/data", paste0(f, ".rda")))
sv <- student_vle[student_vle$date >= 0 & student_vle$date <= 119, ]
key <- paste(sv$code_module, sv$code_presentation, sv$id_student)
agg <- aggregate(sv$sum_click, list(key = key, day = sv$date), sum)
st <- merge(student, student_registration, by = c("code_module", "code_presentation", "id_student"))
st$key <- paste(st$code_module, st$code_presentation, st$id_student)
st <- st[is.na(st$date_unregistration) | st$date_unregistration > 119, ]
M <- matrix(0, nrow(st), 120, dimnames = list(st$key, NULL))
ok <- agg$key %in% st$key; M[cbind(match(agg$key[ok], st$key), agg$day[ok] + 1)] <- agg$x[ok]
st$active <- rowSums(M > 0); keep <- st$active >= 20; st <- st[keep, ]; M <- M[keep, ]
cat("students registered at day 119:", length(keep), " with >= 20 active days:", nrow(st), "\n")
L <- log1p(M); dow <- rep(0:6, length.out = 120); bs <- c(4, 6, 8, 12, 16, 24, 30)
Ladj <- L; for (d in 0:6) Ladj[, dow == d] <- L[, dow == d] - rowMeans(L[, dow == d])
st$alpha     <- apply(Ladj, 1, dfa_alpha, boxes = bs)
st$alpha_raw <- apply(L, 1, dfa_alpha, boxes = bs)
st$alpha_shuf <- apply(Ladj, 1, function(x) dfa_alpha(sample(x), bs))
st$logclicks <- log(rowSums(M)); st$sd <- apply(L, 1, sd)
st$trend <- apply(L, 1, function(x) cov(x, 1:120) / var(1:120)) * 100
st$y_withdraw <- as.integer(st$final_result == "Withdrawn")
st$y_noncomp  <- as.integer(st$final_result %in% c("Withdrawn", "Fail"))
st <- st[is.finite(st$alpha) & is.finite(st$alpha_raw), ]
cat(sprintf("analysed: %d | withdrawn later: %d (%.1f%%) | not completing: %d (%.1f%%)\n", nrow(st),
    sum(st$y_withdraw), 100 * mean(st$y_withdraw), sum(st$y_noncomp), 100 * mean(st$y_noncomp)))
cat(sprintf("alpha: mean %.3f (sd %.3f) | shuffled: mean %.3f (sd %.3f) | raw (no weekday adj.): %.3f\n",
    mean(st$alpha), sd(st$alpha), mean(st$alpha_shuf), sd(st$alpha_shuf), mean(st$alpha_raw)))
cat(sprintf("share of students with alpha above their own shuffled value: %.1f%%\n", 100 * mean(st$alpha > st$alpha_shuf)))

cv_auc <- function(form, y, reps = 20, k = 5) { out <- numeric(reps)
  for (r in 1:reps) { fold <- sample(rep(1:k, length.out = nrow(st))); p <- numeric(nrow(st))
    for (j in 1:k) { m <- glm(form, binomial, st[fold != j, ]); p[fold == j] <- predict(m, st[fold == j, ]) }
    out[r] <- auc(p, st[[y]]) }
  out }
res <- list()
for (y in c("y_withdraw", "y_noncomp")) {
  g1 <- st$alpha[st[[y]] == 1]; g0 <- st$alpha[st[[y]] == 0]
  d <- (mean(g1) - mean(g0)) / sqrt((var(g1) + var(g0)) / 2)
  base <- as.formula(paste(y, "~ active + logclicks + trend + sd + code_module"))
  a_alone <- cv_auc(as.formula(paste(y, "~ alpha")), y)
  a_base  <- cv_auc(base, y); a_full <- cv_auc(update(base, . ~ . + alpha), y)
  a_fraw  <- cv_auc(update(base, . ~ . + alpha_raw), y)
  fit <- summary(glm(update(base, . ~ . + scale(alpha)), binomial, st))$coefficients["scale(alpha)", ]
  res[[y]] <- data.frame(outcome = y, n = nrow(st), events = sum(st[[y]]),
    alpha_event = mean(g1), alpha_nonevent = mean(g0), std_diff = d,
    auc_alpha_alone = mean(a_alone), auc_baseline = mean(a_base), auc_baseline_plus_alpha = mean(a_full),
    gain = mean(a_full - a_base), gain_lo = quantile(a_full - a_base, .025), gain_hi = quantile(a_full - a_base, .975),
    gain_rawalpha = mean(a_fraw - a_base), odds_ratio_per_sd = exp(fit[1]), p = fit[4])
}
res <- do.call(rbind, res); print(t(format(res, digits = 3)), quote = FALSE)
write.csv(res, "out/oulad_results.csv", row.names = FALSE); saveRDS(st, "out/oulad_students.rds")
cat("correlation of alpha with baseline predictors:\n"); print(round(cor(st[, c("alpha", "active", "logclicks", "trend", "sd")])[1, ], 3))
