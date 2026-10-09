# Parity: Python WERR  ==  pure-R port  ==  Rcpp fast path
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp")
ref <- read.csv("tests/python_reference.csv")
dR <- dC <- numeric(nrow(ref))
for (i in seq_len(nrow(ref))) {
  py <- unlist(ref[i, 4:8])
  r  <- werr_tripod_R(ref$cx[i], ref$cy[i], ref$zoom[i]); r <- c(r$quad, r$black)
  cc <- werr_tripod_cpp(ref$cx[i], ref$cy[i], ref$zoom[i])
  dR[i] <- max(abs(r - py)); dC[i] <- max(abs(cc - py))
}
cat(sprintf("coordinates tested: %d\nmax |R - Python|    = %.3g\nmax |Rcpp - Python| = %.3g\n",
            nrow(ref), max(dR), max(dC)))
cat("n(R > 1e-9):", sum(dR > 1e-9), " n(Rcpp > 1e-9):", sum(dC > 1e-9), "\n")
