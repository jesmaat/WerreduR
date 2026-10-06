# =============================================================================
# werr_kernel.R -- Pure-R reference port of the WERR fractal kernel
# Source of truth: github.com/pCwOrM/werr  (werr/fractal.py, werr/gates/base.py)
# Ported at commit f80883a (2026-10-04). Function names mirror the Python API.
# This file is the readable reference; src/werr_kernel.cpp is the fast path and
# is checked against this file and against Python WERR in tests/.
# =============================================================================

# compute_mandelbrot_patch(): escape-time field on a res x res window centred at
# (cx, cy) with half-width 1/zoom. Row index = y, column index = x (as in NumPy).
compute_mandelbrot_patch <- function(cx, cy, zoom, res = 36L, max_iter = 36L) {
  scale <- 1 / zoom
  x <- seq(cx - scale, cx + scale, length.out = res)
  y <- seq(cy - scale, cy + scale, length.out = res)
  C <- outer(y, x, function(yy, xx) complex(real = xx, imaginary = yy))
  Z <- matrix(0 + 0i, res, res)
  esc <- matrix(max_iter, res, res)
  mask <- matrix(TRUE, res, res)
  for (i in 0:(max_iter - 1L)) {
    Z[mask] <- Z[mask]^2 + C[mask]
    newly <- (Mod(Z) > 2) & mask
    esc[newly] <- i
    mask <- mask & !newly
  }
  list(black_ratio = mean(esc == max_iter),
       avg_escape  = mean(esc) / max_iter,
       escape_iters = esc)
}

# Abramowitz & Stegun 7.1.26 erf, exactly as in werr/fractal.py::_vec_erf
.vec_erf <- function(x) {
  s <- sign(x); xa <- abs(x)
  t <- 1 / (1 + 0.3275911 * xa)
  poly <- ((((1.061405429 * t - 1.453152027) * t + 1.421413741) * t -
              0.284496736) * t + 0.254829592) * t
  s * (1 - poly * exp(-xa * xa))
}
.normal_cdf <- function(z) 0.5 * (1 + .vec_erf(z / sqrt(2)))

compute_boundary_correction_weights <- function(u, bandwidth = 0.12) {
  u <- pmin(pmax(u, 0), 1); h <- max(1e-4, bandwidth)
  omega <- .normal_cdf(u / h) + .normal_cdf((1 - u) / h) - 1
  1 / pmin(pmax(omega, 0.45), 1)
}

# extract_bounded_quadrant_ratios(): the 4-quadrant MFNS extraction with WERR's
# boundary correction. Q1 top-left -> w1, Q2 top-right -> w2, Q3 bottom-left -> w3,
# Q4 bottom-right -> bias. Returns composite ratios; weights are (ratio - 0.5) * 6.
extract_bounded_quadrant_ratios <- function(esc, max_iter = 36L, bandwidth = 0.12) {
  h <- nrow(esc); w <- ncol(esc); mh <- h %/% 2L; mw <- w %/% 2L
  quads <- list(esc[1:mh, 1:mw], esc[1:mh, (mw + 1):w],
                esc[(mh + 1):h, 1:mw], esc[(mh + 1):h, (mw + 1):w])
  vapply(quads, function(q) {
    u <- as.numeric(q) / max_iter
    wc <- compute_boundary_correction_weights(u, bandwidth)
    cusp <- as.numeric(u >= 0.90)
    0.65 * sum(wc * cusp) / sum(wc) + 0.35 * sum(wc * u) / sum(wc)
  }, numeric(1))
}

# Tripod 3-scale fusion (werr/gates/base.py, tripod=True branch):
# zoom factors 0.60 / 1.00 / 1.60 with weights 0.25 / 0.50 / 0.25.
werr_tripod_R <- function(cx, cy, zoom, res = 36L, max_iter = 36L) {
  zf <- c(0.60, 1.00, 1.60); wz <- c(0.25, 0.50, 0.25)
  quad <- numeric(4); black <- 0
  for (k in 1:3) {
    p <- compute_mandelbrot_patch(cx, cy, zoom * zf[k], res, max_iter)
    quad  <- quad  + wz[k] * extract_bounded_quadrant_ratios(p$escape_iters, max_iter)
    black <- black + wz[k] * p$black_ratio
  }
  list(quad = quad, black = black)
}
