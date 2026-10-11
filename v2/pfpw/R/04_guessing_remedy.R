# Guessing remedy (weighted up-down, Kaernbach 1991).
# With a guessing floor c, "knows it with probability 0.50" corresponds to an OBSERVED success
# rate of c + (1 - c)/2 (0.625 for four-option items). An up/down rule settles where
# s_up * p = s_down * (1 - p), so the up-step is set to (1 - p)/p = 0.6 times the down-step.
# The only added information is the number of answer options, which is known from the item format.
# For fairness the adaptive test is given the same information (3PL likelihood with c = 0.25).
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R"); source("R/controllers.R"); source("R/simulate.R")
ss <- readRDS("out/seed_search.rds"); G <- 0.25; P_OBS <- G + (1 - G) / 2; UP <- (1 - P_OBS) / P_OBS
gate_w <- function(seed, mode = "werr", w = NULL, up = 1) list(init = function() list(b = 0, g = gate_state_init()), b = function(s) s$b,
  update = function(s, x) { s$g <- gate_state_update(s$g, x); st <- S_MIN + (S_MAX - S_MIN) * gate_gain(s$g, seed, mode, w)
    s$b <- s$b + if (x == 1) up * st else -st; s })
stair_w <- function(step, up = 1) list(init = function() list(b = 0), b = function(s) s$b, update = function(s, x) { s$b <- s$b + if (x == 1) up * step else -step; s })
cat3 <- function(guess = 0, discount = 1) { lp0 <- dnorm(THETA_GRID, 0, 1, log = TRUE)
  list(init = function() list(ll = numeric(length(THETA_GRID)), b = 0), b = function(s) s$b,
       update = function(s, x) { p <- guess + (1 - guess) * plogis(THETA_GRID - s$b); s$ll <- discount * s$ll + if (x == 1) log(p) else log1p(-p)
         lp <- s$ll + lp0; w <- exp(lp - max(lp)); s$b <- sum(THETA_GRID * w) / sum(w); s }) }
ARMS <- list("Fractal-seeded controller" = gate_w(ss$res$seed), "Fractal-seeded controller, guess-aware steps" = gate_w(ss$res$seed, up = UP),
  "Stored-weight twin, guess-aware steps" = gate_w(NULL, "explicit", ss$ex_bounded, UP),
  "Staircase 0.15" = stair_w(0.15), "Staircase 0.15, guess-aware steps" = stair_w(0.15, UP),
  "Adaptive test (assumes no guessing)" = cat3(0), "Adaptive test, guess-aware (3PL)" = cat3(G), "Adaptive test, guess-aware, forgetting" = cat3(G, 0.95))
sc <- SCENARIOS$guessing; pop <- draw_population(sc, 1000L, 120L, 910006L)
res <- lapply(ARMS, function(a) run_arm(a, sc, pop, 120L)$metrics)
tab <- data.frame(controller = names(ARMS), distance = sapply(res, function(m) mean(m[, "mae"])), observed_success = sapply(res, function(m) mean(m[, "p_mean"])))
print(format(tab, digits = 3), row.names = FALSE)
d <- function(a, b) { x <- res[[a]][, "mae"] - res[[b]][, "mae"]; h <- qt(.975, 999) * sd(x) / sqrt(1000); sprintf("%+.3f [%.3f, %.3f]", mean(x), mean(x) - h, mean(x) + h) }
cat("guess-aware controller minus plain controller:        ", d(2, 1), "\n")
cat("guess-aware controller minus adaptive test (no guess):", d(2, 6), "\n")
cat("guess-aware controller minus guess-aware adaptive test:", d(2, 7), "\n")
cat("guess-aware controller minus guess-aware forgetting AT:", d(2, 8), "\n")
cat("guess-aware controller minus guess-aware staircase:    ", d(2, 5), "\n")
cat("guess-aware controller minus guess-aware twin:         ", d(2, 3), "\n")
write.csv(tab, "out/table_guessing_remedy.csv", row.names = FALSE)
