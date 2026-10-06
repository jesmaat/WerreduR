source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
pat <- canonical_patterns(8L)
tg <- sapply(pat, `[[`, "target"); cat("constant-gain loss:", mean((tg - mean(tg))^2), "\n")
shipped <- list(base = WERR_BASE_SEED, combat = c(cx=-0.7445, cy=0.125, zoom=65),
  fin = c(cx=-0.748, cy=0.065, zoom=60), iot = c(cx=-0.745, cy=0.112, zoom=85), fraud = c(cx=-0.7495, cy=0.082, zoom=70))
sh <- sapply(shipped, seed_loss, patterns = pat); print(round(sh, 4))
fb <- function(w) seed_loss(NULL, pat, "explicit", w)
ex <- optim(c(0, 0, 1, -1), fb, method = "L-BFGS-B", lower = -3, upper = 3)
cat("explicit (weights bounded to MFNS range [-3,3]) loss:", ex$value, " w:", round(ex$par, 3), "\n")
exu <- fit_explicit_weights(pat); cat("explicit unbounded loss:", exu$loss, " w:", round(exu$w, 3), "\n")
res <- search_seed(pat); print(res$seed, digits = 16); cat("loss", res$loss, "\n")
saveRDS(list(res = res, ex_bounded = ex$par, ex_bounded_loss = ex$value, ex_unb = exu, shipped_loss = sh,
             const_loss = mean((tg - mean(tg))^2)), "out/seed_search.rds")
