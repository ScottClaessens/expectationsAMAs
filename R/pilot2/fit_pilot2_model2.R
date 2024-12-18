# fit model 2
fit_pilot2_model2 <- function(pilot2_data) {
  # pivot data longer
  pilot2_data <-
    pilot2_data %>%
    pivot_longer(
      cols = trust:surprised_AI,
      names_to = "variable"
    )
  # fit model
  brm(
    formula = value ~ 1 + advisor_type*variable*dilemma_type + (1 | id) + 
      (1 + advisor_type*variable | dilemma),
    data = pilot2_data,
    family = cumulative(),
    prior = c(
      prior(normal(0, 1), class = b),
      prior(normal(0, 2), class = Intercept),
      prior(exponential(2), class = sd),
      prior(lkj(3), class = cor)
    ),
    chains = 4,
    cores = 4,
    init = 0,
    seed = 2113
  )
}
