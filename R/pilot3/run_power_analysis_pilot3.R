# function to generate a new dataset from the fitted models in pilot 3
generate_new_data_pilot3 <- function(pilot3_fit1, n = 400) {
  # randomly assign participants to dilemmas and treatments
  dilemmas <- c("Bomb", "EnemySpy", "Hostage")
  treatments <- c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                  "NormativelySensitive", "NonNormativelySensitive")
  variables <- unique(pilot3_fit1$data$variable)
  d <- 
    tibble(
      id           = 1000 + 1:n, # new participants
      dilemma_type = "InstrumentalHarm",
      dilemma      = sample(dilemmas, n, replace = TRUE),
      advisor_type = sample(treatments, n, replace = TRUE)
    ) %>%
    expand_grid(variable = variables)
  # generate new outcome values from model 1
  p <-
    posterior_predict(
      object = pilot3_fit1,
      newdata = d,
      sample_new_levels = "gaussian",
      allow_new_levels = TRUE,
      ndraws = 1
    )
  # add to dataset
  bind_cols(d, as_tibble(p[1, ]))
}

# get posterior difference from CU
get_post_difference_pilot3 <- function(fit, variable, advisor_type) {
  # get fitted values
  f <- fitted(
    object = fit,
    newdata = data.frame(
      variable = variable,
      advisor_type = c("ConsistentlyUtilitarian", advisor_type)
      ),
    re_formula = NA,
    summary = FALSE
    )
  # convert from probabilities of each level to estimated means
  means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) means <- means + (f[, , i] * i)
  # return difference
  as.numeric(means[,1] - means[,2])
}

# function to run power analysis based on pilot 3 results
run_power_analysis_pilot3 <- function(pilot3_fit1, n = 50, sim_id = 1) {
  # for each simulation:
  tibble(sim_id = sim_id) %>%
    rowwise() %>%
    mutate(
      # 1. generate a dataset
      data = list(
        generate_new_data_pilot3(pilot3_fit1, n = n)
        ),
      # 2. fit the model
      fit = list(
        update(
          object = pilot3_fit1,
          newdata = data,
          chains = 1,
          cores = 1,
          iter = 800,
          init = 0,
          seed = 2113
          )
        ),
      # 3. get posterior differences
      # difference in trust between CD and CU
      diff_trust_CD = list(
        get_post_difference_pilot3(
          fit, "trust_baseline", "ConsistentlyDeontological"
        )
      ),
      # difference in trust between NS and CU
      diff_trust_NS = list(
        get_post_difference_pilot3(
          fit, "trust_baseline", "NormativelySensitive"
        )
      ),
      # difference in trust between NNS and CU
      diff_trust_NNS = list(
        get_post_difference_pilot3(
          fit, "trust_baseline", "NonNormativelySensitive"
        )
      ),
      # difference in human likelihood between CD and CU
      diff_human_CD = list(
        get_post_difference_pilot3(
          fit, "likely_human", "ConsistentlyDeontological"
        )
      ),
      # difference in human likelihood between NS and CU
      diff_human_NS = list(
        get_post_difference_pilot3(
          fit, "likely_human", "NormativelySensitive"
        )
      ),
      # difference in human likelihood between NNS and CU
      diff_human_NNS = list(
        get_post_difference_pilot3(
          fit, "likely_human", "NonNormativelySensitive"
        )
      )
    ) %>%
    # remove some columns
    select(!c(fit)) %>%
    # pivot longer
    pivot_longer(
      cols = starts_with("diff_"),
      names_to = "comparison",
      values_to = "post"
    ) %>%
    rowwise() %>%
    mutate(
      # extract summary stats
      Estimate = median(post),
      `Q2.5`   = quantile(post, 0.025),
      `Q97.5`  = quantile(post, 0.975),
      # do the 95% credible intervals for the differences exclude zero?
      sig = `Q97.5` < 0
    ) %>%
    # remove column
    select(!post)
}
