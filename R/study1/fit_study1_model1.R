# function to fit model 1 to data from study 1
fit_study1_model1 <- function(study1_data, outcome = "trust") {
  # wrangle data to long format
  data <-
    study1_data %>%
    pivot_longer(
      cols = trust_baseline:competence_overall,
      names_pattern = "(.*)_(.*)",
      names_to = c(".value", "time")
    )
  # get formula
  formula <- bf(
    as.formula(
      paste0(
        outcome,
        " ~ 1 + advisor_type * time * dilemma_type + (1 | id)",
        " + (1 + advisor_type * time | dilemma)"
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
    cores = 4
  )
}
