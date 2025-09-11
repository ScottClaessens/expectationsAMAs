# function to plot model 3 predictions from study 1
plot_study1_model3 <- function(study1_data, study1_means3, outcome,
                               split_by_dilemma = FALSE) {
  # advisor and dilemma types
  types <- c(
    "cons_deon"  = "ConsistentlyDeontological",
    "cons_util"  = "ConsistentlyUtilitarian",
    "norm_sens1" = "NormativelySensitive",
    "norm_sens2" = "NonNormativelySensitive"
  )
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
  # pivot data long
  data <-
    study1_data %>%
    # naming of columns annoying for regex
    rename(
      # normatively sensitive = norm_sens_1
      compare_trust_norm_sens1        = compare_trust_norm_sens,
      compare_likely_human_norm_sens1 = compare_likely_human_norm_sens,
      # non-normatively sensitive = norm_sens_2
      compare_trust_norm_sens2        = compare_trust_non_norm_sens,
      compare_likely_human_norm_sens2 = compare_likely_human_non_norm_sens
    ) %>%
    pivot_longer(
      cols = starts_with("compare_"),
      names_to = c(".value", "type"),
      names_pattern = "^(.*)_(cons_deon|cons_util|norm_sens1|norm_sens2)$"
    ) %>%
    transmute(
      id = id,
      dilemma = factor(
        ifelse(dilemma == "EnemySpy", "Enemy spy", dilemma),
        levels = c("Bomb", "Enemy spy", "Hostage", "Donation", "Marathon",
                   "Volunteering")
      ),
      dilemma_type = dilemma_types[dilemma_type],
      advisor_type = factor(advisor_types[types[type]], levels = advisor_types),
      compare_trust = compare_trust,
      compare_likely_human = compare_likely_human
    )
  # wrangle means
  means <-
    study1_means3 %>%
    mutate(
      dilemma_type = dilemma_types[dilemma_type],
      advisor_type = factor(advisor_types[advisor_type], levels = advisor_types)
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
        y = !!sym(outcome)
      ),
      width = 0.3,
      alpha = 0.05,
      size = 0.7
    ) +
    geom_pointrange(
      data = means,
      mapping = aes(
        x = advisor_type,
        y = estimate,
        ymin = lower,
        ymax = upper
      ),
      linewidth = 0.7
    ) +
    scale_y_continuous(
      name = str_to_sentence(
        str_replace_all(str_remove(outcome, "compare_"), "_", " ")
      ),
      limits = c(1, 7),
      breaks = 1:7
    ) +
    scale_x_discrete(
      name = "Advisor type",
      labels = advisor_types
    ) +
    facet_wrap(
      if (split_by_dilemma) {
        . ~ dilemma
      } else {
        . ~ fct_rev(dilemma_type)
      }
    ) +
    ggtitle("Directly comparing advisors") +
    theme_classic() +
    theme(
      axis.text.x = element_text(size = 8),
      legend.position = "bottom"
    )
  # save and return
  ggsave(
    plot = p,
    filename = paste0(
      "plots/study1_results_",
      ifelse(split_by_dilemma, "by_dilemma_", ""),
      outcome,
      ".pdf"
    ),
    width = ifelse(split_by_dilemma, 9.5, 7),
    height = ifelse(split_by_dilemma, 5.5, 4)
  )
  return(p)
}
