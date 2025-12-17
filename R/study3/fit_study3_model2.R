# function to fit model 2 to data from study 3
fit_study3_model2 <- function(study3_data) {
  # one participant per row
  study3_data <-
    study3_data |>
    group_by(id) |>
    summarise(
      advisor_choice = unique(advisor_choice),
      condition      = unique(condition),
      dilemma_type   = unique(dilemma_type),
      dilemma        = unique(dilemma)
    )
  # set priors
  priors <- c(
    prior(normal(0, 1), class = Intercept, dpar = muConsistentlyUtilitarian),
    prior(normal(0, 1), class = Intercept, dpar = muNonNormativelySensitive),
    prior(normal(0, 1), class = Intercept, dpar = muNormativelySensitive),
    prior(normal(0, 1), class = b, dpar = muConsistentlyUtilitarian),
    prior(normal(0, 1), class = b, dpar = muNonNormativelySensitive),
    prior(normal(0, 1), class = b, dpar = muNormativelySensitive),
    prior(exponential(2), class = sd, dpar = muConsistentlyUtilitarian),
    prior(exponential(2), class = sd, dpar = muNonNormativelySensitive),
    prior(exponential(2), class = sd, dpar = muNormativelySensitive),
    prior(lkj(1), class = cor)
  )
  # fit model
  brm(
    formula = advisor_choice ~ 1 + condition * dilemma_type + 
      (1 + condition | dilemma),
    data = study3_data,
    family = categorical,
    prior = priors,
    cores = 4,
    seed = 2113
  )
}
