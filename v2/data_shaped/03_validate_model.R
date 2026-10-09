# =============================================================================
# Does the fitted learner model describe responses it has not seen?
# Hold out 20% of student-skill sequences at random, fit the model of Section 3.2.3 on
# the other 80%, and predict every held-out response from: the student's overall level
# (learned from that student's OTHER skills), the skill's difficulty, the skill's
# learning rate and the position in the sequence. The student-by-skill deviation of a
# held-out sequence is unknown and set to its mean, with the usual logistic-normal
# correction so that predictions stay calibrated.
# Benchmarks: overall mean; skill mean; the same model without a learning rate.
# =============================================================================
suppressMessages(library(lme4)); set.seed(2026)
d <- read.csv("../data/GKT/data/skill_builder_data.csv", stringsAsFactors = FALSE)
d <- d[d$original == 1 & !is.na(d$skill_id), c("order_id", "user_id", "skill_id", "correct")]
d <- d[!duplicated(d[, c("order_id", "skill_id")]), ]; d <- d[order(d$user_id, d$skill_id, d$order_id), ]
d$seq <- paste(d$user_id, d$skill_id); d$opp <- ave(d$correct, d$seq, FUN = seq_along)
f <- d[d$opp <= 15, ]; f$o <- f$opp - 1; keep <- names(which(table(f$skill_id) >= 500)); f <- f[f$skill_id %in% keep, ]
sq <- unique(f$seq); test_seq <- sample(sq, round(0.2 * length(sq))); tr <- f[!f$seq %in% test_seq, ]; te <- f[f$seq %in% test_seq, ]
cat(sprintf("train: %d responses, %d sequences | test: %d responses, %d sequences\n", nrow(tr), length(unique(tr$seq)), nrow(te), length(test_seq)))
fit <- function(form) glmer(form, tr, binomial, nAGQ = 0, control = glmerControl(calc.derivs = FALSE))
pred <- function(m, slope) { vc <- as.data.frame(VarCorr(m)); fe <- fixef(m)
  ru <- ranef(m, condVar = FALSE); u <- ru$user_id[as.character(te$user_id), 1]; u[is.na(u)] <- 0
  sk <- ru$skill_id[as.character(te$skill_id), , drop = FALSE]; b <- sk[, "(Intercept)"]; b[is.na(b)] <- 0
  g <- if (slope) { x <- sk[, "o"]; x[is.na(x)] <- 0; fe[["o"]] + x } else 0
  eta <- fe[["(Intercept)"]] + u + b + g * te$o
  s2 <- vc$vcov[vc$grp == "seq"]; plogis(eta / sqrt(1 + 0.346 * s2)) }
m1 <- fit(correct ~ o + (1 | user_id) + (1 + o || skill_id) + (1 | seq)); p1 <- pred(m1, TRUE); rm(m1); gc()
m0 <- fit(correct ~ 1 + (1 | user_id) + (1 | skill_id) + (1 | seq)); p0 <- pred(m0, FALSE); rm(m0); gc()
pg <- rep(mean(tr$correct), nrow(te)); ps <- tapply(tr$correct, tr$skill_id, mean)[as.character(te$skill_id)]
auc <- function(p, y) { r <- rank(p); n1 <- sum(y); n0 <- sum(!y); (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0) }
ll <- function(p, y) { p <- pmin(pmax(p, 1e-6), 1 - 1e-6); -mean(y * log(p) + (1 - y) * log(1 - p)) }
res <- data.frame(model = c("Overall mean", "Skill mean", "Model without learning rate", "Full model (used in the study)"),
  AUC = sapply(list(pg, ps, p0, p1), auc, y = te$correct), log_loss = sapply(list(pg, ps, p0, p1), ll, y = te$correct),
  Brier = sapply(list(pg, ps, p0, p1), function(p) mean((p - te$correct)^2)), accuracy = sapply(list(pg, ps, p0, p1), function(p) mean((p > .5) == te$correct)))
print(format(res, digits = 3), row.names = FALSE)
cat("\ncalibration by predicted probability (full model): predicted vs observed share correct\n")
dec <- cut(p1, quantile(p1, 0:10 / 10), include.lowest = TRUE); cal <- data.frame(predicted = tapply(p1, dec, mean), observed = tapply(te$correct, dec, mean), n = as.integer(table(dec)))
print(round(cal, 3), row.names = FALSE); cat(sprintf("mean absolute calibration error over deciles: %.3f\n", mean(abs(cal$predicted - cal$observed))))
cat("\nlearning curve on held-out sequences: observed vs predicted share correct by position\n")
lc <- data.frame(position = 1:12, observed = tapply(te$correct, te$opp, mean)[1:12], full_model = tapply(p1, te$opp, mean)[1:12], no_learning = tapply(p0, te$opp, mean)[1:12], n = as.integer(table(te$opp))[1:12])
print(round(lc, 3), row.names = FALSE)
write.csv(res, "out/validation_metrics.csv", row.names = FALSE); write.csv(cal, "out/validation_calibration.csv", row.names = FALSE); write.csv(lc, "out/validation_learning_curve.csv", row.names = FALSE)
