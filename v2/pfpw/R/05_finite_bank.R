# Robustness check: a finite item bank instead of "any difficulty is available".
# Bank: n items with difficulties at evenly spaced quantiles of N(0, 1.5). Each controller requests a
# difficulty; the system presents the nearest item not yet used in the session (the bank is reused
# once exhausted). The adaptive test uses the PRESENTED item's difficulty in its likelihood;
# rule-based controllers keep their requested difficulty as their state.
# Outcome: distance between the presented item's difficulty and true ability.
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R"); source("R/controllers.R"); source("R/simulate.R")
ss <- readRDS("out/seed_search.rds"); N <- 1000L; T_len <- 120L
ARMS <- list("Fractal-seeded controller" = list(ctl = make_gate_servo(ss$res$seed, "werr"), est = FALSE),
             "Stored-weight twin" = list(ctl = make_gate_servo(mode = "explicit", w_explicit = ss$ex_bounded), est = FALSE),
             "Adaptive test" = list(ctl = make_cat(), est = TRUE), "Adaptive test, forgetting" = list(ctl = make_cat(discount = 0.95), est = TRUE),
             "Staircase 0.15" = list(ctl = make_staircase(0.15), est = FALSE))
run_bank <- function(arm, sc, pop, bank) { ctl <- arm$ctl; nb <- length(bank)
  sapply(seq_len(N), function(i) { th <- pop$theta0[i]; s <- ctl$init(); used <- logical(nb); e <- 0
    for (t in seq_len(T_len)) { if (sc$jump != 0 && t == pop$jump_t[i]) th <- th + sc$jump
      if (is.null(bank)) bi <- ctl$b(s) else { if (all(used)) used[] <- FALSE; d <- abs(bank - ctl$b(s)); d[used] <- Inf; j <- which.min(d); used[j] <- TRUE; bi <- bank[j] }
      p <- sc$c + (1 - sc$c) * plogis(th - bi); x <- as.integer(pop$U[i, t] < p); e <- e + abs(bi - th)
      if (x == 1L) th <- th + sc$eta * (1 - p)
      if (arm$est) s$b <- bi                      # the estimator is told which item was actually presented
      s <- ctl$update(s, x) }
    e / T_len }) }
banks <- list("Continuous (as in the main study)" = NULL, "200 items" = qnorm((1:200 - 0.5) / 200, 0, 1.5), "50 items" = qnorm((1:50 - 0.5) / 50, 0, 1.5))
res <- list()
for (sn in c("stationary", "fast", "jump")) { sc <- SCENARIOS[[sn]]; pop <- draw_population(sc, N, T_len, 910000L + match(sn, names(SCENARIOS)))
  for (bn in names(banks)) for (an in names(ARMS)) { res[[sn]][[bn]][[an]] <- run_bank(ARMS[[an]], sc, pop, banks[[bn]])
    cat(sprintf("%-10s %-34s %-26s %.3f\n", sn, bn, an, mean(res[[sn]][[bn]][[an]]))); saveRDS(res, "out/finite_bank.rds") } }
tab <- do.call(rbind, lapply(names(res), function(sn) do.call(rbind, lapply(names(res[[sn]]), function(bn) data.frame(condition = sn, bank = bn, t(sapply(res[[sn]][[bn]], mean)), check.names = FALSE)))))
write.csv(tab, "out/table_finite_bank.csv", row.names = FALSE); print(tab, digits = 3, row.names = FALSE)
ci <- function(x) { h <- qt(.975, N - 1) * sd(x) / sqrt(N); sprintf("%+.3f [%.3f, %.3f]", mean(x), mean(x) - h, mean(x) + h) }
for (sn in names(res)) for (bn in names(res[[sn]])) cat(sprintf("%-10s %-34s controller minus adaptive test: %s | minus staircase: %s | minus twin: %s\n", sn, bn,
  ci(res[[sn]][[bn]][[1]] - res[[sn]][[bn]][[3]]), ci(res[[sn]][[bn]][[1]] - res[[sn]][[bn]][[5]]), ci(res[[sn]][[bn]][[1]] - res[[sn]][[bn]][[2]])))
