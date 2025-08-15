# fit model 4 to study 1 data
fit_study1_model4 <- function(study1_data) {
  # advisor types
  advisor_types <- c(
    "cons_deon"     = "ConsistentlyDeontological",
    "cons_util"     = "ConsistentlyUtilitarian",
    "norm_sens"     = "NormativelySensitive",
    "non_norm_sens" = "NonNormativelySensitive"
  )
  # pivot data long
  data <-
    study1_data %>%
    pivot_longer(
      cols = starts_with("rank_"),
      names_to = "type",
      names_pattern = "rank_likely_human_(.*)",
      values_to = "rank_likely_human"
    ) %>%
    transmute(
      id = id,
      dilemma = dilemma,
      dilemma_type, dilemma_type,
      advisor_type = advisor_types[type],
      rank_likely_human = rank_likely_human
    )
  # get formula
  formula <- bf(
    rank_likely_human ~ 1 + advisor_type * dilemma_type + (1 | id) + 
      (1 + advisor_type | dilemma)
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
