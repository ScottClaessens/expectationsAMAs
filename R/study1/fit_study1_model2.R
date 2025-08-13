# function to fit model 2 to data from study 1
fit_study1_model2 <- function(study1_data, outcome = "likely_human") {
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
    data = study1_data,
    family = cumulative,
    prior = priors,
    control = list(adapt_delta = 0.99),
    cores = 4
  )
}
