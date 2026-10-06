# =============================================================================
# controllers.R -- all arms share one interface:
#   ctl$init() -> state ; ctl$b(state) -> difficulty to present ;
#   ctl$update(state, x) -> state   (x = 1 correct, 0 incorrect)
# Every arm starts at b = 0 and sees only binary responses.
# =============================================================================
S_MIN <- 0.05; S_MAX <- 0.60          # shared step bounds for all gain-scheduled arms
THETA_GRID <- seq(-6, 6, by = 0.1)

# --- Reference: CAT targeting P* = 0.50 under the Rasch model, EAP ability estimate.
# discount = 1   : classical CAT (stationary-theta assumption, N(0,1) prior)
# discount < 1   : likelihood forgetting, the usual patch for non-stationary learners
make_cat <- function(discount = 1, prior_mean = 0, prior_sd = 1) {
  lprior <- dnorm(THETA_GRID, prior_mean, prior_sd, log = TRUE)
  list(
    init = function() list(ll = numeric(length(THETA_GRID)), b = prior_mean),
    b = function(s) s$b,
    update = function(s, x) {
      p <- plogis(THETA_GRID - s$b)
      s$ll <- discount * s$ll + if (x == 1) log(p) else log1p(-p)
      lp <- s$ll + lprior; w <- exp(lp - max(lp))
      s$b <- sum(THETA_GRID * w) / sum(w)          # next item at b = theta_hat  => P* = 0.50
      s
    })
}

# --- Levitt (1971) 1-up/1-down staircase, fixed step.
# Identical to Elo item selection at P* = 0.50 with K = 2 * step (Pelanek, 2016).
make_staircase <- function(step = 0.15) list(
  init = function() list(b = 0), b = function(s) s$b,
  update = function(s, x) { s$b <- s$b + step * (2 * x - 1); s })

# --- PEST-type accelerated staircase (after Taylor & Creelman, 1967):
# halve the step at every reversal, double it from the 3rd equal response on.
make_pest <- function(start = 0.30) list(
  init = function() list(b = 0, s = start, last = NA, run = 0L), b = function(st) st$b,
  update = function(st, x) {
    if (!is.na(st$last) && x != st$last) { st$s <- max(S_MIN, st$s / 2); st$run <- 1L }
    else { st$run <- st$run + 1L; if (st$run >= 3L) st$s <- min(S_MAX, st$s * 2) }
    st$b <- st$b + st$s * (2 * x - 1); st$last <- x; st
  })

# --- LearningGate servo. mode: "werr" (proposed), "frozen" (ablation),
# "explicit" (matched non-fractal control: same neuron, stored weights).
make_gate_servo <- function(seed = NULL, mode = "werr", w_explicit = NULL) {
  w_frozen <- if (mode == "frozen")
    (werr_tripod_cpp(seed[["cx"]], seed[["cy"]], seed[["zoom"]])[1:4] - 0.5) * 6 else NULL
  list(
    init = function() list(b = 0, g = gate_state_init()), b = function(s) s$b,
    update = function(s, x) {
      s$g <- gate_state_update(s$g, x)
      gain <- if (mode == "frozen") gate_gain(s$g, mode = "explicit", w_explicit = w_frozen)
              else gate_gain(s$g, seed, mode, w_explicit)
      s$b <- s$b + (S_MIN + (S_MAX - S_MIN) * gain) * (2 * x - 1); s
    })
}

# --- Legacy arms from the original PFP manuscript, re-implemented from the authors' code
# (github.com/jesmaat/WerreduR, sim/sim_rigorous_revision_suite.py, commit 4251db9):
#   c <- c + (+/-0.05) - kappa * (c - X),  X = 0.25 + 0.18i,  kappa = 0.44,  b = 10 * Re(c - X)
#   +J: after 4 consecutive failures, c <- X (reset to the anchor) instead of the usual step.
# No Mandelbrot iteration is computed in these arms; X is used as a constant.
make_pfp_core <- function(jump = FALSE, kappa = 0.44, delta = 0.05, beta = 10) {
  X <- complex(real = 0.25, imaginary = 0.18)
  list(
    init = function() list(c = X, fails = 0L), b = function(s) beta * Re(s$c - X),
    update = function(s, x) {
      s$fails <- if (x == 0) s$fails + 1L else 0L
      if (jump && s$fails >= 4L) { s$c <- X; s$fails <- 0L }
      else s$c <- s$c + (if (x == 1) delta else -delta) - kappa * (s$c - X)
      s
    })
}
