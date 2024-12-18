# fit model 1
fit_pilot3_model1 <- function(pilot3_data) {
  # pivot data longer
  pilot3_data <-
    pilot3_data %>%
    pivot_longer(
      cols = trust_baseline:surprised_AI,
      names_to = "variable"
    )
  # fit model
  brm(
    formula = value ~ 1 + advisor_type*variable + (1 | id) + 
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
