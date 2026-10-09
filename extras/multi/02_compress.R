# =============================================================================
# Study B, step 2 -- store the 48 x 48 skill-relatedness table in few bytes.
# The table is cut into 8 x 8 blocks (6 x 6 blocks; 21 on or above the diagonal).
# Schemes (bytes counted for everything that must be kept to rebuild the table):
#   full        : 1,128 float32 values
#   quant-b     : b bits per value, uniform levels (+ range)
#   lowrank-r   : r factors, loadings in 8 bits each ("general ability + r-1 more")
#   blockmean   : one 8-bit mean per block
#   fractal     : one MFNS seed (cx, cy, zoom; 24 bytes) per block -> 64 tile values,
#                 plus an 8-bit scale and offset per block
#   prng        : the fractal's plain twin: one pseudo-random seed per block -> 64
#                 uniform numbers, plus the same scale and offset. Same number of
#                 candidates examined per block as the fractal search (960).
#   fractal-rec : MFNS recurrence, all 21 seeds from one pair (seed0, delta): 48 bytes
#   constant    : one number (the mean relatedness)
# =============================================================================
Rcpp::sourceCpp("mfns.cpp"); set.seed(2026)
S <- readRDS("out/skill_structure.rds")$S; K <- nrow(S); G <- 8; NB <- K / G
blocks <- subset(expand.grid(i = 1:NB, j = 1:NB), i <= j)
idx <- function(b) list(r = (blocks$i[b] - 1) * G + 1:G, c = (blocks$j[b] - 1) * G + 1:G)
target <- function(b) { ix <- idx(b); S[ix$r, ix$c] }
shape <- function(v, b) { m <- matrix(v, G, G, byrow = TRUE); if (blocks$i[b] == blocks$j[b]) (m + t(m)) / 2 else m }
offd <- function(b) if (blocks$i[b] == blocks$j[b]) upper.tri(diag(G)) else matrix(TRUE, G, G)   # cells that count
q8 <- function(x, lo, hi) lo + round((pmin(pmax(x, lo), hi) - lo) / (hi - lo) * 255) / 255 * (hi - lo)
fit_block <- function(v, b) {            # best scale + offset (8-bit each) of generated values to the block
  g <- shape(v, b); m <- offd(b); y <- target(b)[m]; x <- g[m]
  if (sd(x) < 1e-9) return(list(r2 = 0, rec = matrix(mean(y), G, G)))
  co <- coef(lm(y ~ x)); co <- c(q8(co[1], -4, 4), q8(co[2], -4, 4))
  rec <- co[1] + co[2] * g; list(r2 = max(0, 1 - sum((y - rec[m])^2) / sum((y - mean(y))^2)), rec = rec)
}
assemble <- function(recs) { R <- matrix(0, K, K)
  for (b in seq_len(nrow(blocks))) { ix <- idx(b); R[ix$r, ix$c] <- recs[[b]]; R[ix$c, ix$r] <- t(recs[[b]]) }
  R <- pmax(pmin((R + t(R)) / 2, 0.99), -0.99); diag(R) <- 1; R }
ut <- upper.tri(S); r2tab <- function(R) 1 - sum((S[ut] - R[ut])^2) / sum((S[ut] - mean(S[ut]))^2)
EVALS <- 960L; out <- list(); timing <- list()

## fractal: evolutionary search per block (population 24, 40 generations = 960 evaluations)
rand_seed <- function() repeat { s <- c(runif(1, -2, 0.5), runif(1, -1.2, 1.2), exp(runif(1, 0, log(2000))))
  v <- mfns_tiles(s[1], s[2], s[3]); if (mean(v) > 0.03 && mean(v) < 0.97) return(s) }
mut <- function(s, sc) c(s[1] + rnorm(1, 0, sc / s[3]), s[2] + rnorm(1, 0, sc / s[3]), max(1, min(5000, s[3] * exp(rnorm(1, 0, 0.3 * sc)))))
search_fractal <- function(b) { pop <- replicate(24, rand_seed(), simplify = FALSE); best <- NULL
  for (gen in 1:40) { f <- sapply(pop, function(s) fit_block(mfns_tiles(s[1], s[2], s[3]), b)$r2)
    o <- order(-f); pop <- pop[o]; if (is.null(best) || f[o[1]] > best$r2) best <- list(seed = pop[[1]], r2 = f[o[1]])
    pop <- c(pop[1:6], lapply(sample(1:6, 18, TRUE), function(i) mut(pop[[i]], 0.5 * 0.95^gen))) }
  best }
t0 <- proc.time()[["elapsed"]]; fr <- lapply(seq_len(nrow(blocks)), search_fractal); t_search_fr <- proc.time()[["elapsed"]] - t0
seeds <- t(sapply(fr, `[[`, "seed"))
timing$fractal <- system.time(Rf <- assemble(lapply(seq_len(nrow(blocks)), function(b) fit_block(mfns_tiles(seeds[b, 1], seeds[b, 2], seeds[b, 3]), b)$rec)))[["elapsed"]]
out$fractal <- list(R = Rf, bytes = nrow(blocks) * (24 + 2), within = sapply(fr, `[[`, "r2"))

## prng twin: best of 960 pseudo-random seeds per block
pr <- lapply(seq_len(nrow(blocks)), function(b) { best <- list(r2 = -1)
  for (s in sample.int(.Machine$integer.max, EVALS)) { set.seed(s); v <- runif(G * G); f <- fit_block(v, b)$r2
    if (f > best$r2) best <- list(seed = s, r2 = f) }
  best })
timing$prng <- system.time(Rp <- assemble(lapply(seq_len(nrow(blocks)), function(b) { set.seed(pr[[b]]$seed); fit_block(runif(G * G), b)$rec })))[["elapsed"]]
out$prng <- list(R = Rp, bytes = nrow(blocks) * (4 + 2), within = sapply(pr, `[[`, "r2"))
set.seed(99)

## prng twin at EQUAL BYTES: four seeds per block (one per 4 x 4 quarter, 4 bytes each) with a
## scale and offset per quarter = 24 bytes per block, 240 candidates per quarter (960 per block)
pr4 <- lapply(seq_len(nrow(blocks)), function(b) { y <- target(b); m <- offd(b); rec <- matrix(NA, G, G)
  for (qi in 0:1) for (qj in 0:1) { rr <- qi * 4 + 1:4; cc <- qj * 4 + 1:4; mm <- m[rr, cc]; yy <- y[rr, cc]
    if (sum(mm) < 3) { rec[rr, cc] <- if (sum(mm)) mean(yy[mm]) else 0; next }
    best <- list(sse = Inf)
    for (s in sample.int(.Machine$integer.max, EVALS / 4)) { set.seed(s); g <- matrix(runif(16), 4, 4)
      co <- coef(lm(yy[mm] ~ g[mm])); if (anyNA(co)) next; co <- c(q8(co[1], -4, 4), q8(co[2], -4, 4))
      r <- co[1] + co[2] * g; sse <- sum((yy[mm] - r[mm])^2); if (sse < best$sse) best <- list(sse = sse, rec = r) }
    rec[rr, cc] <- best$rec }
  rec })
out$prng_equal_bytes <- list(R = assemble(pr4), bytes = nrow(blocks) * 24)
set.seed(99)

## fractal recurrence: seed_l = seed0 + l * delta (48 bytes), one global scale + offset
rec_tiles <- function(p) lapply(seq_len(nrow(blocks)), function(b) { l <- b - 1
  shape(mfns_tiles(p[1] + l * p[4], p[2] + l * p[5], max(1, exp(log(p[3]) + l * p[6]))), b) })
rec_fit <- function(p) { g <- rec_tiles(p); x <- unlist(lapply(seq_along(g), function(b) g[[b]][offd(b)])); y <- unlist(lapply(seq_along(g), function(b) target(b)[offd(b)]))
  if (sd(x) < 1e-9) return(list(r2 = 0, co = c(mean(y), 0))); co <- coef(lm(y ~ x)); list(r2 = summary(lm(y ~ x))$r.squared, co = co, g = g) }
pop <- replicate(24, c(rand_seed(), rnorm(2, 0, 0.01), rnorm(1, 0, 0.05)), simplify = FALSE); bestr <- list(r2 = -1)
for (gen in 1:40) { f <- sapply(pop, function(p) rec_fit(p)$r2); o <- order(-f); pop <- pop[o]
  if (f[o[1]] > bestr$r2) bestr <- list(p = pop[[1]], r2 = f[o[1]])
  pop <- c(pop[1:6], lapply(sample(1:6, 18, TRUE), function(i) { p <- pop[[i]]; sc <- 0.5 * 0.95^gen
    c(mut(p[1:3], sc), p[4:5] + rnorm(2, 0, 0.005 * sc), p[6] + rnorm(1, 0, 0.03 * sc)) })) }
rf <- rec_fit(bestr$p); out$fractal_rec <- list(R = assemble(lapply(rf$g, function(g) rf$co[1] + rf$co[2] * g)), bytes = 48 + 8)

## conventional schemes
out$full <- list(R = S, bytes = sum(ut) * 4)
for (b in c(8, 4, 2, 1)) { lo <- min(S[ut]); hi <- max(S[ut]); L <- 2^b
  R <- S; R[ut] <- lo + (pmin(floor((S[ut] - lo) / (hi - lo) * L), L - 1) + 0.5) / L * (hi - lo); R[lower.tri(R)] <- t(R)[lower.tri(R)]
  out[[paste0("quant", b)]] <- list(R = R, bytes = ceiling(sum(ut) * b / 8) + 8) }
e <- eigen(S, symmetric = TRUE)
for (r in c(1, 2, 3, 5, 10)) { Ld <- e$vectors[, 1:r, drop = FALSE] %*% diag(sqrt(e$values[1:r]), r); Ld <- q8(Ld, -1.5, 1.5)
  R <- Ld %*% t(Ld); diag(R) <- 1; out[[paste0("lowrank", r)]] <- list(R = pmax(pmin(R, 0.99), -0.99), bytes = K * r + 8) }
out$blockmean <- list(R = assemble(lapply(seq_len(nrow(blocks)), function(b) matrix(q8(mean(target(b)[offd(b)]), -1, 1), G, G))), bytes = nrow(blocks))
Rc <- matrix(mean(S[ut]), K, K); diag(Rc) <- 1; out$constant <- list(R = Rc, bytes = 4)
for (n in names(out)) { out[[n]]$R <- { R <- out[[n]]$R; diag(R) <- 1; R }; out[[n]]$r2 <- r2tab(out[[n]]$R) }
tab <- data.frame(scheme = names(out), bytes = sapply(out, `[[`, "bytes"), table_R2 = round(sapply(out, `[[`, "r2"), 3))
print(tab[order(tab$bytes), ], row.names = FALSE)
cat(sprintf("\nwithin-block fit (what the pattern adds beyond the block mean), mean R2 over 21 blocks:\n  fractal %.3f (range %.2f-%.2f) | prng twin %.3f (range %.2f-%.2f)\n",
    mean(out$fractal$within), min(out$fractal$within), max(out$fractal$within), mean(out$prng$within), min(out$prng$within), max(out$prng$within)))
tt <- t.test(out$fractal$within, out$prng$within, paired = TRUE); cat(sprintf("  fractal minus prng: %.3f [%.3f, %.3f]\n", tt$estimate, tt$conf.int[1], tt$conf.int[2]))
cat(sprintf("search time: fractal %.0f s for %d evaluations per block | rebuild table from seeds: fractal %.0f ms, prng %.1f ms\n",
    t_search_fr, EVALS, 1000 * timing$fractal, 1000 * timing$prng))
saveRDS(list(out = out, tab = tab, seeds = seeds, timing = timing, t_search_fr = t_search_fr), "out/compressed.rds")
