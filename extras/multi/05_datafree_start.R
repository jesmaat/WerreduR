# Can a new skill be started from the learner's OWN earlier difficulty levels, with no
# population-derived number? start_j = w * mean(difficulty reached on skills already practised).
# w = 0 is "always start at the skill's average"; w = 0.48 is the data-derived value of Study 2.
set.seed(2026); S <- readRDS("out/skill_structure.rds")$S
K <- nrow(S); N <- 3000L; NS <- 12L; NT <- 15L; STEP <- 0.20
TH <- matrix(rnorm(N * K), N, K) %*% chol(S); SK <- t(replicate(N, sample.int(K, NS))); U <- array(runif(N * NS * NT), c(N, NS, NT))
run <- function(w) sapply(1:N, function(i) { ends <- numeric(0); e1 <- 0
  for (s in 1:NS) { th <- TH[i, SK[i, s]]; b <- if (length(ends)) w * mean(ends) else 0
    for (t in 1:NT) { if (s > 1 && t <= 5) e1 <- e1 + abs(b - th); b <- b + STEP * (2 * (U[i, s, t] < plogis(th - b)) - 1) }
    ends <- c(ends, b) }
  e1 / ((NS - 1) * 5) })
ws <- c(0, 0.25, 0.48, 0.5, 0.75, 1); r <- sapply(ws, run)
print(data.frame(weight = ws, start_distance = round(colMeans(r), 3)), row.names = FALSE)
d <- function(a, b) { x <- r[, a] - r[, b]; h <- 1.96 * sd(x) / sqrt(N); sprintf("%+.3f [%.3f, %.3f]", mean(x), mean(x) - h, mean(x) + h) }
cat("w=0.5 minus w=0.48 (data-derived):", d(4, 3), "\nw=1 minus w=0.48:", d(6, 3), "\nw=0.5 minus w=0:", d(4, 1), "\n")
