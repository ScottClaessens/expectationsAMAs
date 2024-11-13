# function to plot pilot 2 results by individual dilemma
plot_pilot2_results_by_dilemma <- function(pilot2_data, pilot2_dilemma_means,
                                           response = "likelyhuman",
                                           colour_hex = "#CC79A7",
                                           ylab = "Human-likelihood") {
  # prepare advisor type variable for plotting
  advisor_types <- c(
    "ConsistentlyDeontological" = "Consistently\nnon-utilitarian",
    "ConsistentlyUtilitarian"   = "Consistently\nutilitarian",
    "NormativelySensitive"      = "Normatively\nsensitive",
    "NonNormativelySensitive"   = "Non-normatively\nsensitive"
  )
  pilot2_data$advisor_type <- 
    factor(
      advisor_types[pilot2_data$advisor_type],
      levels = advisor_types
    )
  pilot2_dilemma_means$advisor_type <-
    factor(
      advisor_types[pilot2_dilemma_means$advisor_type],
      levels = advisor_types
    )
  # prepare dilemma variable for plotting
  dilemmas <- c("Bomb", "EnemySpy", "Hostage", "Donation", "Marathon",
                "Volunteering")
  pilot2_data$dilemma <- factor(pilot2_data$dilemma, levels = dilemmas)
  pilot2_dilemma_means$dilemma <- factor(pilot2_dilemma_means$dilemma, 
                                         levels = dilemmas)
  # match dataset variables to fit output
  pilot2_data <- rename(
    pilot2_data,
    trustotherissues = trust_other_issues,
    likelyhuman = likely_human,
    surprisedAI = surprised_AI
  )
  # plot
  out <-
    ggplot() +
    geom_jitter(
      data = pilot2_data,
      mapping = aes(
        x = advisor_type,
        y = !!sym(response)
      ),
      width = 0.1,
      alpha = 0.4,
      size = 0.8,
      colour = colour_hex
    ) +
    geom_pointrange(
      data = filter(pilot2_dilemma_means, resp == response),
      mapping = aes(
        x = advisor_type,
        y = estimate,
        ymin = lower,
        ymax = upper
      )
    ) +
    facet_wrap(. ~ dilemma) +
    scale_y_continuous(
      name = ylab,
      limits = c(1, 7),
      breaks = 1:7,
      oob = scales::squish
    ) +
    xlab(NULL) +
    theme_minimal() +
    theme(
      panel.spacing.x = unit(1.2, "lines"),
      axis.text.x = element_text(hjust = 1, vjust = 1, angle = 45)
      )
  # save
  ggsave(
    filename = paste0("plots/pilot2_results_", response, ".pdf"),
    plot = out,
    width = 6,
    height = 4.5
  )
  return(out)
}
