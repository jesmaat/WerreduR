# Step 2 -- tables, non-inferiority tests and figures from out/sim_results.rds
source("R/simulate.R"); suppressMessages(library(ggplot2))
R <- readRDS("out/sim_results.rds"); lat <- readRDS("out/latency.rds"); ss <- readRDS("out/seed_search.rds")
NI_MARGIN <- 0.10     # logits of mean |b - theta|; MUST be fixed in the pre-registration
labels <- c(CAT = "CAT 0.5 (EAP, reference)", CAT_F = "CAT 0.5 (EAP, forgetting)",
            STAIR = "Staircase = Elo (0.15)", PEST = "PEST-type staircase",
            GATE_X = "Explicit gate (stored weights)", PFPW = "PFP-W LearningGate",
            PFPW_FRZ = "PFP-W frozen", PFPW_BASE = "PFP-W unsearched seed",
            PFP_CORE = "Original PFP-Core", PFP_COREJ = "Original PFP-Core+J")
fmt <- function(v) sprintf("%.3f [%.3f, %.3f]", v[1], v[2], v[3])

rows <- list(); ni <- list()
for (sn in names(R$res)) for (an in names(R$res[[sn]])) {
  m <- R$res[[sn]][[an]]
  rows[[length(rows) + 1]] <- data.frame(scenario = SCENARIOS[[sn]]$label, arm = labels[[an]],
    mae = fmt(ci(m[, "mae"])), corridor = fmt(ci(m[, "corridor"])),
    frustration = sprintf("%.3f", mean(m[, "frustr"])), boredom = sprintf("%.3f", mean(m[, "boredom"])),
    trials_to_acquire = sprintf("%.1f", mean(m[, "t_acquire"])),
    mean_P = sprintf("%.3f", mean(m[, "p_mean"])), gain = sprintf("%.3f", mean(m[, "gain"])),
    acquire_ci = fmt(ci(m[, "t_acquire"])), max_fail_run = sprintf("%.2f", mean(m[, "max_fail_run"])),
    reacquire_ci = if (sn == "jump") fmt(ci(m[, "t_reacquire"])) else "",
    mae_num = mean(m[, "mae"]), lo = ci(m[, "mae"])[[2]], hi = ci(m[, "mae"])[[3]], key = an, sc = sn)
  for (ref in c("CAT", "GATE_X", "STAIR", "PFP_CORE")) if (an %in% c("PFPW", "PFPW_FRZ", "PFPW_BASE") ||
                                              (ref == "CAT" && an != "CAT")) {
    if (an == ref) next
    d <- ci(m[, "mae"] - R$res[[sn]][[ref]][, "mae"])
    ni[[length(ni) + 1]] <- data.frame(scenario = SCENARIOS[[sn]]$label, arm = labels[[an]],
      versus = labels[[ref]], diff_mae = fmt(d),
      verdict = if (d[[3]] < 0) "better" else if (d[[2]] > NI_MARGIN) "inferior (beyond margin)"
                else if (d[[3]] < NI_MARGIN) "non-inferior" else "inconclusive", stringsAsFactors = FALSE)
  }
}
tab <- do.call(rbind, rows); nit <- do.call(rbind, ni)
write.csv(tab[, 1:12], "out/table_metrics.csv", row.names = FALSE)
write.csv(nit, "out/table_noninferiority.csv", row.names = FALSE)
write.csv(data.frame(arm = labels[names(lat)], microseconds_per_decision = round(lat, 1),
          persistent_state = c("121-point posterior", "121-point posterior", "1 number", "3 numbers",
            "4 weights + 6 numbers", "24-byte seed + 6 numbers", "24-byte seed + 6 numbers", "24-byte seed + 6 numbers",
            "1 complex number", "1 complex number + counter")),
          "out/table_latency.csv", row.names = FALSE)

tab$arm <- factor(tab$arm, levels = rev(labels)); tab$scenario <- factor(tab$scenario, levels = unique(tab$scenario))
tab$family <- ifelse(tab$key %in% c("CAT", "CAT_F"), "CAT (estimates ability)",
               ifelse(grepl("PFPW", tab$key), "Fractal gate",
               ifelse(grepl("PFP_CORE", tab$key), "Original PFP (2026 manuscript)", "Model-free, non-fractal")))
p1 <- ggplot(tab, aes(mae_num, arm, colour = family)) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.25) + geom_point(size = 2) +
  facet_wrap(~scenario, ncol = 2, scales = "free_x") +
  scale_colour_manual(values = c("CAT (estimates ability)" = "#1b6ca8", "Fractal gate" = "#c0392b",
                                 "Model-free, non-fractal" = "#555555", "Original PFP (2026 manuscript)" = "#e08e0b")) +
  labs(x = "Mean task-ability distance |b - theta| (logits; lower is better; 95% CI)", y = NULL, colour = NULL,
       title = "Alignment with the learner, by scenario and controller",
       subtitle = sprintf("N = %d synthetic learners per scenario, T = %d trials, paired seeds", R$N, R$T_len)) +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom", panel.grid.minor = element_blank())
ggsave("out/fig_alignment.png", p1, width = 10, height = 9, dpi = 130)

tr <- do.call(rbind, lapply(names(R$traj), function(sn) do.call(rbind, lapply(
  c("CAT", "CAT_F", "STAIR", "GATE_X", "PFPW"), function(an)
    data.frame(scenario = SCENARIOS[[sn]]$label, arm = labels[[an]], t = seq_along(R$traj[[sn]][[an]]),
               err = R$traj[[sn]][[an]])))))
tr$scenario <- factor(tr$scenario, levels = unique(tr$scenario))
p2 <- ggplot(tr, aes(t, err, colour = arm)) + geom_line(linewidth = 0.6) + facet_wrap(~scenario, ncol = 2, scales = "free_y") +
  labs(x = "Trial", y = "Mean |b - theta| (logits)", colour = NULL, title = "Tracking error over time") +
  theme_minimal(base_size = 11) + theme(legend.position = "bottom", panel.grid.minor = element_blank()) +
  guides(colour = guide_legend(nrow = 2))
ggsave("out/fig_trajectories.png", p2, width = 10, height = 9, dpi = 130)
cat("seed:", sprintf("%.16f", ss$res$seed), " gate loss:", ss$res$loss, "\n")
print(tab[, c("scenario", "arm", "mae", "corridor", "trials_to_acquire", "mean_P")], row.names = FALSE)
print(nit, row.names = FALSE); print(read.csv("out/table_latency.csv"), row.names = FALSE)
