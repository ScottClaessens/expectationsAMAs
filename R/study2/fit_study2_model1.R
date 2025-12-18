# function to fit model 1 to data from within-subjects study
fit_study2_model1 <- function(study2_data, outcome = "trust", include) {
  # exclude data
  if (include == "with_exclusions") {
    study2_data <- exclude_study2_data(study2_data)
  }
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
    data = study2_data,
    family = cumulative,
    prior = priors,
    cores = 4,
    seed = 2113
  )
}
