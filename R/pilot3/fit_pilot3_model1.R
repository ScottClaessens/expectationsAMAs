# fit model 1
fit_pilot3_model1 <- function(pilot3_data) {
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
  bf01 <- generate_formula("trust_baseline")
  bf02 <- generate_formula("trust_other_issues_baseline")
  bf03 <- generate_formula("empathy_baseline")
  bf04 <- generate_formula("competency_baseline")
  bf05 <- generate_formula("trust_overall")
  bf06 <- generate_formula("trust_other_issues_overall")
  bf07 <- generate_formula("empathy_overall")
  bf08 <- generate_formula("competency_overall")
  bf09 <- generate_formula("likely_human")
  bf10 <- generate_formula("surprised_AI")
  # fit model
  brm(
    formula = bf01 + bf02 + bf03 + bf04 + bf05 + 
      bf06 + bf07 + bf08 + bf09 + bf10 + set_rescor(FALSE),
    data = pilot3_data,
    prior = c(
      prior(normal(0, 1), class = b, resp = trustbaseline),
      prior(normal(0, 1), class = b, resp = trustotherissuesbaseline),
      prior(normal(0, 1), class = b, resp = empathybaseline),
      prior(normal(0, 1), class = b, resp = competencybaseline),
      prior(normal(0, 1), class = b, resp = trustoverall),
      prior(normal(0, 1), class = b, resp = trustotherissuesoverall),
      prior(normal(0, 1), class = b, resp = empathyoverall),
      prior(normal(0, 1), class = b, resp = competencyoverall),
      prior(normal(0, 1), class = b, resp = likelyhuman),
      prior(normal(0, 1), class = b, resp = surprisedAI),
      prior(normal(0, 2), class = Intercept, resp = trustbaseline),
      prior(normal(0, 2), class = Intercept, resp = trustotherissuesbaseline),
      prior(normal(0, 2), class = Intercept, resp = empathybaseline),
      prior(normal(0, 2), class = Intercept, resp = competencybaseline),
      prior(normal(0, 2), class = Intercept, resp = trustoverall),
      prior(normal(0, 2), class = Intercept, resp = trustotherissuesoverall),
      prior(normal(0, 2), class = Intercept, resp = empathyoverall),
      prior(normal(0, 2), class = Intercept, resp = competencyoverall),
      prior(normal(0, 2), class = Intercept, resp = likelyhuman),
      prior(normal(0, 2), class = Intercept, resp = surprisedAI),
      prior(exponential(1), class = sd, resp = trustbaseline),
      prior(exponential(1), class = sd, resp = trustotherissuesbaseline),
      prior(exponential(1), class = sd, resp = empathybaseline),
      prior(exponential(1), class = sd, resp = competencybaseline),
      prior(exponential(1), class = sd, resp = trustoverall),
      prior(exponential(1), class = sd, resp = trustotherissuesoverall),
      prior(exponential(1), class = sd, resp = empathyoverall),
      prior(exponential(1), class = sd, resp = competencyoverall),
      prior(exponential(1), class = sd, resp = likelyhuman),
      prior(exponential(1), class = sd, resp = surprisedAI),
      prior(lkj(2), class = cor, group = id),
      prior(lkj(2), class = cor, group = dilemma)
    ),
    chains = 4,
    cores = 4,
    init = 0,
    iter = 3000,
    control = list(adapt_delta = 0.9),
    seed = 2113
  )
}
