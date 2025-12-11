# function to generate a new dataset from the fitted models in study 2
generate_new_data_study2 <- function(study2_fit1_trust, n) {
  # randomly assign participants to dilemmas
  dilemmas <- c("Bomb", "EnemySpy", "Hostage", 
                "Donation", "Marathon", "Volunteering")
  d <- 
    tibble(
      id = 10000 + 1:n, # new participants
      dilemma = sample(dilemmas, n, replace = TRUE)
    ) %>%
    mutate(
      dilemma_type = ifelse(
        dilemma %in% dilemmas[1:3],
        "InstrumentalHarm",
        "ImpartialBeneficence"
      )
    ) %>%
    # participants see all four advisors
    expand_grid(
      advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                       "NormativelySensitive", "NonNormativelySensitive")
    )
  # generate new outcome values from model
  p <-
    posterior_predict(
      object = study2_fit1_trust,
      newdata = d,
      sample_new_levels = "gaussian",
      allow_new_levels = TRUE,
      ndraws = 1
    )
  # add to dataset
  bind_cols(d, tibble(trust = p[1, ]))
}

# get posterior difference in trust between advisor types
get_post_difference_study2 <- function(fit, advisor1, advisor2, dilemma) {
  # get fitted values
  f <- fitted(
    object = fit,
    newdata = data.frame(
      dilemma_type = "InstrumentalHarm",
      advisor_type = c(advisor1, advisor2),
      dilemma = dilemma
    ),
    re_formula = ~ 1 + (1 + advisor_type | dilemma),
    summary = FALSE
  )
  # convert from probabilities of each level to estimated means
  means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) means <- means + (f[, , i] * i)
  # return difference
  as.numeric(means[,1] - means[,2])
}

# function to run power analysis based on study 2 results
run_power_analysis_study2 <- function(study2_fit1_trust, power_model_study2,
                                      n = 20, sim_id = 1) {
  # for each simulation:
  tibble(sim_id = sim_id) %>%
    rowwise() %>%
    mutate(
      # 1. generate a dataset
      data = list(generate_new_data_study2(study2_fit1_trust, n = n)),
      # 2. fit the model
      fit = list(
        update(
          object = power_model_study2,
          newdata = data,
          chains = 1,
          cores = 1,
          iter = 800,
          backend = "cmdstanr",
          seed = 1
        )
      ),
      # 3. get posterior differences
      # difference in trust between CD and CU in Bomb dilemma
      diff_Bomb_CD_CU = list(
        get_post_difference_study2(
          fit, "ConsistentlyDeontological", "ConsistentlyUtilitarian", "Bomb"
        )
      ),
      # difference in trust between CD and NS in Bomb dilemma
      diff_Bomb_CD_NS = list(
        get_post_difference_study2(
          fit, "ConsistentlyDeontological", "NormativelySensitive", "Bomb"
        )
      ),
      # difference in trust between CU and NS in Bomb dilemma
      diff_Bomb_CU_NS = list(
        get_post_difference_study2(
          fit, "ConsistentlyUtilitarian", "NormativelySensitive", "Bomb"
        )
      ),
      # difference in trust between CD and CU in EnemySpy dilemma
      diff_EnemySpy_CD_CU = list(
        get_post_difference_study2(
          fit, "ConsistentlyDeontological", "ConsistentlyUtilitarian", 
          "EnemySpy"
        )
      ),
      # difference in trust between CD and NS in EnemySpy dilemma
      diff_EnemySpy_CD_NS = list(
        get_post_difference_study2(
          fit, "ConsistentlyDeontological", "NormativelySensitive", "EnemySpy"
        )
      ),
      # difference in trust between CU and NS in EnemySpy dilemma
      diff_EnemySpy_CU_NS = list(
        get_post_difference_study2(
          fit, "ConsistentlyUtilitarian", "NormativelySensitive", "EnemySpy"
        )
      ),
      # difference in trust between CD and CU in Hostage dilemma
      diff_Hostage_CD_CU = list(
        get_post_difference_study2(
          fit, "ConsistentlyDeontological", "ConsistentlyUtilitarian", "Hostage"
        )
      ),
      # difference in trust between CD and NS in Hostage dilemma
      diff_Hostage_CD_NS = list(
        get_post_difference_study2(
          fit, "ConsistentlyDeontological", "NormativelySensitive", "Hostage"
        )
      ),
      # difference in trust between CU and NS in Hostage dilemma
      diff_Hostage_CU_NS = list(
        get_post_difference_study2(
          fit, "ConsistentlyUtilitarian", "NormativelySensitive", "Hostage"
        )
      )
    ) %>%
    # remove some columns
    select(!c(data, fit)) %>%
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
      sig = (`Q2.5` > 0 && `Q97.5` > 0) || (`Q2.5` < 0 && `Q97.5` < 0)
    ) %>%
    # remove column
    select(!post)
}
