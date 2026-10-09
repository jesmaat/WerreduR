# Step 0 -- discover the LearningGate seed (run once; result is 24 bytes).
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
pat <- canonical_patterns(8L)
prev <- readRDS("out/seed_search.rds")
runs <- list()
starts <- list(prev$res$seed, WERR_BASE_SEED, WERR_BASE_SEED)       # warm start + 2 fresh restarts
for (k in seq_along(starts)) {
  cat("---- restart", k, "----\n")
  runs[[k]] <- search_seed(pat, start = starts[[k]], generations = 80L, rng_seed = 2026L + k)
  cat(sprintf("restart %d: loss %.4f  seed (%.10f, %.10f, %.4f)\n", k, runs[[k]]$loss,
              runs[[k]]$seed[["cx"]], runs[[k]]$seed[["cy"]], runs[[k]]$seed[["zoom"]]))
  saveRDS(runs, "out/seed_restarts.rds")
}
best <- runs[[which.min(sapply(runs, `[[`, "loss"))]]
prev$res <- best; prev$restart_losses <- sapply(runs, `[[`, "loss")
saveRDS(prev, "out/seed_search.rds")
cat("FINAL"); print(best$seed, digits = 17); cat("loss", best$loss, "\n")
