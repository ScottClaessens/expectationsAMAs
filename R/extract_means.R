# function to extract estimated means for each dilemma from the fitted model
extract_means <- function(fit) {
  # IH and IB dilemmas
  IH_dilemmas <- c("Bomb", "Passcode", "EnemySpy", "Sniper", "Hostage")
  IB_dilemmas <- c("Volunteering", "Donation", "Exam", "Architect", "Marathon")
  # tibble with new data
  d <- expand_grid(
    order = c("Pre", "Post"),
    dilemma = c(IH_dilemmas, IB_dilemmas)
  )
  # function to loop over outcome variables
  fun <- function(resp) {
    # get fitted values from the model
    f <- fitted(
      object = fit,
      newdata = d,
      re_formula = . ~ (1 + order | dilemma),
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
  # repeat for each outcome variable and bind results
  bind_rows(
    fun(resp = "decision"),
    fun(resp = "confidence"),
    fun(resp = "understand")
    ) %>%
    # add dilemma type and reorder
    mutate(type = ifelse(dilemma %in% IH_dilemmas, "IH", "IB")) %>%
    dplyr::select(type, everything())
}