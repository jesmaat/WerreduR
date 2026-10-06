# Replay on learners shaped by ASSISTments 2017, under constant and front-loaded learning.
setwd("../pfpw"); source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); ss <- readRDS("out/seed_search.rds"); setwd("../replay")
M <- readRDS("out/learner_model_2017.rds"); N <- 4000L
mk <- function(sd0) list("Fractal-seeded controller" = make_gate_servo(ss$res$seed, "werr"), "Stored-weight twin" = make_gate_servo(mode = "explicit", w_explicit = ss$ex_bounded),
  "Adaptive test (standard prior)" = make_cat(), "Adaptive test (prior matched to data)" = make_cat(prior_sd = sd0), "Adaptive test, forgetting" = make_cat(discount = 0.95),
  "Fixed staircase, step 0.15" = make_staircase(0.15), "Fixed staircase, step 0.30" = make_staircase(0.30), "Fixed staircase, step 0.50" = make_staircase(0.50),
  "PEST-type staircase" = make_pest(), "Original PFP-Core" = make_pfp_core(FALSE))
run <- function(ctl, th0, rate, len, U, form) sapply(seq_along(th0), function(i) { s <- ctl$init(); e <- 0
  for (t in seq_len(len[i])) { th <- th0[i] + rate[i] * (if (form == "log") log(t) else (t - 1)); b <- ctl$b(s); e <- e + abs(b - th); s <- ctl$update(s, as.integer(U[i, t] < plogis(th - b))) }
  e / len[i] })
ci <- function(x) { h <- 1.96 * sd(x) / sqrt(length(x)); sprintf("%+.3f [%.3f, %.3f]", mean(x), mean(x) - h, mean(x) + h) }
all <- list()
for (form in c("linear", "log")) { P <- M[[form]]; set.seed(2026)
  len <- pmin(sample(M$lengths, N, TRUE), 60L); rate <- rnorm(N, P$mean_rate, P$sd_rate); z <- rnorm(N); U <- matrix(runif(N * 60), N, 60)
  cat(sprintf("\n==== %s learning | sessions median %d problems | rate %.3f (sd %.3f) | start sd unknown %.2f, known %.2f\n", form, median(len), P$mean_rate, P$sd_rate, sqrt(P$sd_student^2 + P$sd_pair^2), P$sd_pair))
  for (cond in c("unknown", "known")) { sd0 <- if (cond == "unknown") sqrt(P$sd_student^2 + P$sd_pair^2) else P$sd_pair; A <- mk(sd0)
    r <- sapply(A, function(a) run(a, z * sd0, rate, len, U, form)); all[[paste(form, cond)]] <- colMeans(r)
    cat(sprintf("-- student %s: controller minus ...\n", cond)); for (b in colnames(r)[-1]) cat(sprintf("   %-40s %s\n", b, ci(r[, 1] - r[, b]))) } }
tab <- round(do.call(cbind, all), 3); print(tab); write.csv(tab, "out/table_replay_2017.csv")
