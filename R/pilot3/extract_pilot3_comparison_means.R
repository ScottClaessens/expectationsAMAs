# function to extract overall means for direct comparison section of survey
extract_pilot3_comparison_means <- function(pilot3_fit2) {
  # new data
  d <- tibble(
    advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                     "NormativelySensitive", "NonNormativelySensitive")
  )
  # function to loop over outcome variables
  fun <- function(resp) {
    # get fitted values from the model
    f <- fitted(
      object = pilot3_fit2,
      newdata = d,
      re_formula = NA,
      resp = resp,
      scale = "response",
      summary = FALSE
    )
    # convert from probabilities of each level to estimated means
    means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
    if (resp == "ranklikelyhuman") {
      for (i in 1:4) means <- means + (f[, , i] * i) # 1-4 scale, reversed
    } else {
      for (i in 1:7) means <- means + (f[, , i] * i) # 1-7 scale
    }
    # add means to data
    d %>%
      mutate(
        resp = resp,
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
      ungroup() %>%
      dplyr::select(!post)
  }
  bind_rows(
    fun(resp = "comparetrust"),
    fun(resp = "comparelikelyhuman"),
    fun(resp = "ranklikelyhuman")
  )
}
