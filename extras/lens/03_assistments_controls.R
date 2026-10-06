# Study A2, matched control (same rule as in the simulation work: test the exotic
# measure against its plain twin). Plain twin of "fractal memory" = short memory:
#   lag-1 autocorrelation (does a slow answer tend to follow a slow answer?).
# (i)  Is alpha larger than what a short-memory AR(1) process with the same lag-1
#      autocorrelation would give?  (ii) Does alpha predict accuracy beyond lag-1?
source("common.R"); set.seed(2026)
d <- read.csv("../data/GKT/data/skill_builder_data.csv", stringsAsFactors = FALSE)
d <- d[!duplicated(d$order_id) & d$original == 1 & d$ms_first_response > 0, c("order_id", "user_id", "problem_id", "correct", "ms_first_response")]
d <- d[order(d$user_id, d$order_id), ]; d$lrt <- log(pmin(d$ms_first_response, 600000))
pm <- tapply(d$lrt, d$problem_id, median); pn <- table(d$problem_id)
d$adj <- d$lrt - ifelse(pn[as.character(d$problem_id)] >= 5, pm[as.character(d$problem_id)], median(d$lrt))
r0 <- read.csv("out/assistments_students.csv")
ex <- do.call(rbind, lapply(r0$user, function(u) { x <- d$adj[d$user_id == u]; x <- x[seq_len(min(length(x), 1024))]
  N <- length(x); bx <- unique(round(exp(seq(log(8), log(N / 4), length.out = 10))))
  ac <- acf(x, lag.max = 1, plot = FALSE)$acf[2]
  ar <- mean(replicate(20, dfa_alpha(as.numeric(arima.sim(list(ar = max(min(ac, 0.95), -0.95)), N)), bx)))
  F <- dfa_F(x, bx); fit <- lm(log(F) ~ log(bx))
  small <- coef(lm(log(F[1:5]) ~ log(bx[1:5])))[2]; large <- coef(lm(log(F[6:length(bx)]) ~ log(bx[6:length(bx)])))[2]
  data.frame(user = u, ac1 = ac, alpha_ar1 = ar, r2_scaling = summary(fit)$r.squared, slope_small = small, slope_large = large) }))
r <- merge(r0, ex, by = "user")
cat(sprintf("lag-1 autocorrelation: mean %.3f (sd %.3f)\n", mean(r$ac1), sd(r$ac1)))
cat(sprintf("alpha real %.3f | alpha of AR(1) twin %.3f | students above their AR(1) twin: %.1f%%\n",
    mean(r$alpha_adj), mean(r$alpha_ar1), 100 * mean(r$alpha_adj > r$alpha_ar1)))
tt <- t.test(r$alpha_adj - r$alpha_ar1); cat(sprintf("real minus AR(1) twin: %.3f [%.3f, %.3f]\n", tt$estimate, tt$conf.int[1], tt$conf.int[2]))
cat(sprintf("straightness of the scaling line (R2): median %.3f | slope at small windows %.3f, at large windows %.3f\n",
    median(r$r2_scaling), mean(r$slope_small), mean(r$slope_large)))
cat(sprintf("Spearman accuracy: with lag-1 = %.3f, with alpha = %.3f; alpha vs lag-1 = %.3f\n",
    cor(r$ac1, r$acc, method = "s"), cor(r$alpha_adj, r$acc, method = "s"), cor(r$alpha_adj, r$ac1, method = "s")))
b0 <- lm(acc ~ mean_lrt + sd_lrt + log(n), r); b1 <- update(b0, . ~ . + scale(ac1)); b2 <- update(b1, . ~ . + scale(alpha_adj)); b3 <- update(b0, . ~ . + scale(alpha_adj))
R2 <- function(m) summary(m)$r.squared
cat(sprintf("R2: baseline %.3f | + lag-1 %.3f | + alpha %.3f | + both %.3f\n", R2(b0), R2(b1), R2(b3), R2(b2)))
print(round(summary(b2)$coefficients[c("scale(ac1)", "scale(alpha_adj)"), ], 4))
# leave-one-out predictive check
loo <- function(f) { p <- sapply(seq_len(nrow(r)), function(i) predict(lm(f, r[-i, ]), r[i, ])); cor(p, r$acc)^2 }
cat(sprintf("leave-one-out R2: baseline %.3f | + lag-1 %.3f | + alpha %.3f | + both %.3f\n",
    loo(formula(b0)), loo(formula(b1)), loo(formula(b3)), loo(formula(b2))))
write.csv(r, "out/assistments_students.csv", row.names = FALSE)
suppressMessages(library(ggplot2))
p <- ggplot(r, aes(alpha_adj, acc)) + geom_point(alpha = 0.55, colour = "#1b6ca8") + geom_smooth(method = "lm", colour = "#c0392b", se = TRUE, formula = y ~ x) +
  geom_vline(xintercept = 0.5, linetype = 2, colour = "grey50") +
  labs(x = "Fractal exponent of the student's response-time series (0.5 = no memory)", y = "Proportion of problems answered correctly",
       title = "ASSISTments 2009-2010: students with more persistent response-time fluctuation answer less accurately",
       subtitle = sprintf("%d students with at least 256 main-problem responses; item difficulty removed from response times", nrow(r))) + theme_minimal(base_size = 11)
ggsave("out/fig_assistments_alpha_accuracy.png", p, width = 9.5, height = 5.5, dpi = 130)
