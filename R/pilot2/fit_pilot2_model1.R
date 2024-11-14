# fit model 1
fit_pilot2_model1 <- function(pilot2_data) {
  # generate formulas for brms
  generate_formula <- function(resp) {
    bf(
      as.formula(
        paste0(
          resp,
          " ~ 1 + advisor_type + (1 |i| id) + (1 + advisor_type |j| dilemma)"
          )
      ),
      family = cumulative
    )
  }
  bf1 <- generate_formula("trust")
  bf2 <- generate_formula("trust_other_issues")
  bf3 <- generate_formula("empathy")
  bf4 <- generate_formula("competency")
  bf5 <- generate_formula("likely_human")
  bf6 <- generate_formula("surprised_AI")
  # fit model
  brm(
    formula = bf1 + bf2 + bf3 + bf4 + bf5 + bf6 + set_rescor(FALSE),
    data = pilot2_data,
    prior = c(
      prior(normal(0, 1), class = b, resp = trust),
      prior(normal(0, 1), class = b, resp = trustotherissues),
      prior(normal(0, 1), class = b, resp = empathy),
      prior(normal(0, 1), class = b, resp = competency),
      prior(normal(0, 1), class = b, resp = likelyhuman),
      prior(normal(0, 1), class = b, resp = surprisedAI),
      prior(normal(0, 2), class = Intercept, resp = trust),
      prior(normal(0, 2), class = Intercept, resp = trustotherissues),
      prior(normal(0, 2), class = Intercept, resp = empathy),
      prior(normal(0, 2), class = Intercept, resp = competency),
      prior(normal(0, 2), class = Intercept, resp = likelyhuman),
      prior(normal(0, 2), class = Intercept, resp = surprisedAI),
      prior(exponential(2), class = sd, resp = trust),
      prior(exponential(2), class = sd, resp = trustotherissues),
      prior(exponential(2), class = sd, resp = empathy),
      prior(exponential(2), class = sd, resp = competency),
      prior(exponential(2), class = sd, resp = likelyhuman),
      prior(exponential(2), class = sd, resp = surprisedAI),
      prior(lkj(3), class = cor, group = id),
      prior(lkj(3), class = cor, group = dilemma)
    ),
    chains = 4,
    cores = 4,
    init = 0,
    seed = 2113
  )
}