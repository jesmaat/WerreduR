source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); source("R/simulate.R")
ss <- readRDS("out/seed_search.rds"); seed <- ss$res$seed
pat <- canonical_patterns(8L)
# gain truth table by run length and by direction (symmetry check)
runlen <- function(v) { h <- rev(v); r <- 1; while (r < length(h) && h[r+1] == h[1]) r <- r + 1; r }
grid <- as.matrix(expand.grid(rep(list(0:1), 8)))
g <- sapply(pat, function(p) gate_gain(p$st, seed)); rl <- apply(grid, 1, runlen); last <- grid[, 8]
print(round(tapply(g, list(run = pmin(rl, 5), last_response = last), mean), 3))
cat("max |g(pattern) - g(flipped pattern)| =", max(abs(g - rev(g))), "\n")
# kernel timing
t <- system.time(for (i in 1:2000) werr_tripod_cpp(seed[["cx"]] + i * 1e-5, seed[["cy"]], seed[["zoom"]]))
cat("tripod kernel ms/call:", t[["elapsed"]] / 2, "\n")
sc <- SCENARIOS$slow; pop <- draw_population(sc, 60, 120, 1)
arms <- list(cat = make_cat(), stair = make_staircase(), pest = make_pest(), werr = make_gate_servo(seed, "werr"))
for (n in names(arms)) { tt <- system.time(r <- run_arm(arms[[n]], sc, pop, 120))[["elapsed"]]
  cat(sprintf("%-6s %.2fs ", n, tt)); print(round(colMeans(r), 3)) }
