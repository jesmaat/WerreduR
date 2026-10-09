# Replay with front-loaded learning: ability at problem t = start + rate * log(t).
setwd("../pfpw"); source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); ss <- readRDS("out/seed_search.rds"); setwd("../replay")
L0 <- readRDS("out/learner_model.rds"); L <- readRDS("out/learner_model_log.rds"); set.seed(2026); N <- 4000L
ARMS <- list("Fractal-seeded controller" = make_gate_servo(ss$res$seed, "werr"), "Stored-weight twin" = make_gate_servo(mode = "explicit", w_explicit = ss$ex_bounded),
  "Adaptive test (standard prior)" = make_cat(), "Adaptive test (prior matched to data)" = NULL, "Adaptive test, forgetting" = make_cat(discount = 0.95),
  "Fixed staircase, step 0.15" = make_staircase(0.15), "Fixed staircase, step 0.30" = make_staircase(0.30), "Fixed staircase, step 0.50" = make_staircase(0.50),
  "PEST-type staircase" = make_pest(), "Original PFP-Core" = make_pfp_core(FALSE))
run <- function(ctl, th0, rate, len, U) sapply(seq_along(th0), function(i) { s <- ctl$init(); e <- 0
  for (t in seq_len(len[i])) { th <- th0[i] + rate[i] * log(t); b <- ctl$b(s); e <- e + abs(b - th); s <- ctl$update(s, as.integer(U[i, t] < plogis(th - b))) }
  e / len[i] })
len <- pmin(sample(L0$lengths, N, TRUE), 60L); rate <- rnorm(N, L$mean_rate, L$sd_rate); z <- rnorm(N); U <- matrix(runif(N * 60), N, 60)
g <- cut(len, c(4, 7, 12, 20, 60), labels = c("5-7", "8-12", "13-20", "21-60")); res <- list()
for (cond in c("student unknown", "student known")) { sd0 <- if (cond == "student unknown") sqrt(L$sd_student^2 + L$sd_pair^2) else L$sd_pair
  ARMS[["Adaptive test (prior matched to data)"]] <- make_cat(prior_sd = sd0)
  res[[cond]] <- sapply(ARMS, function(a) run(a, z * sd0, rate, len, U)) }
tab <- data.frame(controller = names(ARMS), unknown = colMeans(res[[1]]), known = colMeans(res[[2]])); print(format(tab, digits = 3), row.names = FALSE)
ci <- function(x) { h <- 1.96 * sd(x) / sqrt(length(x)); sprintf("%+.3f [%.3f, %.3f]", mean(x), mean(x) - h, mean(x) + h) }
for (cond in names(res)) { cat("\n", cond, ": controller minus ...\n"); for (b in colnames(res[[cond]])[-1]) cat(sprintf("  %-40s %s\n", b, ci(res[[cond]][, 1] - res[[cond]][, b]))) }
for (cond in names(res)) { cat("\nby session length,", cond, "\n"); print(round(sapply(c("Fractal-seeded controller", "Adaptive test (prior matched to data)", "Adaptive test, forgetting", "Fixed staircase, step 0.30"), function(a) tapply(res[[cond]][, a], g, mean)), 3)) }
write.csv(tab, "out/table_replay_saturating.csv", row.names = FALSE)
