# =============================================================================
# simulate.R -- paired-seed simulation of synthetic learners
# =============================================================================
# Scenarios. Learner response: P = c + (1 - c) * plogis(theta - b).
# Learning rule (when eta > 0): on a correct response theta += eta * (1 - P),
# the "difficulty-weighted" rule of the PFP manuscript. Alignment metrics do not
# depend on which learning rule is true; ability gain does, so gain is secondary.
SCENARIOS <- list(
  stationary = list(mu = 0, eta = 0,    c = 0,    jump = 0,
                    label = "A. Stationary ability"),
  slow       = list(mu = 0, eta = 0.02, c = 0,    jump = 0,
                    label = "B. Slow learning (eta = 0.02)"),
  fast       = list(mu = 0, eta = 0.10, c = 0,    jump = 0,
                    label = "C. Fast learning (eta = 0.10)"),
  coldstart  = list(mu = 2, eta = 0.02, c = 0,    jump = 0,
                    label = "D. Cold start (population mean +2, unknown)"),
  jump       = list(mu = 0, eta = 0,    c = 0,    jump = 1.5,
                    label = "E. Sudden insight (+1.5 logit jump)"),
  guessing   = list(mu = 0, eta = 0.02, c = 0.25, jump = 0,
                    label = "F. Guessing (3PL, c = 0.25)")
)

# Common random numbers: theta0, jump times and all response uniforms are drawn
# once per scenario and reused by every arm.
draw_population <- function(sc, N, T_len, rng_seed) {
  set.seed(rng_seed)
  list(theta0 = rnorm(N, sc$mu, 1),
       jump_t = sample(30:90, N, replace = TRUE),
       U = matrix(runif(N * T_len), N, T_len))
}

run_arm <- function(ctl, sc, pop, T_len) {
  N <- length(pop$theta0)
  out <- matrix(NA_real_, N, 10, dimnames = list(NULL, c("mae", "corridor", "frustr",
           "boredom", "t_acquire", "max_fail_run", "gain", "mae_late", "p_mean", "t_reacquire")))
  err_t <- numeric(T_len)                      # mean |b - theta| by trial (trajectory plot)
  for (i in seq_len(N)) {
    th <- pop$theta0[i]; s <- ctl$init()
    err <- P <- numeric(T_len); fr <- 0L; mfr <- 0L
    for (t in seq_len(T_len)) {
      if (sc$jump != 0 && t == pop$jump_t[i]) th <- th + sc$jump
      b <- ctl$b(s)
      p <- sc$c + (1 - sc$c) * plogis(th - b)
      x <- as.integer(pop$U[i, t] < p)
      err[t] <- abs(b - th); P[t] <- p
      if (x == 1L) { th <- th + sc$eta * (1 - p); fr <- 0L } else { fr <- fr + 1L; mfr <- max(mfr, fr) }
      s <- ctl$update(s, x)
    }
    err_t <- err_t + err / N
    acq <- which(err <= 0.5)
    out[i, ] <- c(mean(err), mean(P >= 0.40 & P <= 0.60), mean(P < 0.30), mean(P > 0.85),
                  if (length(acq)) acq[1] else T_len + 1, mfr,
                  th - pop$theta0[i] - (if (sc$jump != 0) sc$jump else 0),
                  mean(err[(T_len - 39):T_len]), mean(P),
                  # trials needed after the jump to come back within 0.5 logit (jump scenario only;
                  # censored at the end of the session)
                  if (sc$jump != 0) { jt <- pop$jump_t[i]; k <- which(err[jt:T_len] <= 0.5)
                    if (length(k)) k[1] - 1 else T_len - jt + 1 } else NA_real_)
  }
  list(metrics = out, err_t = err_t)
}

# mean and 95% CI; paired difference against a reference arm with the same learners
ci <- function(x) { m <- mean(x); h <- qt(0.975, length(x) - 1) * sd(x) / sqrt(length(x))
                    c(mean = m, lo = m - h, hi = m + h) }
