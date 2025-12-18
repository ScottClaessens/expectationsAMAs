# function to plot model 1 predictions from within-subjects study
plot_study2_model1 <- function(study2_data, study2_means1, outcome,
                               split_by_dilemma = FALSE) {
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
  # wrangle data
  data <-
    study2_data %>%
    mutate(
      dilemma_type = dilemma_types[dilemma_type],
      advisor_type = factor(advisor_type, levels = names(advisor_types)),
      type = "Overall evaluation",
      dilemma = factor(
        ifelse(dilemma == "EnemySpy", "Enemy spy", dilemma),
        levels = c("Bomb", "Enemy spy", "Hostage", "Donation", "Marathon",
                   "Volunteering")
      )
    )
  # wrangle means
  means <-
    study2_means1 %>%
    mutate(
      dilemma_type = dilemma_types[dilemma_type],
      advisor_type = factor(advisor_type, levels = names(advisor_types)),
      type = "Overall evaluation"
    )
  if (split_by_dilemma) {
    means <-
      means %>%
      mutate(
        dilemma = factor(
          ifelse(dilemma == "EnemySpy", "Enemy spy", dilemma),
          levels = c("Bomb", "Enemy spy", "Hostage", "Donation", "Marathon",
                     "Volunteering")
        )
      )
  }
  # plot
  p <-
    ggplot() +
    geom_jitter(
      data = data,
      mapping = aes(
        x = advisor_type,
        y = !!sym(outcome),
        colour = type
      ),
      width = 0.25,
      height = 0.4,
      alpha = 0.1,
      size = 0.9
    ) +
    geom_pointrange(
      data = means,
      mapping = aes(
        x = advisor_type,
        y = estimate,
        ymin = lower,
        ymax = upper,
        colour = type
      ),
      linewidth = 0.7
    ) +
    scale_y_continuous(
      name = str_replace(
        str_to_sentence(str_replace_all(outcome, "_", " ")),
        pattern = fixed("ai"),
        replacement = "AI"
      ),
      limits = c(1, 7),
      breaks = 1:7
    ) +
    scale_x_discrete(
      name = "Advisor type",
      labels = advisor_types
    ) +
    scale_colour_manual(
      name = NULL,
      values = "#00BFC4"
    ) +
    facet_wrap(
      if (split_by_dilemma) {
        . ~ dilemma
      } else {
        . ~ fct_rev(dilemma_type)
      }
    ) +
    theme_classic() +
    theme(
      axis.text.x = element_text(size = 8),
      legend.position = "bottom"
    )
  # save and return
  ggsave(
    plot = p,
    filename = paste0(
      "plots/study2/study2_results_",
      ifelse(split_by_dilemma, "by_dilemma_", ""),
      outcome,
      ".pdf"
    ),
    width = ifelse(split_by_dilemma, 9.5, 7),
    height = ifelse(split_by_dilemma, 5.5, 4)
  )
  return(p)
}
