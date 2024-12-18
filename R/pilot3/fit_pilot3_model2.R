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
      # non-normatively sensitive = norm_sens_2
      compare_trust_norm_sens2        = compare_trust_non_norm_sens,
      compare_likely_human_norm_sens2 = compare_likely_human_non_norm_sens
    ) %>%
    pivot_longer(
      cols = starts_with("compare_"),
      names_to = c(".value", "type"),
      names_pattern = "^(.*)_(cons_deon|cons_util|norm_sens1|norm_sens2)$"
    ) %>%
    transmute(
      id = id,
      dilemma = dilemma,
      advisor_type = advisor_types[type],
      compare_trust = compare_trust,
      compare_likely_human = compare_likely_human
      ) %>%
    pivot_longer(
      cols = compare_trust:compare_likely_human,
      names_to = "variable"
    )
  # fit model
  brm(
    formula = value ~ 1 + advisor_type*variable + (1 + variable | id) + 
      (1 + advisor_type*variable | dilemma),
    data = pilot3_data,
    family = cumulative(),
    prior = c(
      prior(normal(0, 1), class = b),
      prior(normal(0, 2), class = Intercept),
      prior(exponential(3), class = sd),
      prior(lkj(4), class = cor)
    ),
    chains = 4,
    cores = 4,
    init = 0,
    seed = 2113
  )
}
