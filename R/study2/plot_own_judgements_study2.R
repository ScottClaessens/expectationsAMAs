# function to plot participant's own judgements in study 2
plot_own_judgements_study2 <- function(study2_data) {
  plot <-
    study2_data |>
    pivot_longer(
      cols = starts_with("own_judgement"),
      names_to = "variant",
      values_to = "judgement"
    ) |>
    mutate(
      variant = str_to_title(str_remove(variant, fixed("own_judgement_"))),
      variant = ifelse(
        variant == "Baseline",
        paste0(variant, " dilemma"),
        paste0(variant, " change")
      ),
      dilemma = factor(
        ifelse(dilemma == "EnemySpy", "Enemy spy", dilemma),
        levels = c("Bomb", "Enemy spy", "Hostage", "Donation", "Marathon",
                   "Volunteering")
      )
    ) |>
    select(dilemma, variant, judgement) |>
    group_by(dilemma, variant) |>
    mutate(total_n = n()) |>
    group_by(dilemma, variant, judgement) |>
    mutate(prop = n() / total_n) |>
    summarise(prop = unique(prop), .groups = "drop") |>
    # plot
    ggplot() +
    geom_col(
      aes(
        x = judgement,
        y = prop
      )
    ) +
    facet_grid(dilemma ~ variant) +
    scale_x_continuous(
      name = "Deontological judgement <-> Utilitarian judgement",
      breaks = 1:7
    ) +
    scale_y_continuous(
      name = "Proportion of responses",
      limits = c(0, 0.75),
      breaks = c(0, 0.3, 0.6)
    ) +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      axis.line.x = element_blank(),
      axis.ticks.x = element_blank()
    )
  # save
  ggsave(
    filename = "plots/study2/study2_judgements.pdf",
    plot = plot,
    width = 5,
    height = 6
  )
  return(plot)
}
