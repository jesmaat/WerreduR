# Replication on a second data set: ASSISTments 2017 (data-mining competition release;
# 1,709 students, 102 skills, 942,816 responses; skills interleaved, not mastery-based).
# Same model, same rules as for the 2009-2010 data. One fit on 80% of sequences provides
# both the parameters used for the replay and the held-out check.
suppressMessages(library(lme4)); set.seed(2026)
d <- read.csv("../data/assist2017_long.csv"); d <- d[order(d$user_id, d$skill_id, d$t), ]
d$seq <- paste(d$user_id, d$skill_id); d$opp <- ave(d$correct, d$seq, FUN = seq_along); len <- as.integer(table(d$seq))
cat(sprintf("responses %d | students %d | skills %d | sequences %d | accuracy %.3f\n", nrow(d), length(unique(d$user_id)), length(unique(d$skill_id)), length(len), mean(d$correct)))
cat("sequence length quantiles:\n"); print(quantile(len, c(.1, .25, .5, .75, .9, .95)))
f <- d[d$opp <= 15, ]; f$o <- f$opp - 1; f$lo <- log(f$opp); keep <- names(which(table(f$skill_id) >= 500)); f <- f[f$skill_id %in% keep, ]
sq <- unique(f$seq); test_seq <- sample(sq, round(0.2 * length(sq))); tr <- f[!f$seq %in% test_seq, ]; te <- f[f$seq %in% test_seq, ]
cat(sprintf("model data: %d responses, %d skills | train %d, held-out %d responses\n", nrow(f), length(keep), nrow(tr), nrow(te)))
auc <- function(p, y) { r <- rank(p); n1 <- sum(y); n0 <- sum(!y); (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0) }
out <- list(lengths = len[len >= 5])
for (form in c("linear", "log")) { v <- if (form == "linear") "o" else "lo"; t0 <- proc.time()[["elapsed"]]
  m <- glmer(as.formula(sprintf("correct ~ %s + (1 | user_id) + (1 + %s || skill_id) + (1 | seq)", v, v)), tr, binomial, nAGQ = 0, control = glmerControl(calc.derivs = FALSE))
  vc <- as.data.frame(VarCorr(m)); fe <- fixef(m); ru <- ranef(m, condVar = FALSE)
  u <- ru$user_id[as.character(te$user_id), 1]; u[is.na(u)] <- 0; sk <- ru$skill_id[as.character(te$skill_id), , drop = FALSE]
  b <- sk[, "(Intercept)"]; b[is.na(b)] <- 0; g <- sk[, v]; g[is.na(g)] <- 0
  p <- plogis((fe[["(Intercept)"]] + u + b + (fe[[v]] + g) * te[[v]]) / sqrt(1 + 0.346 * vc$vcov[vc$grp == "seq"]))
  dec <- cut(p, unique(quantile(p, 0:10 / 10)), include.lowest = TRUE); cal <- mean(abs(tapply(p, dec, mean) - tapply(te$correct, dec, mean)))
  lc <- cbind(observed = tapply(te$correct, te$opp, mean)[1:12], predicted = tapply(p, te$opp, mean)[1:12])
  par <- list(mean_rate = fe[[v]], sd_rate = vc$sdcor[grepl("skill_id", vc$grp) & vc$var1 %in% v], sd_student = vc$sdcor[vc$grp == "user_id"], sd_pair = vc$sdcor[vc$grp == "seq"],
              sd_skill = vc$sdcor[grepl("skill_id", vc$grp) & vc$var1 %in% "(Intercept)"], auc = auc(p, te$correct), calib = cal, curve_gap = mean(abs(lc[, 1] - lc[, 2])))
  out[[form]] <- par
  cat(sprintf("[%s] %.0f s | rate mean %.3f sd %.3f | student sd %.2f | pair sd %.2f | skill sd %.2f | held-out AUC %.3f | calibration error %.3f | curve gap %.3f\n",
      form, proc.time()[["elapsed"]] - t0, par$mean_rate, par$sd_rate, par$sd_student, par$sd_pair, par$sd_skill, par$auc, par$calib, par$curve_gap))
  if (form == "linear") { cat("observed vs predicted accuracy by position:\n"); print(round(t(lc), 3)) }
  rm(m); gc(); saveRDS(out, "out/learner_model_2017.rds") }
cat(sprintf("skill-mean AUC benchmark: %.3f\n", auc(tapply(tr$correct, tr$skill_id, mean)[as.character(te$skill_id)], te$correct)))
