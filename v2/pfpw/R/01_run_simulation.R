# Step 1 -- main experiment. Usage: Rscript R/01_run_simulation.R [N] [T]
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); source("R/simulate.R")
args <- commandArgs(trailingOnly = TRUE)
N <- if (length(args) >= 1) as.integer(args[1]) else 1000L
T_len <- if (length(args) >= 2) as.integer(args[2]) else 120L
ss <- readRDS("out/seed_search.rds"); SEED <- ss$res$seed

ARMS <- list(
  CAT       = list(label = "CAT 0.5 (EAP, reference)",            ctl = make_cat()),
  CAT_F     = list(label = "CAT 0.5 (EAP, forgetting 0.95)",      ctl = make_cat(discount = 0.95)),
  STAIR     = list(label = "Staircase = Elo (step 0.15)",         ctl = make_staircase(0.15)),
  PEST      = list(label = "PEST-type staircase",                 ctl = make_pest()),
  GATE_X    = list(label = "Explicit gate (stored weights)",      ctl = make_gate_servo(mode = "explicit", w_explicit = ss$ex_bounded)),
  PFPW      = list(label = "PFP-W LearningGate (searched seed)",  ctl = make_gate_servo(SEED, "werr")),
  PFPW_FRZ  = list(label = "PFP-W frozen (no state modulation)",  ctl = make_gate_servo(SEED, "frozen")),
  PFPW_BASE = list(label = "PFP-W, unsearched WERR base seed",    ctl = make_gate_servo(WERR_BASE_SEED, "werr")),
  PFP_CORE  = list(label = "Original PFP-Core (2026 manuscript)", ctl = make_pfp_core(FALSE)),
  PFP_COREJ = list(label = "Original PFP-Core+J",                 ctl = make_pfp_core(TRUE))
)

res <- list(); traj <- list()
for (sn in names(SCENARIOS)) {
  sc <- SCENARIOS[[sn]]
  pop <- draw_population(sc, N, T_len, rng_seed = 910000L + match(sn, names(SCENARIOS)))
  for (an in names(ARMS)) {
    t0 <- proc.time()[["elapsed"]]
    r <- run_arm(ARMS[[an]]$ctl, sc, pop, T_len)
    res[[sn]][[an]] <- r$metrics; traj[[sn]][[an]] <- r$err_t
    cat(sprintf("%-10s %-9s MAE %.3f corridor %.3f  (%.0fs)\n", sn, an, mean(r$metrics[, "mae"]),
                mean(r$metrics[, "corridor"]), proc.time()[["elapsed"]] - t0))
    saveRDS(list(res = res, traj = traj, N = N, T_len = T_len, seed = SEED), "out/sim_results.rds")
  }
}

# decision latency: one update (= one difficulty decision), mean over 3000 calls
set.seed(1); xs <- rbinom(3000, 1, 0.5)
lat <- sapply(ARMS, function(a) { s <- a$ctl$init()
  t <- system.time(for (x in xs) s <- a$ctl$update(s, x))[["elapsed"]]; 1e6 * t / length(xs) })
saveRDS(lat, "out/latency.rds"); print(round(lat, 1))
