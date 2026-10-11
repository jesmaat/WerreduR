# Step 7 -- does the result depend on the particular seed?
# The seed search (step 0) was run three times and did not converge on one seed.
# The main study uses the best of the three. Here the other two are run on the
# same learners and random draws as the main study, in all six conditions.
#   Rscript R/07_seed_sensitivity.R A     (second search run)
#   Rscript R/07_seed_sensitivity.R B     (third search run)
#   Rscript R/07_seed_sensitivity.R report
# Seeds are taken from out/seed_search.log (ten decimals, as logged).
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); source("R/simulate.R")
ALT <- list(A = c(cx = -0.8075082122, cy = 0.1840019089, zoom = 249.4792),
            B = c(cx = -0.8254651800, cy = 0.2043880997, zoom = 179.2087))
what <- commandArgs(trailingOnly = TRUE)[1]
R <- readRDS("out/sim_results.rds"); N <- R$N; T_len <- R$T_len

if (what %in% names(ALT)) {
  ctl <- make_gate_servo(ALT[[what]], "werr"); res <- list()
  for (sn in names(SCENARIOS)) {
    pop <- draw_population(SCENARIOS[[sn]], N, T_len, rng_seed = 910000L + match(sn, names(SCENARIOS)))
    res[[sn]] <- run_arm(ctl, SCENARIOS[[sn]], pop, T_len)$metrics
    cat(sprintf("seed %s %-10s MAE %.3f\n", what, sn, mean(res[[sn]][, "mae"])))
    saveRDS(res, sprintf("out/seed_sensitivity_%s.rds", what))
  }
  if (what == "A") {   # reproduction check: the study seed on the stable condition must give the stored result
    pop <- draw_population(SCENARIOS$stationary, N, T_len, rng_seed = 910001L)
    chk <- run_arm(make_gate_servo(R$seed, "werr"), SCENARIOS$stationary, pop, T_len)$metrics
    cat(sprintf("reproduction check, study seed, stable: %.6f (stored %.6f), max abs diff per learner %.2e\n",
                mean(chk[, "mae"]), mean(R$res$stationary$PFPW[, "mae"]), max(abs(chk[, "mae"] - R$res$stationary$PFPW[, "mae"]))))
  }
} else {
  A <- readRDS("out/seed_sensitivity_A.rds"); B <- readRDS("out/seed_sensitivity_B.rds")
  lab <- c(stationary = "Stable", slow = "Slow learning", fast = "Fast learning",
           coldstart = "Unknown starting level", jump = "Sudden jump", guessing = "Guessing")
  f <- function(v) sprintf("%+.3f [%+.3f, %+.3f]", v[1], v[2], v[3])
  out <- do.call(rbind, lapply(names(lab), function(sn) { m <- R$res[[sn]]
    data.frame(condition = lab[[sn]],
      study_seed = mean(m$PFPW[, "mae"]), run2_seed = mean(A[[sn]][, "mae"]), run3_seed = mean(B[[sn]][, "mae"]),
      twin = mean(m$GATE_X[, "mae"]), staircase = mean(m$STAIR[, "mae"]), adaptive_test = mean(m$CAT[, "mae"]),
      unsearched = mean(m$PFPW_BASE[, "mae"]),
      run2_minus_study = f(ci(A[[sn]][, "mae"] - m$PFPW[, "mae"])),
      run3_minus_study = f(ci(B[[sn]][, "mae"] - m$PFPW[, "mae"])),
      run2_minus_twin = f(ci(A[[sn]][, "mae"] - m$GATE_X[, "mae"])),
      run3_minus_twin = f(ci(B[[sn]][, "mae"] - m$GATE_X[, "mae"]))) }))
  write.csv(out, "out/table_seed_sensitivity.csv", row.names = FALSE)
  print(out, digits = 3, row.names = FALSE)
  cat(sprintf("\nrecovery after jump (problems): study %.1f | run 2 %.1f | run 3 %.1f | twin %.1f | staircase %.1f\n",
      mean(R$res$jump$PFPW[, "t_reacquire"]), mean(A$jump[, "t_reacquire"]), mean(B$jump[, "t_reacquire"]),
      mean(R$res$jump$GATE_X[, "t_reacquire"]), mean(R$res$jump$STAIR[, "t_reacquire"])))
  cat(sprintf("reach unknown level (problems): study %.1f | run 2 %.1f | run 3 %.1f | twin %.1f | staircase %.1f\n",
      mean(R$res$coldstart$PFPW[, "t_acquire"]), mean(A$coldstart[, "t_acquire"]), mean(B$coldstart[, "t_acquire"]),
      mean(R$res$coldstart$GATE_X[, "t_acquire"]), mean(R$res$coldstart$STAIR[, "t_acquire"])))
}
