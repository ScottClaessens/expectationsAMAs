# function to plot overall means from direct comparison section
plot_pilot3_comparison <- function(pilot3_fit2, pilot3_comparison_means) {
  # extract data
  data <- pilot3_fit2$data
  # prepare advisor type variable for plotting
  advisor_types <- c(
    "ConsistentlyDeontological" = "Consistently\nnon-utilitarian",
    "ConsistentlyUtilitarian"   = "Consistently\nutilitarian",
    "NormativelySensitive"      = "Normatively\nsensitive",
    "NonNormativelySensitive"   = "Non-normatively\nsensitive"
  )
  pilot3_comparison_means$advisor_type <-
    factor(
      advisor_types[pilot3_comparison_means$advisor_type],
      levels = advisor_types
    )
  data$advisor_type <- 
    factor(
      advisor_types[data$advisor_type],
      levels = advisor_types
      )
  # prepare response variables for plotting
  responses <- c(
    "compare_trust" = "Trust",
    "compare_likely_human" = "Human-likelihood"
  )
  # pivot data long
  data <-
    data %>%
    mutate(
      resp = factor(responses[variable], levels = responses)
    ) %>%
    select(advisor_type, resp, value)
  # wrangle extracted means
  pilot3_comparison_means <-
    pilot3_comparison_means %>%
    filter(resp %in% c("compare_trust", "compare_likely_human")) %>%
    mutate(resp = factor(responses[resp], levels = responses))
  # plot
  out <-
    ggplot() +
    geom_jitter(
      data = data,
      mapping = aes(
        x = advisor_type,
        y = value
      ),
      alpha = 0.02,
      size = 0.8,
      width = 0.15
    ) +
    geom_pointrange(
      data = pilot3_comparison_means,
      mapping = aes(
        x = advisor_type,
        y = estimate,
        ymin = lower,
        ymax = upper
      )
    ) +
    facet_wrap(
      . ~ resp,
      strip.position = "left",
      scales = "free_y"
    ) +
    scale_y_continuous(
      name = NULL,
      limits = c(1, 7),
      breaks = 1:7,
      oob = scales::squish
    ) +
    scale_colour_manual(values = "#00BFC4") +
    xlab(NULL) +
    ggtitle("Directly comparing advisors") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(hjust = 1, vjust = 1, angle = 45),
      strip.placement = "outside",
      legend.title = element_blank(),
      legend.position = "top",
      panel.spacing.x = unit(1.0, "lines")
    )
  # save
  ggsave(
    file = "plots/pilot3_comparison.pdf",
    plot = out,
    height = 4,
    width = 6
  )
  return(out)
}
