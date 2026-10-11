# Step 6 -- manuscript figures, drawn from the frozen results in out/.
#
#   Figure 1   distance from the learner over the session, six conditions
#   Figure 2   speed of recovery against precision, with the fixed-step curve
#   Figure S1  mean distance with 95% CI, all ten controllers, six conditions
#
# Run from the pfpw/ directory after steps 1 to 3:   Rscript R/06_figures.R
# Reads out/sim_results.rds and out/table_tradeoff.csv; runs no simulation.
# Every label a reader sees is set in the block below, so the figures stay in
# step with the manuscript. Nothing is written inside the image except axis
# text, panel names and the legend: titles belong in the figure captions.

suppressMessages({ library(ggplot2); library(ggrepel) })

# ---- labels (edit here, nowhere else) ---------------------------------------
ANONYMISED <- TRUE   # TRUE: review version. FALSE: restores the published name.
FIRST <- if (ANONYMISED) "First version" else "PFP-Core"

ARM <- c(PFPW      = "Fractal-seeded controller",
         GATE_X    = "Stored-weight twin",
         PFPW_FRZ  = "Frozen window",
         PFPW_BASE = "Unsearched seed",
         CAT       = "Adaptive test",
         CAT_F     = "Adaptive test, forgetting",
         STAIR     = "Fixed-step staircase (0.15)",
         PEST      = "PEST-type staircase",
         PFP_CORE  = FIRST,
         PFP_COREJ = paste(FIRST, "with reset"))

COND <- c(stationary = "Stable",
          slow       = "Slow learning",
          fast       = "Fast learning",
          coldstart  = "Unknown starting level",
          jump       = "Sudden jump",
          guessing   = "Guessing")

# ---- look -------------------------------------------------------------------
# Three hues that stay apart under colour-vision deficiency, plus a neutral
# grey for the fixed-step reference. Identity never rests on colour alone:
# lines also differ in type, points in shape.
BLUE <- "#2a78d6"; ORANGE <- "#eb6834"; AQUA <- "#1baf7a"; GREY <- "#52514e"
INK  <- "#0b0b0b"; INK2 <- "#52514e"; GRID <- "#e6e5e1"

theme_paper <- function(base = 9) theme_minimal(base_size = base) + theme(
  text = element_text(colour = INK), axis.text = element_text(colour = INK2),
  panel.grid.minor = element_blank(), panel.grid.major = element_line(colour = GRID, linewidth = 0.3),
  strip.text = element_text(face = "bold", hjust = 0, size = base),
  legend.position = "bottom", legend.title = element_blank(),
  legend.key.width = unit(28, "pt"), legend.margin = margin(0, 0, 0, 0),
  plot.margin = margin(6, 10, 4, 6))

save_fig <- function(p, name, w, h) {
  ggsave(file.path("out", paste0(name, ".png")), p, width = w, height = h, dpi = 600,
         device = ragg::agg_png, bg = "white")
  ggsave(file.path("out", paste0(name, ".pdf")), p, width = w, height = h, device = grDevices::cairo_pdf)
  cat("wrote out/", name, ".png and .pdf\n", sep = "")
}

ci <- function(x) { m <- mean(x); h <- qt(0.975, length(x) - 1) * sd(x) / sqrt(length(x)); c(m, m - h, m + h) }
R <- readRDS("out/sim_results.rds")

# ---- Figure 1: distance over the session ------------------------------------
arms1 <- c("PFPW", "CAT", "CAT_F", "STAIR")
tr <- do.call(rbind, lapply(names(COND), function(sn) do.call(rbind, lapply(arms1, function(an)
  data.frame(cond = COND[[sn]], arm = ARM[[an]], trial = seq_along(R$traj[[sn]][[an]]),
             dist = R$traj[[sn]][[an]])))))
tr$cond <- factor(tr$cond, levels = COND); tr$arm <- factor(tr$arm, levels = ARM[arms1])
p1 <- ggplot(tr, aes(trial, dist, colour = arm, linetype = arm, linewidth = arm)) +
  geom_line(lineend = "round") +
  facet_wrap(~cond, ncol = 2, scales = "free_y") +
  scale_colour_manual(values = setNames(c(BLUE, ORANGE, AQUA, GREY), ARM[arms1])) +
  scale_linetype_manual(values = setNames(c("solid", "solid", "42", "12"), ARM[arms1])) +
  scale_linewidth_manual(values = setNames(c(0.9, 0.55, 0.55, 0.6), ARM[arms1])) +
  scale_x_continuous(breaks = c(1, 30, 60, 90, 120)) +
  labs(x = "Problem in session", y = "Mean distance between task difficulty and ability (logits)") +
  theme_paper() + guides(colour = guide_legend(nrow = 2, byrow = TRUE))
save_fig(p1, "figure_1_distance_over_session", 7.2, 7.6)

# ---- Figure 2: recovery against precision -----------------------------------
tt <- read.csv("out/table_tradeoff.csv", stringsAsFactors = FALSE)
fam <- tt[!is.na(tt$step), ]; fam <- fam[order(fam$recover), ]
pts <- data.frame(key = c("PFPW", "GATE_X", "PEST", "CAT", "CAT_F"), stringsAsFactors = FALSE)
pts$precision <- sapply(pts$key, function(a) mean(R$res$stationary[[a]][, "mae"]))
pts$recover   <- sapply(pts$key, function(a) mean(R$res$jump[[a]][, "t_reacquire"]))
pts$label <- sub(" staircase", " rule", ARM[pts$key])
# label offsets, chosen by eye so that no label sits on the curve (x in log10 units)
NUDGE <- rbind(PFPW = c(-0.10, -0.062), GATE_X = c(0.00, 0.060), PEST = c(0.13, 0.028),
               CAT_F = c(0.03, 0.045), CAT = c(-0.07, 0.042)); colnames(NUDGE) <- c("x", "y")
G <- c("Fractal-seeded controller", "Other estimation-free rules", "Adaptive tests", "Fixed-step staircases")
pts$group <- factor(c(G[1], G[2], G[2], G[3], G[3]), levels = G)
fam$group <- factor(G[4], levels = G); fam$label <- sprintf("%.2f", fam$step)
p2 <- ggplot(mapping = aes(recover, precision)) +
  geom_line(data = fam, colour = GREY, linewidth = 0.5) +
  geom_point(data = fam, aes(colour = group, shape = group), size = 1.9) +
  geom_text(data = fam, aes(label = label), size = 2.5, colour = INK2, vjust = 1.9, hjust = 1.05) +
  geom_point(data = pts, aes(colour = group, shape = group, size = group)) +
  geom_text_repel(data = pts, aes(label = label), size = 2.9, colour = INK, seed = 1, force = 0,
                  min.segment.length = 0, segment.colour = INK2, segment.size = 0.25, point.padding = 0.3,
                  nudge_x = NUDGE[pts$key, "x"], nudge_y = NUDGE[pts$key, "y"]) +
  scale_colour_manual(values = setNames(c(BLUE, AQUA, ORANGE, GREY), G), drop = FALSE) +
  scale_shape_manual(values = setNames(c(16, 17, 15, 1), G), drop = FALSE) +
  scale_size_manual(values = setNames(c(3.4, 2.4, 2.4, 1.9), G), drop = FALSE, guide = "none") +
  scale_x_log10(breaks = c(5, 10, 20, 30, 50)) +
  scale_y_continuous(limits = c(0.22, 0.64), breaks = seq(0.3, 0.6, 0.1)) +
  labs(x = "Trials to recover after a sudden jump (log scale; left is faster)",
       y = "Mean distance, stable condition (logits; lower is closer)") +
  theme_paper() + guides(colour = guide_legend(nrow = 2, byrow = TRUE, override.aes = list(size = 2.6)))
save_fig(p2, "figure_2_recovery_precision", 7.2, 4.9)

# ---- Figure S1: mean distance, all controllers ------------------------------
ord <- c("CAT", "CAT_F", "STAIR", "PEST", "GATE_X", "PFPW", "PFPW_FRZ", "PFPW_BASE", "PFP_CORE", "PFP_COREJ")
F3 <- c("Estimates ability", "Estimation-free rules", "Fractal-seeded controller and its variants", FIRST)
fam_of <- function(a) if (a %in% c("CAT", "CAT_F")) F3[1] else if (grepl("^PFPW", a)) F3[3] else
  if (grepl("^PFP_CORE", a)) F3[4] else F3[2]
al <- do.call(rbind, lapply(names(COND), function(sn) do.call(rbind, lapply(ord, function(an) {
  v <- ci(R$res[[sn]][[an]][, "mae"])
  data.frame(cond = COND[[sn]], arm = ARM[[an]], group = fam_of(an), m = v[1], lo = v[2], hi = v[3]) }))))
al$cond <- factor(al$cond, levels = COND); al$arm <- factor(al$arm, levels = rev(ARM[ord]))
al$group <- factor(al$group, levels = F3)
p3 <- ggplot(al, aes(m, arm, colour = group, shape = group)) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.3, linewidth = 0.4) + geom_point(size = 1.9) +
  facet_wrap(~cond, ncol = 2, scales = "free_x") +
  scale_colour_manual(values = setNames(c(ORANGE, GREY, BLUE, AQUA), F3)) +
  scale_shape_manual(values = setNames(c(15, 1, 16, 17), F3)) +
  labs(x = "Mean distance between task difficulty and ability (logits; lower is closer; bars: 95% CI)", y = NULL) +
  theme_paper() + theme(panel.grid.major.y = element_blank()) +
  guides(colour = guide_legend(nrow = 2, byrow = TRUE))
save_fig(p3, "figure_S1_distance_all_controllers", 7.2, 8.2)
