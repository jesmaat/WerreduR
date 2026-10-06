# =============================================================================
# Study B, step 3 -- does a better-stored table place learners better?
# Learners: abilities on 48 skills drawn with the relatedness found in ASSISTments.
# Session: each learner practises 12 randomly chosen skills in random order, 15 problems
# each. Within a skill every arm uses the same fixed staircase (step 0.20). Arms differ
# ONLY in where they start a new skill: from the levels reached on skills already
# practised, weighted by the stored relatedness table,
#     start_j = sum_k rho_jk^3 * b_k / sum_k rho_jk^2        (0 if nothing practised yet)
# Outcome: distance between difficulty and ability (logits) on the first 5 problems of
# each new skill (where the starting point matters) and over the whole session.
# Common random numbers across arms.
# =============================================================================
set.seed(2026); C <- readRDS("out/compressed.rds"); S <- readRDS("out/skill_structure.rds")$S
K <- nrow(S); N <- 3000L; NS <- 12L; NT <- 15L; STEP <- 0.20
TH <- matrix(rnorm(N * K), N, K) %*% chol(S)
SK <- t(replicate(N, sample.int(K, NS))); U <- array(runif(N * NS * NT), c(N, NS, NT))
arms <- c(list(none = NULL), lapply(C$out, `[[`, "R"))
run <- function(R) { first <- all <- numeric(N)
  for (i in 1:N) { b_end <- numeric(0); done <- integer(0); e1 <- 0; ea <- 0
    for (s in 1:NS) { j <- SK[i, s]; th <- TH[i, j]
      b <- if (is.null(R) || !length(done)) 0 else { r <- R[j, done]; den <- sum(r^2); if (den < 1e-8) 0 else sum(r^3 * b_end) / den }
      for (t in 1:NT) { err <- abs(b - th); ea <- ea + err; if (s > 1 && t <= 5) e1 <- e1 + err
        b <- b + STEP * (2 * (U[i, s, t] < plogis(th - b)) - 1) }
      done <- c(done, j); b_end <- c(b_end, b) }
    first[i] <- e1 / ((NS - 1) * 5); all[i] <- ea / (NS * NT) }
  cbind(first = first, all = all) }
res <- lapply(arms, run)
ci <- function(x) { m <- mean(x); h <- 1.96 * sd(x) / sqrt(length(x)); sprintf("%.3f [%.3f, %.3f]", m, m - h, m + h) }
bytes <- c(none = 0, sapply(C$out, `[[`, "bytes")); r2 <- c(none = NA, sapply(C$out, `[[`, "r2"))
tab <- data.frame(scheme = names(arms), bytes = bytes[names(arms)], table_R2 = round(r2[names(arms)], 3),
  start_of_new_skill = sapply(res, function(m) ci(m[, "first"])), whole_session = sapply(res, function(m) ci(m[, "all"])),
  first_num = sapply(res, function(m) mean(m[, "first"])))
tab <- tab[order(tab$bytes), ]; print(tab[, 1:5], row.names = FALSE)
d <- function(a, b) ci(res[[a]][, "first"] - res[[b]][, "first"])
cat("\npaired differences at the start of a new skill (negative = first is better):\n")
for (p in list(c("fractal", "prng"), c("fractal", "prng_equal_bytes"), c("fractal", "blockmean"), c("fractal", "lowrank1"), c("fractal", "lowrank10"),
               c("fractal", "quant4"), c("fractal_rec", "lowrank1"), c("fractal_rec", "constant"), c("full", "none"), c("constant", "none"), c("fractal", "full")))
  cat(sprintf("  %-12s vs %-17s %s\n", p[1], p[2], d(p[1], p[2])))
write.csv(tab[, 1:5], "out/table_multiskill.csv", row.names = FALSE); saveRDS(res, "out/sim_multiskill.rds")
suppressMessages(library(ggplot2))
tab$family <- ifelse(grepl("fractal", tab$scheme), "Fractal seeds", ifelse(grepl("prng", tab$scheme), "Pseudo-random seeds (plain twin)", "Conventional"))
p <- ggplot(tab[tab$scheme != "quant1", ], aes(pmax(bytes, 1), first_num, colour = family)) + geom_point(size = 3) +
  geom_text(aes(label = scheme), vjust = -1, size = 3, show.legend = FALSE) + scale_x_log10() +
  scale_colour_manual(values = c("Fractal seeds" = "#c0392b", "Pseudo-random seeds (plain twin)" = "#e08e0b", "Conventional" = "#555555")) +
  labs(x = "Bytes stored for the skill-relatedness table (log scale)", y = "Distance from the learner at the start of a new skill (logits; lower is better)",
       colour = NULL, title = "Multi-skill placement: quality against storage",
       subtitle = "48 skills, relatedness estimated from ASSISTments 2009-2010; 3,000 synthetic learners") +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom")
ggsave("out/fig_multiskill.png", p, width = 9.5, height = 6, dpi = 130)
