# Sensitivity analysis: the validation shows that real gains are front-loaded (large in the
# first few problems, then flat), while the main model assumes a constant gain per problem.
# Here learning grows with the LOGARITHM of practice: logit = ... + rate_k * log(opportunity).
# (1) does this describe held-out data better?  (2) does the controller's standing change?
suppressMessages(library(lme4)); set.seed(2026)
d <- read.csv("../data/GKT/data/skill_builder_data.csv", stringsAsFactors = FALSE)
d <- d[d$original == 1 & !is.na(d$skill_id), c("order_id", "user_id", "skill_id", "correct")]
d <- d[!duplicated(d[, c("order_id", "skill_id")]), ]; d <- d[order(d$user_id, d$skill_id, d$order_id), ]
d$seq <- paste(d$user_id, d$skill_id); d$opp <- ave(d$correct, d$seq, FUN = seq_along)
f <- d[d$opp <= 15, ]; f$lo <- log(f$opp); keep <- names(which(table(f$skill_id) >= 500)); f <- f[f$skill_id %in% keep, ]
sq <- unique(f$seq); test_seq <- sample(sq, round(0.2 * length(sq))); tr <- f[!f$seq %in% test_seq, ]; te <- f[f$seq %in% test_seq, ]
m <- glmer(correct ~ lo + (1 | user_id) + (1 + lo || skill_id) + (1 | seq), tr, binomial, nAGQ = 0, control = glmerControl(calc.derivs = FALSE))
vc <- as.data.frame(VarCorr(m)); fe <- fixef(m); ru <- ranef(m, condVar = FALSE)
u <- ru$user_id[as.character(te$user_id), 1]; u[is.na(u)] <- 0; sk <- ru$skill_id[as.character(te$skill_id), , drop = FALSE]
b <- sk[, "(Intercept)"]; b[is.na(b)] <- 0; g <- sk[, "lo"]; g[is.na(g)] <- 0
p <- plogis((fe[["(Intercept)"]] + u + b + (fe[["lo"]] + g) * te$lo) / sqrt(1 + 0.346 * vc$vcov[vc$grp == "seq"]))
auc <- function(p, y) { r <- rank(p); n1 <- sum(y); n0 <- sum(!y); (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0) }
pp <- pmin(pmax(p, 1e-6), 1 - 1e-6)
cat(sprintf("held-out: AUC %.3f | log loss %.4f | Brier %.4f\n", auc(p, te$correct), -mean(te$correct * log(pp) + (1 - te$correct) * log(1 - pp)), mean((p - te$correct)^2)))
lc <- data.frame(position = 1:12, observed = tapply(te$correct, te$opp, mean)[1:12], log_model = tapply(p, te$opp, mean)[1:12]); print(round(lc, 3), row.names = FALSE)
cat(sprintf("mean absolute gap observed vs predicted over positions 1-12: %.3f\n", mean(abs(lc$observed - lc$log_model))))
par <- list(mean_rate = fe[["lo"]], sd_rate = vc$sdcor[grepl("skill_id", vc$grp) & vc$var1 %in% "lo"], sd_student = vc$sdcor[vc$grp == "user_id"], sd_pair = vc$sdcor[vc$grp == "seq"])
cat(sprintf("log-learning rate: mean %.3f, sd %.3f | student sd %.2f | student-by-skill sd %.2f\n", par$mean_rate, par$sd_rate, par$sd_student, par$sd_pair))
cat(sprintf("implied gain: problems 1-5 %.2f logits, problems 5-10 %.2f, problems 10-20 %.2f\n", par$mean_rate * log(5), par$mean_rate * log(2), par$mean_rate * log(2)))
saveRDS(par, "out/learner_model_log.rds"); write.csv(lc, "out/validation_learning_curve_log.csv", row.names = FALSE)
