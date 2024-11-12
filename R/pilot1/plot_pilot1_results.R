# function to plot data and estimated means
plot_pilot1_results <- function(pilot1_data, pilot1_means) {
  # questions
  questions <- c(
    "Do you think that\n[person] should\n[utilitarian option]?",
    "How confident\nare you in\nyour decision?",
    "How easy to\nunderstand is\nthis scenario?"
  )
  names(questions) <- c("decision", "confidence", "understand")
  # prepare data for plotting
  data <-
    pilot1_data %>%
    pivot_longer(
      cols = decision:understand,
      names_to = "resp"
    ) %>%
    mutate(
      type = ifelse(type == "IH", "Instrumental harm", "Impartial beneficence"),
      resp = factor(questions[resp], levels = questions)
    ) %>%
    rename(Dilemma = dilemma)
  # prepare means for plotting
  means <-
    pilot1_means %>%
    mutate(
      type = ifelse(type == "IH", "Instrumental harm", "Impartial beneficence"),
      resp = factor(questions[resp], levels = questions),
      order = factor(order, levels = c("Pre", "Post"))
    )
  # plot
  p <-
    ggplot() +
    geom_point(
      data = data,
      mapping = aes(
        x = Dilemma,
        y = value,
        colour = order,
        group = order
      ),
      position = position_jitterdodge(jitter.height = 0.4),
      alpha = 0.1,
      size = 0.3
    ) +
    geom_pointrange(
      data = means,
      mapping = aes(
        x = dilemma,
        y = estimate,
        ymin = lower,
        ymax = upper,
        colour = order,
        group = order
      ),
      position = position_dodge(width = 0.75),
      size = 0.1
    ) +
    facet_grid(
      resp ~ type,
      scales = "free_x",
      switch = "y"
      ) +
    scale_y_continuous(
      breaks = 1:7,
      limits = c(1, 7),
      oob = scales::squish
      ) +
    theme_minimal() +
    theme(
      strip.placement = "outside",
      strip.text.x = element_text(size = 9),
      strip.text.y = element_text(size = 7),
      legend.title = element_blank(),
      axis.title.x = element_text(size = 9),
      axis.title.y = element_blank(),
      axis.text.x = element_text(size = 7, angle = 45, hjust = 1),
      axis.text.y = element_text(size = 6),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.3),
      panel.spacing.x = unit(1.0, "lines"),
      panel.spacing.y = unit(0.7, "lines")
      )
  # save plot
  ggsave(
    plot = p,
    filename = "plots/pilot1_results.pdf",
    height = 4,
    width = 5
  )
  return(p)
}