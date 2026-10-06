# Step 3 -- speed vs precision. Is the gate better than ANY fixed-step staircase,
# or only better than the one step size (0.15) used in the main table?
source("R/werr_kernel.R"); Rcpp::sourceCpp("src/werr_kernel.cpp"); source("R/learning_gate.R")
source("R/controllers.R"); source("R/simulate.R"); suppressMessages(library(ggplot2))
R <- readRDS("out/sim_results.rds"); N <- R$N; T_len <- R$T_len
pops <- lapply(setNames(names(SCENARIOS), names(SCENARIOS)), function(sn)
  draw_population(SCENARIOS[[sn]], N, T_len, 910000L + match(sn, names(SCENARIOS))))
steps <- c(0.08, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50)
fam <- do.call(rbind, lapply(steps, function(s) { ctl <- make_staircase(s)
  r <- lapply(c("stationary", "jump", "coldstart"), function(sn) run_arm(ctl, SCENARIOS[[sn]], pops[[sn]], T_len)$metrics)
  data.frame(arm = sprintf("Fixed staircase, step %.2f", s), family = "Fixed staircase (step varied)", step = s,
             precision = mean(r[[1]][, "mae"]), recover = mean(r[[2]][, "t_reacquire"]), coldacq = mean(r[[3]][, "t_acquire"])) }))
lab <- c(CAT = "Adaptive test", CAT_F = "Adaptive test, forgetting", PEST = "PEST-type", GATE_X = "Stored-weight twin",
         PFPW = "LearningGate (fractal)", PFPW_FRZ = "Fractal, frozen", PFPW_BASE = "Fractal, unsearched seed",
         PFP_CORE = "Original PFP-Core")
oth <- do.call(rbind, lapply(names(lab), function(a) data.frame(arm = lab[[a]],
  family = if (grepl("PFPW", a)) "Fractal gate" else if (grepl("CAT", a)) "Adaptive test" else if (a == "PFP_CORE") "Original PFP-Core" else "Other estimation-free",
  step = NA, precision = mean(R$res$stationary[[a]][, "mae"]), recover = mean(R$res$jump[[a]][, "t_reacquire"]),
  coldacq = mean(R$res$coldstart[[a]][, "t_acquire"]))))
d <- rbind(fam, oth); write.csv(d, "out/table_tradeoff.csv", row.names = FALSE); print(d, digits = 3, row.names = FALSE)
# where does the gate sit relative to the staircase curve? interpolate the curve at the gate's recovery time
f <- approxfun(fam$recover, fam$precision); g <- oth[oth$arm == "LearningGate (fractal)", ]
cat(sprintf("\nGate: recovery %.2f trials, precision %.3f. Fixed staircase with the same recovery: precision %.3f\n",
            g$recover, g$precision, f(g$recover)))
f2 <- approxfun(fam$coldacq, fam$precision)
cat(sprintf("Cold start: gate acquires in %.2f trials; staircase with same acquisition has precision %.3f\n", g$coldacq, f2(g$coldacq)))
pd <- function(a, b, sc, m) { x <- R$res[[sc]][[a]][, m] - R$res[[sc]][[b]][, m]; ci(x) }
for (b in c("STAIR", "PEST", "GATE_X", "CAT")) { cat(sprintf("recovery gate - %-6s:", b)); print(round(pd("PFPW", b, "jump", "t_reacquire"), 2))
  cat(sprintf("cold acq gate - %-6s:", b)); print(round(pd("PFPW", b, "coldstart", "t_acquire"), 2)) }
p <- ggplot(d[d$family != "Original PFP-Core" | TRUE, ], aes(recover, precision)) +
  geom_line(data = fam, colour = "#555555", linewidth = 0.5) +
  geom_point(aes(colour = family), size = 2.6) +
  geom_text(aes(label = ifelse(is.na(step), arm, sprintf("%.2f", step))), size = 3, vjust = -0.9, check_overlap = FALSE) +
  scale_colour_manual(values = c("Fixed staircase (step varied)" = "#555555", "Fractal gate" = "#c0392b",
    "Adaptive test" = "#1b6ca8", "Other estimation-free" = "#2e8b57", "Original PFP-Core" = "#e08e0b")) +
  scale_x_log10() +
  labs(x = "Trials to recover after a sudden +1.5 logit jump (log scale; left is faster)",
       y = "Everyday precision: mean |b - theta| with stable ability (lower is better)", colour = NULL,
       title = "Speed of recovery against everyday precision",
       subtitle = "Grey line: fixed staircases with step sizes from 0.08 to 0.50. Below-left of the line is better than any fixed step.") +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom", panel.grid.minor = element_blank())
ggsave("out/fig_tradeoff.png", p, width = 9.5, height = 6.5, dpi = 130)
