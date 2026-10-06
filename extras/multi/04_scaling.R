# =============================================================================
# Does fractal coding get relatively better as the policy gets LARGER or MORE IRREGULAR?
# Targets: square tables of 64, 256 and 1,024 values, of three kinds
#   smooth  : a few broad gradients (highly structured)
#   rough   : self-similar, fractal-like surface (1/f spectrum) -- the kind of target
#             a fractal generator should suit best
#   random  : independent values, no structure at all ("chaotic" in the plain sense)
# Schemes at (about) the same bytes: one fractal seed per 64 values + scale/offset
# (26 bytes), a pseudo-random seed twin with the same search effort, plain rounding
# of every value to 3 bits (24 bytes per 64 values), and a low-rank table of equal size.
# Outcome: share of the table's variance reproduced. 3 independent tables per cell.
# =============================================================================
Rcpp::sourceCpp("mfns.cpp"); set.seed(2026); G <- 8; EV <- 960L
make <- function(kind, n) { if (kind == "random") return(matrix(rnorm(n * n), n))
  fx <- outer(0:(n - 1), 0:(n - 1), function(i, j) sqrt(pmin(i, n - i)^2 + pmin(j, n - j)^2)); fx[1, 1] <- 1
  beta <- if (kind == "smooth") 4 else 1.2
  sp <- (fx^(-beta / 2)) * complex(modulus = 1, argument = runif(n * n, 0, 2 * pi)); sp[1, 1] <- 0
  m <- Re(fft(matrix(sp, n), inverse = TRUE)); (m - mean(m)) / sd(m) }
r2 <- function(y, rec) 1 - sum((y - rec)^2) / sum((y - mean(y))^2)
aff <- function(v, y) { if (sd(v) < 1e-9) return(rep(mean(y), length(y))); co <- coef(lm(as.numeric(y) ~ v)); co[1] + co[2] * v }
rand_seed <- function() repeat { s <- c(runif(1, -2, 0.5), runif(1, -1.2, 1.2), exp(runif(1, 0, log(2000)))); v <- mfns_tiles(s[1], s[2], s[3]); if (mean(v) > 0.03 && mean(v) < 0.97) return(s) }
mut <- function(s, sc) c(s[1] + rnorm(1, 0, sc / s[3]), s[2] + rnorm(1, 0, sc / s[3]), max(1, min(5000, s[3] * exp(rnorm(1, 0, 0.3 * sc)))))
fit_fr <- function(y) { yv <- as.numeric(t(y)); pop <- replicate(24, rand_seed(), simplify = FALSE); best <- -Inf; rec <- NULL
  for (g in 1:40) { vs <- lapply(pop, function(s) mfns_tiles(s[1], s[2], s[3])); f <- sapply(vs, function(v) if (sd(v) < 1e-9) 0 else cor(v, yv)^2)
    o <- order(-f); pop <- pop[o]; if (f[o[1]] > best) { best <- f[o[1]]; rec <- aff(vs[[o[1]]], yv) }
    pop <- c(pop[1:6], lapply(sample(1:6, 18, TRUE), function(i) mut(pop[[i]], 0.5 * 0.95^g))) }
  matrix(rec, G, G, byrow = TRUE) }
fit_pr <- function(y) { yv <- as.numeric(t(y)); best <- -Inf; rec <- NULL
  for (k in 1:EV) { v <- runif(G * G); f <- cor(v, yv)^2; if (f > best) { best <- f; rec <- aff(v, yv) } }
  matrix(rec, G, G, byrow = TRUE) }
quant <- function(y, bits = 3) { lo <- min(y); hi <- max(y); L <- 2^bits; lo + (pmin(floor((y - lo) / (hi - lo) * L), L - 1) + 0.5) / L * (hi - lo) }
lowrank <- function(y, r) { s <- svd(y); r <- min(r, length(s$d)); s$u[, 1:r, drop = FALSE] %*% diag(s$d[1:r], r) %*% t(s$v[, 1:r, drop = FALSE]) }
out <- NULL
for (kind in c("smooth", "rough", "random")) for (n in c(8, 16, 32)) for (rep in 1:3) {
  y <- make(kind, n); nb <- (n / G)^2; fr <- pr <- y
  for (bi in 0:(n / G - 1)) for (bj in 0:(n / G - 1)) { ix <- bi * G + 1:G; jx <- bj * G + 1:G
    fr[ix, jx] <- fit_fr(y[ix, jx]); pr[ix, jx] <- fit_pr(y[ix, jx]) }
  rk <- max(1, floor(26 * nb / (2 * n)))
  out <- rbind(out, data.frame(kind, values = n * n, fractal = r2(y, fr), prng = r2(y, pr), round3bit = r2(y, quant(y)), lowrank = r2(y, lowrank(y, rk)))) }
agg <- aggregate(cbind(fractal, prng, round3bit, lowrank) ~ kind + values, out, mean)
agg <- agg[order(match(agg$kind, c("smooth", "rough", "random")), agg$values), ]; agg[, 3:6] <- round(100 * agg[, 3:6]); print(agg, row.names = FALSE)
write.csv(agg, "out/table_scaling.csv", row.names = FALSE)
