# fit model 2
fit_pilot3_model2 <- function(pilot3_data) {
  # advisor types
  advisor_types <- c(
   "cons_deon"  = "ConsistentlyDeontological",
   "cons_util"  = "ConsistentlyUtilitarian",
   "norm_sens1" = "NormativelySensitive",
   "norm_sens2" = "NonNormativelySensitive"
  )
  # pivot data long
  pilot3_data <-
    pilot3_data %>%
    # naming of columns annoying for regex
    rename(
      # normatively sensitive = norm_sens_1
      compare_trust_norm_sens1        = compare_trust_norm_sens,
      compare_likely_human_norm_sens1 = compare_likely_human_norm_sens,
      rank_likely_human_norm_sens1    = rank_likely_human_norm_sens,
      # non-normatively sensitive = norm_sens_2
      compare_trust_norm_sens2        = compare_trust_non_norm_sens,
      compare_likely_human_norm_sens2 = compare_likely_human_non_norm_sens,
      rank_likely_human_norm_sens2    = rank_likely_human_non_norm_sens
    ) %>%
    pivot_longer(
      cols = starts_with("compare_") | starts_with("rank_"),
      names_to = c(".value", "type"),
      names_pattern = "^(.*)_(cons_deon|cons_util|norm_sens1|norm_sens2)$"
    ) %>%
    transmute(
      id = id,
      dilemma = dilemma,
      advisor_type = factor(advisor_types[type], levels = advisor_types),
      compare_trust = compare_trust,
      compare_likely_human = compare_likely_human,
      rank_likely_human = rank_likely_human
      )
  # generate formulas for brms
  generate_formula <- function(resp) {
    bf(
      as.formula(
        paste0(
          resp,
          " ~ 1 + advisor_type + (1 |i| id) + (1 + advisor_type |j| dilemma)"
        )
      ),
      family = cumulative
    )
  }
  bf1 <- generate_formula("compare_trust")
  bf2 <- generate_formula("compare_likely_human")
  bf3 <- generate_formula("rank_likely_human")
  # fit model
  brm(
    formula = bf1 + bf2 + bf3 + set_rescor(FALSE),
    data = pilot3_data,
    prior = c(
      prior(normal(0, 1), class = b, resp = comparetrust),
      prior(normal(0, 1), class = b, resp = comparelikelyhuman),
      prior(normal(0, 1), class = b, resp = ranklikelyhuman),
      prior(normal(0, 2), class = Intercept, resp = comparetrust),
      prior(normal(0, 2), class = Intercept, resp = comparelikelyhuman),
      prior(normal(0, 2), class = Intercept, resp = ranklikelyhuman),
      prior(exponential(3), class = sd, resp = comparetrust),
      prior(exponential(3), class = sd, resp = comparelikelyhuman),
      prior(exponential(3), class = sd, resp = ranklikelyhuman),
      prior(lkj(4), class = cor, group = id),
      prior(lkj(4), class = cor, group = dilemma)
    ),
    chains = 4,
    cores = 4,
    seed = 2113
  )
}
