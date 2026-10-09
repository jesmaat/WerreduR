# =============================================================================
# Study B, step 1 -- how related are skills in real data? (ASSISTments 2009-2010)
# Output: a K x K table of skill relatedness. This table is the "large policy":
# K(K-1)/2 numbers that a multi-skill controller would have to store.
#  * rows = response x skill tag; main problems only; exact duplicates removed
#  * proficiency of student i on skill k = logit of smoothed accuracy, (c+1)/(n+2),
#    for students with >= 8 responses on that skill
#  * skills kept: the K = 48 skills with the most such students
#  * observed correlation over students who did both skills (>= 40 shared students)
#  * corrected for measurement noise (few responses per skill make correlations look
#    weaker than they are): r / sqrt(rel_j * rel_k), reliabilities from the binomial
#    sampling variance of the logit; clipped to [-0.9, 0.9]; projected to a valid
#    correlation matrix (eigenvalues floored at 0.05).
# =============================================================================
set.seed(2026); K <- 48
d <- read.csv("../data/GKT/data/skill_builder_data.csv", stringsAsFactors = FALSE)
d <- d[d$original == 1 & !is.na(d$skill_id), c("order_id", "user_id", "skill_id", "skill_name", "correct")]
d <- d[!duplicated(d[, c("order_id", "skill_id")]), ]
a <- aggregate(cbind(n = 1, c = d$correct), list(user = d$user_id, skill = d$skill_id), sum)
a <- a[a$n >= 8, ]; a$p <- (a$c + 1) / (a$n + 2); a$z <- qlogis(a$p); a$sv <- 1 / ((a$n + 2) * a$p * (1 - a$p))
top <- names(sort(table(a$skill), decreasing = TRUE))[1:K]; a <- a[a$skill %in% top, ]
Z <- tapply(a$z, list(a$user, factor(a$skill, top)), mean)
rel <- sapply(top, function(s) { x <- a[a$skill == s, ]; max(0.2, 1 - mean(x$sv) / var(x$z)) })
nm <- sapply(top, function(s) d$skill_name[match(s, d$skill_id)])
cat("skills:", K, " students per skill: min", min(colSums(!is.na(Z))), "median", median(colSums(!is.na(Z))), "\n")
cat("reliability of per-skill proficiency: median", round(median(rel), 2), "range", round(range(rel), 2), "\n")
R <- matrix(NA, K, K); Nsh <- crossprod(!is.na(Z))
for (j in 1:(K - 1)) for (k in (j + 1):K) if (Nsh[j, k] >= 40) R[j, k] <- R[k, j] <- cor(Z[, j], Z[, k], use = "complete.obs")
obs <- R[upper.tri(R)]
cat(sprintf("pairs with >= 40 shared students: %d of %d | observed r: mean %.3f, sd %.3f\n", sum(!is.na(obs)), length(obs), mean(obs, na.rm = TRUE), sd(obs, na.rm = TRUE)))
Rc <- R / sqrt(outer(rel, rel)); Rc[is.na(Rc)] <- mean(Rc, na.rm = TRUE); Rc <- pmax(pmin(Rc, 0.9), -0.9); diag(Rc) <- 1
e <- eigen(Rc, symmetric = TRUE); S <- e$vectors %*% diag(pmax(e$values, 0.05)) %*% t(e$vectors); S <- cov2cor(S)
ut <- S[upper.tri(S)]
cat(sprintf("noise-corrected relatedness: mean %.3f, sd %.3f, range %.2f to %.2f\n", mean(ut), sd(ut), min(ut), max(ut)))
ev <- eigen(S, symmetric = TRUE)$values
cat("share of variance in first 1 / 2 / 5 / 10 factors:", round(cumsum(ev)[c(1, 2, 5, 10)] / K, 3), "\n")
# order skills so that related skills sit next to each other (hierarchical clustering);
# this only relabels skills and is free for every storage scheme
o <- hclust(as.dist(1 - S), "average")$order; S <- S[o, o]; dimnames(S) <- list(nm[o], nm[o])
saveRDS(list(S = S, names = nm[o], rel = rel[o], observed = R[o, o]), "out/skill_structure.rds")
cat("examples of most related pairs:\n"); ix <- which(S > 0.8 & upper.tri(S), arr.ind = TRUE)
for (r in head(order(-S[ix]), 6)) cat(sprintf("  %.2f  %s  <->  %s\n", S[ix][r], rownames(S)[ix[r, 1]], colnames(S)[ix[r, 2]]))
