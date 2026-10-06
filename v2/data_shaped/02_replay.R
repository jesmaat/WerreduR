# =============================================================================
# Study 1 replay, step 2 -- the Study 1 controllers on learners shaped by real data.
# Everything about the learners comes from out/learner_model.rds (ASSISTments fit):
#   * session length: resampled from real sequences of 5 or more problems (capped at 60)
#   * starting distance from the skill's average difficulty:
#       "student unknown": N(0, sqrt(sd_student^2 + sd_pair^2))  (system knows only the skill)
#       "student known"  : N(0, sd_pair)        (system already knows the student's overall level)
#   * learning: ability rises by rate per problem, rate ~ N(mean_rate, sd_rate) per sequence
# Responses follow the Rasch model. Every controller starts at the skill's average
# difficulty (b = 0) and sees only right/wrong. Common random numbers across arms.
# =============================================================================
setwd("../pfpw"); source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); ss <- readRDS("out/seed_search.rds"); setwd("../replay")
L <- readRDS("out/learner_model.rds"); set.seed(2026); N <- 4000L
sd_unknown <- sqrt(L$sd_student^2 + L$sd_pair^2)
ARMS <- list(
  "Adaptive test (standard prior)"   = make_cat(),
  "Adaptive test (prior matched to data)" = NULL,                       # filled per condition
  "Adaptive test, forgetting"        = make_cat(discount = 0.95),
  "Fixed staircase, step 0.15"       = make_staircase(0.15),
  "Fixed staircase, step 0.30"       = make_staircase(0.30),
  "Fixed staircase, step 0.50"       = make_staircase(0.50),
  "PEST-type staircase"              = make_pest(),
  "Stored-weight twin"               = make_gate_servo(mode = "explicit", w_explicit = ss$ex_bounded),
  "LearningGate (fractal)"           = make_gate_servo(ss$res$seed, "werr"),
  "Original PFP-Core"                = make_pfp_core(FALSE))
run <- function(ctl, th0, rate, len, U) { out <- matrix(NA_real_, length(th0), 3)
  for (i in seq_along(th0)) { th <- th0[i]; s <- ctl$init(); e <- 0; cor <- 0; e5 <- 0
    for (t in seq_len(len[i])) { b <- ctl$b(s); p <- plogis(th - b); e <- e + abs(b - th); cor <- cor + (p >= .4 & p <= .6)
      if (t > len[i] - 3) e5 <- e5 + abs(b - th)
      s <- ctl$update(s, as.integer(U[i, t] < p)); th <- th + rate[i] }
    out[i, ] <- c(e / len[i], cor / len[i], e5 / 3) }
  out }
len <- pmin(sample(L$lengths, N, TRUE), 60L); rate <- rnorm(N, L$mean_rate, L$sd_rate); z <- rnorm(N); U <- matrix(runif(N * 60), N, 60)
cat(sprintf("sessions: %d | length median %d, mean %.1f | learning per problem mean %.3f | total gain per session median %.2f logits\n",
    N, median(len), mean(len), mean(rate), median(rate * len)))
res <- list(); tab <- NULL
for (cond in c("student unknown", "student known")) { sd0 <- if (cond == "student unknown") sd_unknown else L$sd_pair
  ARMS[["Adaptive test (prior matched to data)"]] <- make_cat(prior_sd = sd0)
  for (a in names(ARMS)) { r <- run(ARMS[[a]], z * sd0, rate, len, U); res[[cond]][[a]] <- r
    h <- 1.96 * sd(r[, 1]) / sqrt(N)
    tab <- rbind(tab, data.frame(condition = cond, start_sd = round(sd0, 2), controller = a, distance = mean(r[, 1]), lo = mean(r[, 1]) - h, hi = mean(r[, 1]) + h,
      distance_weighted_by_problems = sum(r[, 1] * len) / sum(len), near_target_share = mean(r[, 2]), distance_last3 = mean(r[, 3]))) } }
print(format(tab[, -2], digits = 3), row.names = FALSE)
cat("\npaired differences in distance, 'student unknown' (negative = first is better):\n")
pd <- function(a, b, cond = "student unknown") { x <- res[[cond]][[a]][, 1] - res[[cond]][[b]][, 1]; h <- 1.96 * sd(x) / sqrt(N); sprintf("%.3f [%.3f, %.3f]", mean(x), mean(x) - h, mean(x) + h) }
for (p in list(c("Fixed staircase, step 0.30", "Adaptive test (standard prior)"), c("Fixed staircase, step 0.30", "Adaptive test (prior matched to data)"),
               c("Fixed staircase, step 0.30", "Adaptive test, forgetting"), c("LearningGate (fractal)", "Adaptive test (prior matched to data)"),
               c("LearningGate (fractal)", "Stored-weight twin"), c("LearningGate (fractal)", "Fixed staircase, step 0.30"), c("PEST-type staircase", "Fixed staircase, step 0.30")))
  cat(sprintf("  %-28s vs %-40s %s | known: %s\n", p[1], p[2], pd(p[1], p[2]), pd(p[1], p[2], "student known")))
# by session length: where does each approach win?
cat("\ndistance by session length, 'student unknown':\n"); g <- cut(len, c(4, 7, 12, 20, 60), labels = c("5-7", "8-12", "13-20", "21-60"))
print(round(sapply(c("Adaptive test (prior matched to data)", "Adaptive test, forgetting", "Fixed staircase, step 0.30", "LearningGate (fractal)"),
  function(a) tapply(res[["student unknown"]][[a]][, 1], g, mean)), 3)); print(table(g))
write.csv(tab, "out/table_replay.csv", row.names = FALSE); saveRDS(res, "out/replay.rds")
suppressMessages(library(ggplot2)); tab$family <- ifelse(grepl("Adaptive test", tab$controller), "Estimates ability", ifelse(grepl("fractal", tab$controller), "Fractal gate", ifelse(grepl("PFP-Core", tab$controller), "Original PFP-Core", "Estimation-free")))
tab$controller <- factor(tab$controller, rev(names(ARMS))); tab$condition <- factor(tab$condition, c("student unknown", "student known"))
p <- ggplot(tab, aes(distance, controller, colour = family)) + geom_errorbarh(aes(xmin = lo, xmax = hi), height = .25) + geom_point(size = 2.4) + facet_wrap(~condition) +
  scale_colour_manual(values = c("Estimates ability" = "#1b6ca8", "Fractal gate" = "#c0392b", "Estimation-free" = "#555555", "Original PFP-Core" = "#e08e0b")) +
  labs(x = "Mean distance between task difficulty and ability (logits; lower is better; 95% CI)", y = NULL, colour = NULL,
       title = "Study 1 replayed on learners shaped by ASSISTments data", subtitle = sprintf("%d sessions; real session lengths (median %d problems) and learning rates", N, median(len))) +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom")
ggsave("out/fig_replay.png", p, width = 10, height = 5.5, dpi = 130)
