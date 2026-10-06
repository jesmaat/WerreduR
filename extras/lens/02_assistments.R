# =============================================================================
# Study A2 -- ASSISTments 2009-2010 skill builder: is response-time fluctuation
# scale-free, and is its exponent related to performance?
# ANALYSIS PLAN (written before looking at any result)
#  Data      : skill_builder_data.csv; rows de-duplicated by order_id (the original
#              release repeats a response once per skill tag); main problems only
#              (original == 1); ordered by order_id within student.
#  Series    : log response time (ms_first_response), values <= 0 dropped, capped at
#              10 minutes. First 1,024 responses of students with at least 256.
#  Fractal   : DFA-1 exponent alpha, 10 log-spaced window sizes from 8 to N/4.
#  Controls  : (a) shuffled series (memory destroyed) -> is there structure at all?
#              (b) item-adjusted series: each problem's median log time removed, so that
#                  runs of long or short PROBLEMS are not mistaken for learner dynamics.
#  Outcome   : proportion correct. Question: is alpha related to it beyond the obvious
#              descriptors (mean and SD of log time, number of responses)?
# =============================================================================
source("common.R"); set.seed(2026)
d <- read.csv("../data/GKT/data/skill_builder_data.csv", stringsAsFactors = FALSE)
cat("rows:", nrow(d), " distinct order_id:", length(unique(d$order_id)), "\n")
d <- d[!duplicated(d$order_id) & d$original == 1 & d$ms_first_response > 0,
       c("order_id", "user_id", "problem_id", "correct", "ms_first_response", "hint_count")]
d <- d[order(d$user_id, d$order_id), ]
d$lrt <- log(pmin(d$ms_first_response, 600000))
pm <- tapply(d$lrt, d$problem_id, median); pn <- table(d$problem_id)
d$lrt_adj <- d$lrt - ifelse(pn[as.character(d$problem_id)] >= 5, pm[as.character(d$problem_id)], median(d$lrt))
n_by <- table(d$user_id); ids <- names(n_by)[n_by >= 256]
cat("responses kept:", nrow(d), " students:", length(n_by), " with >= 256 responses:", length(ids), "\n")
res <- do.call(rbind, lapply(ids, function(u) { x <- d[d$user_id == u, ]; x <- x[seq_len(min(nrow(x), 1024)), ]
  N <- nrow(x); bx <- unique(round(exp(seq(log(8), log(N / 4), length.out = 10))))
  data.frame(user = u, n = N, acc = mean(x$correct), mean_lrt = mean(x$lrt), sd_lrt = sd(x$lrt),
    alpha = dfa_alpha(x$lrt, bx), alpha_adj = dfa_alpha(x$lrt_adj, bx),
    alpha_shuf = mean(replicate(20, dfa_alpha(sample(x$lrt), bx))),
    alpha_correct = dfa_alpha(x$correct, bx), hints = mean(x$hint_count > 0)) }))
res <- res[complete.cases(res), ]
m <- function(v) sprintf("%.3f (sd %.3f)", mean(v), sd(v))
cat("alpha raw     :", m(res$alpha), "\nalpha item-adj:", m(res$alpha_adj), "\nalpha shuffled:", m(res$alpha_shuf),
    "\nalpha of the correct/incorrect series:", m(res$alpha_correct), "\n")
cat(sprintf("students above own shuffled value: raw %.1f%%, item-adjusted %.1f%%\n",
    100 * mean(res$alpha > res$alpha_shuf), 100 * mean(res$alpha_adj > res$alpha_shuf)))
tt <- t.test(res$alpha_adj - res$alpha_shuf); cat(sprintf("item-adjusted minus shuffled: %.3f [%.3f, %.3f]\n", tt$estimate, tt$conf.int[1], tt$conf.int[2]))
for (a in c("alpha", "alpha_adj")) { ct <- cor.test(res[[a]], res$acc, method = "spearman", exact = FALSE)
  cat(sprintf("Spearman %s vs accuracy: rho = %.3f, p = %.3g\n", a, ct$estimate, ct$p.value)) }
b0 <- lm(acc ~ mean_lrt + sd_lrt + log(n), res); b1 <- update(b0, . ~ . + scale(alpha_adj))
cat(sprintf("R2 baseline %.4f -> with item-adjusted alpha %.4f (gain %.4f); coefficient per SD = %.4f, p = %.3g\n",
    summary(b0)$r.squared, summary(b1)$r.squared, summary(b1)$r.squared - summary(b0)$r.squared,
    coef(b1)["scale(alpha_adj)"], summary(b1)$coefficients["scale(alpha_adj)", 4]))
cat("Spearman alpha_adj vs hint use:", round(cor(res$alpha_adj, res$hints, method = "spearman"), 3), "\n")
write.csv(res, "out/assistments_students.csv", row.names = FALSE)
