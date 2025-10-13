# table of pairwise comparisons from model 1
create_table_within_model1 <- function(within_fit1) {
  # new data
  d <- expand_grid(
    advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                     "NormativelySensitive", "NonNormativelySensitive"),
    dilemma_type = c("InstrumentalHarm", "ImpartialBeneficence")
  )
  # fitted values
  f <- fitted(
    object = within_fit1,
    newdata = d,
    re_formula = NA,
    scale = "linear",
    summary = FALSE
  )
  # add to data
  d$post <- lapply(seq_len(ncol(f)), function(i) f[,i])
  # get pairwise differences
  full_join(
    d,
    d,
    by = "dilemma_type",
    suffix = c(".row1", ".row2"),
    relationship = "many-to-many"
  ) %>%
    filter(advisor_type.row1 < advisor_type.row2) %>%
    rowwise() %>%
    mutate(
      dilemma_type = ifelse(dilemma_type == "InstrumentalHarm",
                            "Instrumental harm",
                            "Impartial beneficence"),
      pair = paste(advisor_type.row1, "-", advisor_type.row2),
      pair = str_replace_all(pair, fixed("D"), " D"),
      pair = str_replace_all(pair, fixed("U"), " U"),
      pair = str_replace_all(pair, fixed("S"), " S"),
      pair = str_replace_all(pair, fixed("nN"), "n-n"),
      diff = list(post.row1 - post.row2),
      diff = paste0(
        format(round(median(diff), 2), nsmall = 2),
        " [",
        format(round(quantile(diff, 0.025), 2), nsmall = 2),
        ", ",
        format(round(quantile(diff, 0.975), 2), nsmall = 2),
        "]"
      )
    ) %>%
    dplyr::select(pair, dilemma_type, diff) %>%
    pivot_wider(
      names_from = dilemma_type,
      values_from = diff
    )
}
