# table of pairwise comparisons of experimental conditions from model 1
create_table_condition_study3_model1 <- function(study3_fit1) {
  # new data
  d <- expand_grid(
    condition = c("AI", "Human"),
    advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                     "NormativelySensitive", "NonNormativelySensitive"),
    dilemma_type = c("InstrumentalHarm", "ImpartialBeneficence")
  )
  # fitted values
  f <- fitted(
    object = study3_fit1,
    newdata = d,
    re_formula = NA,
    scale = "linear",
    summary = FALSE
  )
  # add to data
  d$post <- lapply(seq_len(ncol(f)), function(i) f[,i])
  # get pairwise differences
  d %>%
    pivot_wider(
      names_from = condition,
      values_from = post
    ) %>%
    rowwise() %>%
    mutate(
      dilemma_type = ifelse(dilemma_type == "InstrumentalHarm",
                            "Instrumental harm",
                            "Impartial beneficence"),
      advisor_type = str_replace_all(advisor_type, fixed("D"), " D"),
      advisor_type = str_replace_all(advisor_type, fixed("U"), " U"),
      advisor_type = str_replace_all(advisor_type, fixed("S"), " S"),
      advisor_type = str_replace_all(advisor_type, fixed("nN"), "n-n"),
      diff = list(AI - Human),
      diff = paste0(
        format(round(median(diff), 2), nsmall = 2),
        " [",
        format(round(quantile(diff, 0.025), 2), nsmall = 2),
        ", ",
        format(round(quantile(diff, 0.975), 2), nsmall = 2),
        "]"
      )
    ) %>%
    dplyr::select(advisor_type, dilemma_type, diff) %>%
    pivot_wider(
      names_from = dilemma_type,
      values_from = diff
    ) %>%
    rename(`Advisor type` = advisor_type)
}
