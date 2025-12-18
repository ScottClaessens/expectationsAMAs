# function to plot advisor rankings from study 1
plot_study1_model4 <- function(study1_fit4) {
  # advisor and dilemma types
  advisor_types <- c(
    "ConsistentlyDeontological" = "Consistently\nDeontological",
    "ConsistentlyUtilitarian"   = "Consistently\nUtilitarian",
    "NormativelySensitive"      = "Normatively\nSensitive",
    "NonNormativelySensitive"   = "Non-normatively\nSensitive"
  )
  dilemma_types <- c(
    "InstrumentalHarm"     = "Instrumental harm",
    "ImpartialBeneficence" = "Impartial beneficence"
  )
  # fitted values
  d <- expand_grid(
    advisor_type = names(advisor_types),
    dilemma_type = names(dilemma_types)
  )
  f <- fitted(
    object = study1_fit4,
    newdata = d,
    re_formula = NA,
    scale = "response",
    summary = TRUE
  )
  d <-
    d %>%
    mutate(
      `1` = f[, "Estimate", "P(Y = 1)"],
      `2` = f[, "Estimate", "P(Y = 2)"],
      `3` = f[, "Estimate", "P(Y = 3)"],
      `4` = f[, "Estimate", "P(Y = 4)"],
      advisor_type = factor(
        advisor_types[advisor_type],
        levels = advisor_types
      ),
      dilemma_type = dilemma_types[dilemma_type]
    )
  # plot
  p <-
    d %>%
    pivot_longer(
      cols = `1`:`4`,
      names_to = "Rank",
      values_to = "prob"
    ) %>%
    mutate(
      Rank = ifelse(Rank == 1, "1 (Human)", as.character(Rank)),
      Rank = ifelse(Rank == 4, "4 (AI)", Rank),
      Rank = factor(Rank, levels = c("1 (Human)", "2", "3", "4 (AI)"))
    ) %>%
    ggplot(
      mapping = aes(
        x = prob,
        y = fct_rev(advisor_type),
        fill = Rank
      )
    ) +
    geom_col() +
    facet_wrap(fct_rev(dilemma_type) ~ .) +
    labs(
      x = "Estimated probability of choosing rank",
      y = NULL
    ) +
    scale_fill_manual(values = c("#FF4000", "#FF8000", "#FFBF00", "#FFFF00")) +
    theme_classic() +
    theme(
      axis.line = element_blank(),
      axis.ticks.y = element_blank(),
      strip.background = element_blank()
    )
  # save and return
  ggsave(
    plot = p,
    filename = paste0("plots/study1/study1_results_rank.pdf"),
    width = 7,
    height = 3
  )
  return(p)
}
