Rcpp::sourceCpp("dfa.cpp")
# DFA scaling exponent alpha: slope of log F(n) on log n.
# alpha ~ 0.5: no memory (white noise); ~1.0: "1/f", scale-free fluctuation; ~1.5: random walk.
dfa_alpha <- function(x, boxes) {
  if (sd(x) == 0) return(NA_real_)
  F <- dfa_F(x, boxes); ok <- F > 0
  if (sum(ok) < 4) return(NA_real_)
  unname(coef(lm(log(F[ok]) ~ log(boxes[ok])))[2])
}
auc <- function(score, y) { r <- rank(score); n1 <- sum(y == 1); n0 <- sum(y == 0)
  (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0) }
# sanity check of the estimator on series with known exponents
set.seed(1); bx <- unique(round(exp(seq(log(8), log(256), length.out = 12))))
chk <- c(white = mean(replicate(200, dfa_alpha(rnorm(1024), bx))),
         walk  = mean(replicate(200, dfa_alpha(cumsum(rnorm(1024)), bx))))
cat(sprintf("DFA check: white noise alpha = %.3f (expect 0.5), random walk = %.3f (expect 1.5)\n", chk[1], chk[2]))
set.seed(2); bs <- c(4, 6, 8, 12, 16, 24, 30)
cat(sprintf("Short-series check (N = 120, boxes 4-30): white = %.3f (sd %.3f), walk = %.3f\n",
    mean(a <- replicate(500, dfa_alpha(rnorm(120), bs))), sd(a), mean(replicate(500, dfa_alpha(cumsum(rnorm(120)), bs)))))
