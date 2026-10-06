# =============================================================================
# Study 1 replay, step 1 -- what do real practice sequences look like?
# Data: ASSISTments 2009-2010 skill builder; main problems; one row per response x skill.
# A "sequence" = one student practising one skill, in the order answered.
# Model (additive-factors type, mixed logistic regression):
#   logit P(correct) = student + skill + (student x skill) + rate_skill * (opportunity - 1)
#     student            ~ N(0, sd_student)        overall level of the student
#     skill              ~ N(0, sd_skill)          easiness of the skill
#     student x skill    ~ N(0, sd_pair)           how far THIS student is from the
#                                                  expected level on THIS skill
#     rate_skill         ~ N(mean_rate, sd_rate)   learning per practice opportunity
# Only the first 15 opportunities of each sequence are used, because in this
# mastery-based system successful students leave a skill early, and later
# opportunities over-represent students who are struggling.
# =============================================================================
suppressMessages(library(lme4)); set.seed(2026)
d <- read.csv("../data/GKT/data/skill_builder_data.csv", stringsAsFactors = FALSE)
d <- d[d$original == 1 & !is.na(d$skill_id), c("order_id", "user_id", "skill_id", "correct")]
d <- d[!duplicated(d[, c("order_id", "skill_id")]), ]; d <- d[order(d$user_id, d$skill_id, d$order_id), ]
d$seq <- paste(d$user_id, d$skill_id); d$opp <- ave(d$correct, d$seq, FUN = seq_along)
len <- as.integer(table(d$seq))
cat(sprintf("responses %d | students %d | skills %d | sequences %d\n", nrow(d), length(unique(d$user_id)), length(unique(d$skill_id)), length(len)))
cat("sequence length (problems per student per skill): quantiles\n"); print(quantile(len, c(.1, .25, .5, .75, .9, .95, .99)))
cat(sprintf("share of sequences with 3 or fewer problems: %.1f%% | with 5 or more: %.1f%% | with 20 or more: %.1f%%\n",
    100 * mean(len <= 3), 100 * mean(len >= 5), 100 * mean(len >= 20)))
cat("observed accuracy by opportunity (sequences of 5 or more):\n")
ok5 <- d$seq %in% names(table(d$seq))[table(d$seq) >= 5]; print(round(tapply(d$correct[ok5 & d$opp <= 10], d$opp[ok5 & d$opp <= 10], mean), 3))
f <- d[d$opp <= 15, ]; f$o <- f$opp - 1
keep <- names(which(table(f$skill_id) >= 500)); f <- f[f$skill_id %in% keep, ]
t0 <- proc.time()[["elapsed"]]
m <- glmer(correct ~ o + (1 | user_id) + (1 + o || skill_id) + (1 | seq), f, binomial, nAGQ = 0,
           control = glmerControl(calc.derivs = FALSE))
cat(sprintf("fitted on %d responses, %d skills, in %.0f s\n", nrow(f), length(keep), proc.time()[["elapsed"]] - t0))
vc <- as.data.frame(VarCorr(m)); print(vc[, c("grp", "var1", "sdcor")], digits = 3)
sdof <- function(g, v = "(Intercept)") vc$sdcor[vc$grp == g & vc$var1 %in% v][1]
par <- list(mean_rate = unname(fixef(m)["o"]), sd_rate = vc$sdcor[grepl("skill_id", vc$grp) & vc$var1 %in% "o"],
            sd_student = sdof("user_id"), sd_pair = sdof("seq"),
            sd_skill = vc$sdcor[grepl("skill_id", vc$grp) & vc$var1 %in% "(Intercept)"], lengths = len[len >= 5])
saveRDS(par, "out/learner_model.rds")
cat(sprintf("\nlearning per opportunity (logits): mean %.3f, sd across skills %.3f; skills with a negative fitted rate: %.0f%%\n",
    par$mean_rate, par$sd_rate, 100 * pnorm(0, par$mean_rate, par$sd_rate)))
cat(sprintf("student sd %.2f | student-by-skill sd %.2f | skill sd %.2f\n", par$sd_student, par$sd_pair, par$sd_skill))
cat(sprintf("=> a new sequence starts on average %.2f logits away from what the student's overall level predicts,\n   and %.2f logits away if nothing is known about the student\n",
    par$sd_pair * sqrt(2 / pi), sqrt(par$sd_student^2 + par$sd_pair^2) * sqrt(2 / pi)))
saveRDS(par, "out/learner_model.rds")
