# function to fit model 1 to data from study 3
fit_study3_model1 <- function(study3_data, outcome = "trust", include) {
  # exclude data
  if (include == "with_exclusions") {
    study3_data <- exclude_study3_data(study3_data)
  }
  # get formula
  formula <- bf(
    as.formula(
      paste0(
        outcome,
        " ~ 1 + condition * advisor_type * dilemma_type + (1 | id)",
        " + (1 + condition * advisor_type | dilemma)"
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
    data = study3_data,
    family = cumulative,
    prior = priors,
    cores = 4,
    seed = 2113
  )
}
