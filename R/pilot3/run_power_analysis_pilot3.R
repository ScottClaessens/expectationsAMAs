# function to generate a new dataset from the fitted models in pilot 3
generate_new_data_pilot3 <- function(pilot3_fit1, n = 400) {
  # randomly assign participants to dilemmas and treatments
  dilemmas <- c("Bomb", "EnemySpy", "Hostage")
  treatments <- c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                  "NormativelySensitive", "NonNormativelySensitive")
  d <- 
    tibble(
      id           = 1000 + 1:n, # new participants
      dilemma_type = "InstrumentalHarm",
      dilemma      = sample(dilemmas, n, replace = TRUE),
      advisor_type = sample(treatments, n, replace = TRUE)
    )
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
  bind_cols(d, as_tibble(p[1, , ])) %>%
    # rename columns to match original dataset
    rename(
      trust_baseline              = trustbaseline,
      trust_other_issues_baseline = trustotherissuesbaseline,
      empathy_baseline            = empathybaseline,
      competency_baseline         = competencybaseline,
      trust_overall               = trustoverall,
      trust_other_issues_overall  = trustotherissuesoverall,
      empathy_overall             = empathyoverall,
      competency_overall          = competencyoverall,
      likely_human                = likelyhuman,
      surprised_AI                = surprisedAI
    )
}

# function to run power analysis based on pilot 3 results
run_power_analysis_pilot3 <- function(pilot3_fit1, n = 100, sim_id = 1) {
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
          iter = 2000,
          warmup = 1000,
          chains = 2,
          cores = 2,
          init = 0,
          threads = threading(2),
          seed = 2113
          )
        ),
      # 3. extract statistics from the fitted model
      # maximum rhat value
      max_rhat = max(rhat(fit), na.rm = TRUE),
      # minimum neff ratio
      min_neff_ratio = min(neff_ratio(fit), na.rm = TRUE),
      # posterior samples
      post = list(posterior_samples(fit)),
      # difference in trust between CD and CU
      diff_trust_CD =
        list(post[["b_trustbaseline_advisor_typeConsistentlyUtilitarian"]]),
      # difference in trust between NS and CU
      diff_trust_NS =
        list(
          post[["b_trustbaseline_advisor_typeConsistentlyUtilitarian"]] -
          post[["b_trustbaseline_advisor_typeNormativelySensitive"]]
          ),
      # difference in trust between NNS and CU
      diff_trust_NNS =
        list(
          post[["b_trustbaseline_advisor_typeConsistentlyUtilitarian"]] -
          post[["b_trustbaseline_advisor_typeNonNormativelySensitive"]]
        ),
      # difference in human likelihood between CD and CU
      diff_human_CD =
        list(post[["b_likelyhuman_advisor_typeConsistentlyUtilitarian"]]),
      # difference in human likelihood between NS and CU
      diff_human_NS =
        list(
          post[["b_likelyhuman_advisor_typeConsistentlyUtilitarian"]] -
            post[["b_likelyhuman_advisor_typeNormativelySensitive"]]
        ),
      # difference in human likelihood between NNS and CU
      diff_human_NNS =
        list(
          post[["b_likelyhuman_advisor_typeConsistentlyUtilitarian"]] -
            post[["b_likelyhuman_advisor_typeNonNormativelySensitive"]]
        )
      ) %>%
    # remove some columns
    select(!c(fit, post)) %>%
    # pivot longer
    pivot_longer(
      cols = starts_with("diff_"),
      names_to = "parameter",
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
