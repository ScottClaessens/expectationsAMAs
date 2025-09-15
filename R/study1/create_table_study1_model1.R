# table of pairwise comparisons from model 1
create_table_study1_model1 <- function(study1_fit1) {
  # new data
  d <- expand_grid(
    advisor_type = c("ConsistentlyDeontological", "ConsistentlyUtilitarian",
                     "NormativelySensitive", "NonNormativelySensitive"),
    dilemma_type = c("InstrumentalHarm", "ImpartialBeneficence"),
    time = c("baseline", "overall")
  )
  # fitted values
  f <- fitted(
    object = study1_fit1,
    newdata = d,
    re_formula = NA,
    scale = "linear",
    summary = FALSE
  )
  # add to data
  d$post <- lapply(seq_len(ncol(f)), function(i) f[,i])
  # get pairwise differences
  full_join(
    unite(d, col = "var", dilemma_type, time),
    unite(d, col = "var", dilemma_type, time),
    by = "var",
    suffix = c(".row1", ".row2"),
    relationship = "many-to-many"
  ) %>%
    filter(advisor_type.row1 < advisor_type.row2) %>%
    rowwise() %>%
    mutate(
      pair = paste(advisor_type.row1, "-", advisor_type.row2),
      pair = str_replace(pair, fixed("D"), " D"),
      pair = str_replace(pair, fixed("U"), " U"),
      pair = str_replace(pair, fixed("S"), " S"),
      pair = str_replace(pair, fixed("nN"), "n-n"),
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
    dplyr::select(pair, var, diff) %>%
    pivot_wider(
      names_from = var,
      values_from = diff
    )
}
