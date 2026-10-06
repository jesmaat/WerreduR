suppressMessages(library(lme4)); set.seed(2026)
d <- read.csv("../data/assist2017_long.csv"); d <- d[order(d$user_id, d$skill_id, d$t), ]; d$seq <- paste(d$user_id, d$skill_id); d$opp <- ave(d$correct, d$seq, FUN = seq_along)
f <- d[d$opp <= 15, ]; f$o <- f$opp - 1; keep <- names(which(table(f$skill_id) >= 500)); f <- f[f$skill_id %in% keep, ]
sq <- unique(f$seq); test_seq <- sample(sq, round(0.2 * length(sq))); tr <- f[!f$seq %in% test_seq, ]; te <- f[f$seq %in% test_seq, ]
m <- glmer(correct ~ o + (1 | user_id) + (1 + o || skill_id) + (1 | seq), tr, binomial, nAGQ = 0, control = glmerControl(calc.derivs = FALSE))
vc <- as.data.frame(VarCorr(m)); fe <- fixef(m); ru <- ranef(m, condVar = FALSE)
u <- ru$user_id[as.character(te$user_id), 1]; u[is.na(u)] <- 0; sk <- ru$skill_id[as.character(te$skill_id), , drop = FALSE]; b <- sk[, "(Intercept)"]; b[is.na(b)] <- 0; g <- sk[, "o"]; g[is.na(g)] <- 0
p <- plogis((fe[["(Intercept)"]] + u + b + (fe[["o"]] + g) * te$o) / sqrt(1 + 0.346 * vc$vcov[vc$grp == "seq"]))
auc <- function(p, y) { r <- rank(p); n1 <- as.numeric(sum(y)); n0 <- as.numeric(sum(!y)); (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0) }
cat(sprintf("ASSISTments 2017 held-out AUC, full model: %.3f | skill mean: %.3f | overall mean: 0.500\n", auc(p, te$correct), auc(tapply(tr$correct, tr$skill_id, mean)[as.character(te$skill_id)], te$correct)))
