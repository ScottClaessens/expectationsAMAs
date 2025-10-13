# function to fit model 1 to data from within-subjects study
fit_within_model1 <- function(within_data, outcome = "trust") {
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
    data = within_data,
    family = cumulative,
    prior = priors,
    cores = 4,
    seed = 2113
  )
}
