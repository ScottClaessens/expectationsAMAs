# fit model
fit_model <- function(data) {
  # generate formulas for brms
  formula <- " ~ 1 + order + (1 + order |i| id) + (1 + order |j| dilemma)"
  bf1 <- bf(as.formula(paste0("decision", formula)), family = cumulative)
  bf2 <- bf(as.formula(paste0("confidence", formula)), family = cumulative)
  bf3 <- bf(as.formula(paste0("understand", formula)), family = cumulative)
  # fit model
  brm(
    formula = bf1 + bf2 + bf3 + set_rescor(FALSE),
    data = data,
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
      prior(lkj(3), class = cor, group = id),
      prior(lkj(3), class = cor, group = dilemma)
    ),
    iter = 4000,
    warmup = 2000,
    chains = 4,
    cores = 4,
    seed = 2113
  )
}