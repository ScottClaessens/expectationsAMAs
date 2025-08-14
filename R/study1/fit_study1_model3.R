# fit model 3 to study 1 data
fit_study1_model3 <- function(study1_data, outcome = "compare_trust") {
  # advisor types
  advisor_types <- c(
    "cons_deon"  = "ConsistentlyDeontological",
    "cons_util"  = "ConsistentlyUtilitarian",
    "norm_sens1" = "NormativelySensitive",
    "norm_sens2" = "NonNormativelySensitive"
  )
  # pivot data long
  data <-
    study1_data %>%
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
      dilemma_type, dilemma_type,
      advisor_type = advisor_types[type],
      compare_trust = compare_trust,
      compare_likely_human = compare_likely_human
    )
  # get formula
  formula <- bf(
    as.formula(
      paste0(
        outcome,
        " ~ 1 + advisor_type * dilemma_type + (1 | id)",
        " + (1 + advisor_type | dilemma)"
      )
    )
  )
  # set priors
  priors <- c(
    prior(normal(0, 1), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(lkj(1), class = cor)
  )
  # fit model
  brm(
    formula = formula,
    data = data,
    family = cumulative,
    prior = priors,
    cores = 4,
    seed = 2113
  )
}
