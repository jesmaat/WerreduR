# =============================================================================
# learning_gate.R -- "LearningGate": a WERR DomainGate for adaptive difficulty
#
# Follows the DomainGate contract of werr/gates/base.py step by step:
#   1. project_state(state) -> (vec in [-1,1]^4, net_risk rho)
#   2. boundary coordinate modulation of the 24-byte seed (cx, cy, zoom)
#   3. tripod escape-time pass -> 4 bounded quadrant ratios
#   4. MFNS 4-quadrant mapping: (w1, w2, w3, bias) = (ratio - 0.5) * 6
#   5. one neuron: g = sigmoid(w1*v1 + w2*v2 + w3*v3 + bias)
# The neuron output g is used ONLY as the gain (step size) of a symmetric
# up/down difficulty servo:  b <- b + (s_min + (s_max - s_min) * g) * (2x - 1).
#
# What the gate sees: the learner's last binary responses. Nothing else.
# No theta, no item parameters, no population prior.
#
# Symmetry by construction: every input to the gate is invariant under flipping
# all responses (0 <-> 1). Up-steps and down-steps therefore have the same size
# distribution and the servo targets P* = 0.50 (Kaernbach, 1991: an up/down rule
# converges where s_up * P = s_down * (1 - P)).
# =============================================================================

WERR_BASE_SEED <- c(cx = -0.7436438870371587, cy = 0.1318259042053119, zoom = 50.0)
RHO_LEAK <- 1 / 3      # rho <- (1 - leak) * rho + (2x - 1); |rho| <= 3, same range as WERR risk tiers

# --- controller memory: 4 response bits + rho (+ difficulty b kept by the servo) ---
gate_state_init <- function() list(hist = c(NA, NA, NA, NA), rho = 0)

gate_state_update <- function(st, x) {
  st$hist <- c(x, st$hist[1:3])
  st$rho  <- (1 - RHO_LEAK) * st$rho + (2 * x - 1)
  st
}

# --- 1. project_state: response history -> (vec, net_risk) ---
.agree <- function(a, b) if (is.na(a) || is.na(b)) 0 else if (a == b) 1 else -1
project_state <- function(st) {
  h <- st$hist
  a1 <- .agree(h[1], h[2]); a2 <- .agree(h[2], h[3]); a3 <- .agree(h[3], h[4])
  m  <- 2 * abs(st$rho) / 3 - 1          # imbalance magnitude, in [-1, 1]
  list(vec = c(a1, a2, m, a3),           # WERR convention: K = 4 latent features
       net_risk = abs(st$rho) - 1)       # "risk" = distance from balanced responding
}

# --- 2. boundary coordinate modulation: verbatim from werr/gates/base.py ---
modulate_seed <- function(seed, vec, net_risk) {
  scale <- 1 / seed[["zoom"]]
  dx <- tanh(if (net_risk != 0) net_risk else mean(vec[c(1, 3)])) * scale * 0.45
  dy <- tanh(mean(vec[c(2, 4)])) * scale * 0.45
  c(cx = seed[["cx"]] + dx, cy = seed[["cy"]] + dy,
    zoom = seed[["zoom"]] * (1 + 0.1 * sin(sum(vec))))
}

# --- 3-5. fractal pass and neuron ---
# mode = "werr"    : full gate (state-modulated coordinates)          [proposed]
#        "frozen"  : weights read once at the unmodulated seed        [ablation]
#        "explicit": weights supplied directly, no fractal            [matched control]
gate_gain <- function(st, seed = WERR_BASE_SEED, mode = "werr", w_explicit = NULL,
                      kernel = werr_tripod_cpp) {
  ps <- project_state(st)
  w <- switch(mode,
    werr     = { e <- modulate_seed(seed, ps$vec, ps$net_risk)
                 (kernel(e[["cx"]], e[["cy"]], e[["zoom"]])[1:4] - 0.5) * 6 },
    frozen   = (kernel(seed[["cx"]], seed[["cy"]], seed[["zoom"]])[1:4] - 0.5) * 6,
    explicit = w_explicit)
  z <- w[1] * ps$vec[1] + w[2] * ps$vec[2] + w[3] * ps$vec[3] + w[4]
  1 / (1 + exp(-max(-50, min(50, z))))
}

# =============================================================================
# Seed search (MFNS Section V-B / werr scripts/genetic_seed_optimizer.py).
# The target is a truth table over RESPONSE PATTERNS, exactly as MFNS targets
# logic-gate truth tables. No learner model, no theta, no item data enter here.
# Under balanced responding (P = 0.50) a run of k equal responses has probability
# 2^-(k-1). The target gain is zero while such a run is unsurprising and rises as
# it becomes improbable:
#     target(k) = max(0, 1 - 4 * 2^-(k-1))   ->  k<=3: 0 | 4: .50 | 5: .75 | 6: .875 ...
# i.e. small steps while the learner sits on the P = 0.50 horizon, large steps
# when the evidence says the horizon has been lost. Step-size adaptation of this
# kind goes back to PEST (Taylor & Creelman, 1967); here it is written as a gate.
# =============================================================================
canonical_patterns <- function(len = 8L) {
  grid <- as.matrix(expand.grid(rep(list(0:1), len)))
  lapply(seq_len(nrow(grid)), function(i) {
    st <- gate_state_init()
    for (x in grid[i, ]) st <- gate_state_update(st, x)
    run <- 1L; h <- rev(grid[i, ])
    while (run < len && h[run + 1L] == h[1L]) run <- run + 1L
    list(st = st, target = max(0, 1 - 4 * 2^-(run - 1)))
  })
}

seed_loss <- function(seed, patterns, mode = "werr", w_explicit = NULL) {
  g <- vapply(patterns, function(p) gate_gain(p$st, seed, mode, w_explicit), numeric(1))
  t <- vapply(patterns, function(p) p$target, numeric(1))
  mean((g - t)^2)
}

# Genetic search with the hyper-parameters of WERR's own optimiser:
# population 24, Gaussian coordinate mutation sd 0.02, log-normal zoom mutation
# sd 0.3, zoom clipped to [10, 300], elitist selection.
search_seed <- function(patterns, start = WERR_BASE_SEED, generations = 40L,
                        pop_size = 24L, rng_seed = 2026L, verbose = TRUE) {
  set.seed(rng_seed)
  mutate <- function(s, sd_c = 0.02, sd_z = 0.3)
    c(cx = s[["cx"]] + rnorm(1, 0, sd_c), cy = s[["cy"]] + rnorm(1, 0, sd_c),
      zoom = max(10, min(300, s[["zoom"]] * exp(rnorm(1, 0, sd_z)))))
  pop <- c(list(start), replicate(pop_size - 1L, mutate(start), simplify = FALSE))
  trace <- numeric(generations)
  for (gen in seq_len(generations)) {
    fit <- vapply(pop, seed_loss, numeric(1), patterns = patterns)
    ord <- order(fit); pop <- pop[ord]; fit <- fit[ord]; trace[gen] <- fit[1]
    if (verbose && gen %% 5 == 0)
      cat(sprintf("gen %2d  loss %.4f  seed (%.6f, %.6f, %.2f)\n", gen, fit[1],
                  pop[[1]][["cx"]], pop[[1]][["cy"]], pop[[1]][["zoom"]]))
    elite <- pop[1:6]
    sd_c <- 0.02 * 0.93^gen                 # annealed mutation
    pop <- c(elite, lapply(sample(1:6, pop_size - 6L, replace = TRUE),
                           function(i) mutate(elite[[i]], sd_c, 0.3 * 0.95^gen)))
  }
  fit <- vapply(pop[1:6], seed_loss, numeric(1), patterns = patterns)
  list(seed = pop[[which.min(fit)]], loss = min(fit), trace = trace)
}

# Least-squares optimum of the SAME neuron with free weights: the best any seed
# could do, and the "explicit weights" matched control (stores 4 floats).
fit_explicit_weights <- function(patterns) {
  f <- function(w) seed_loss(NULL, patterns, "explicit", w)
  best <- NULL
  for (s in 1:8) { set.seed(s)
    o <- optim(rnorm(4), f, method = "BFGS", control = list(maxit = 500))
    if (is.null(best) || o$value < best$value) best <- o }
  list(w = best$par, loss = best$value)
}
