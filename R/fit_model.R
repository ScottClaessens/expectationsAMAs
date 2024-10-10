# fit model
fit_model <- function(data) {
  # function to generate formulas for brms
  generate_bf_formula <- function(outcome) {
    bf(
      formula = paste0(
        outcome, " ~ 1 + order + (1 + order |i| id) + (1 + order |j| dilemma)"
        ),
      family = cumulative
    )
  }
  bf1 <- generate_bf_formula(outcome = "decision")
  bf2 <- generate_bf_formula(outcome = "confidence")
  bf3 <- generate_bf_formula(outcome = "understand")
  # fit model
  brm(
    formula = bf1 + bf2 + bf3 + set_rescor(FALSE),
    data = data %>% slice(1:100), # to remove
    prior = c(
      prior(normal(0, 1), class = b, resp = decision),
      prior(normal(0, 1), class = b, resp = confidence),
      prior(normal(0, 1), class = b, resp = understand),
      prior(normal(0, 2), class = Intercept, resp = decision),
      prior(normal(0, 2), class = Intercept, resp = confidence),
      prior(normal(0, 2), class = Intercept, resp = understand),
      prior(exponential(2), class = sd, resp = decision),
      prior(exponential(2), class = sd, resp = confidence),
      prior(exponential(2), class = sd, resp = understand),
      prior(lkj(1), class = cor, group = id),
      prior(lkj(1), class = cor, group = dilemma)
    ),
    sample_prior = "only", # to remove
    cores = 4
  )
}