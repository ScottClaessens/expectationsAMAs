# function to plot model 2 predictions from study 1
plot_study1_model2 <- function(study1_data, study1_means2, outcome) {
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
  # plot
  p <-
    ggplot() +
    geom_jitter(
      data = mutate(
        study1_data,
        dilemma_type = dilemma_types[dilemma_type],
        advisor_type = factor(advisor_type, levels = names(advisor_types)),
        type = "Overall evaluation"
      ),
      mapping = aes(
        x = advisor_type,
        y = !!sym(outcome),
        colour = type
      ),
      width = 0.2,
      alpha = 0.1,
      size = 0.9
    ) +
    geom_pointrange(
      data = mutate(
        study1_means2,
        dilemma_type = dilemma_types[dilemma_type],
        advisor_type = factor(advisor_type, levels = names(advisor_types)),
        type = "Overall evaluation"
      ),
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
      name = ifelse(outcome == "likely_human", "Likely human", "Surprised AI"),
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
    facet_wrap(. ~ fct_rev(dilemma_type)) +
    theme_classic() +
    theme(
      axis.text.x = element_text(size = 8),
      legend.position = "bottom"
    )
  # save and return
  ggsave(
    plot = p,
    filename = paste0("plots/study1_results_", outcome, ".pdf"),
    width = 7,
    height = 4
  )
  return(p)
}
