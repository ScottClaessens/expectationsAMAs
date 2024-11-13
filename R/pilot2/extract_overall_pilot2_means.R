# function to extract overall means from fitted model
extract_overall_pilot2_means <- function(pilot2_fit) {
  # new data
  d <- tibble(
    advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                     "NormativelySensitive", "NonNormativelySensitive")
    )
  # function to loop over outcome variables
  fun <- function(resp) {
    # get fitted values from the model
    f <- fitted(
      object = pilot2_fit,
      newdata = d,
      re_formula = NA,
      resp = resp,
      scale = "response",
      summary = FALSE
    )
    # convert from probabilities of each level to estimated means
    means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
    for (i in 1:7) means <- means + (f[, , i] * i)
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
    fun(resp = "trust"),
    fun(resp = "trustotherissues"),
    fun(resp = "empathy"),
    fun(resp = "competency"),
    fun(resp = "likelyhuman"),
    fun(resp = "surprisedAI")
  )
}