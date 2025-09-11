# function to extract means from model 4 in study 1
extract_study1_means4 <- function(study1_fit4, split_by_dilemma = FALSE) {
  # new data
  if (split_by_dilemma) {
    d <- 
      expand_grid(
        advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                         "NormativelySensitive", "NonNormativelySensitive"),
        dilemma = c("Bomb", "EnemySpy", "Hostage", "Donation", "Marathon", 
                    "Volunteering")
      ) %>%
      mutate(
        dilemma_type = ifelse(
          dilemma %in% c("Bomb", "EnemySpy", "Hostage"),
          "InstrumentalHarm", "ImpartialBeneficence"
        )
      )
  } else {
    d <- expand_grid(
      advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                       "NormativelySensitive", "NonNormativelySensitive"),
      dilemma_type = c("InstrumentalHarm", "ImpartialBeneficence")
    )
  }
  # get fitted values from the model
  f <- fitted(
    object = study1_fit4,
    newdata = d,
    re_formula = if (split_by_dilemma) {
      ~ 1 + (1 + advisor_type | dilemma)
    } else {
      NA
    },
    scale = "response",
    summary = FALSE
  )
  # convert from probabilities of each level to estimated means
  means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:4) means <- means + (f[, , i] * i)
  # add means to data
  d %>%
    mutate(
      post = lapply(
        seq_len(ncol(means)), function(i) as.numeric(means[,i])
      )
    ) %>%
    rowwise() %>%
    mutate(
      estimate = median(post),
      lower = quantile(post, 0.025),
      upper = quantile(post, 0.975)
    ) %>%
    ungroup()
}
