# function to plot overall results from pilot 2
plot_pilot2_overall_results <- function(pilot2_data, pilot2_overall_means) {
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
  pilot2_overall_means$advisor_type <-
    factor(
      advisor_types[pilot2_overall_means$advisor_type],
      levels = advisor_types
    )
  # match dataset variables to fit output
  pilot2_data <- rename(
    pilot2_data,
    trustotherissues = trust_other_issues,
    likelyhuman = likely_human,
    surprisedAI = surprised_AI
  )
  # plotting function
  plot_fun <- function(response, colour_hex, remove_x, ylab) {
    out <-
      ggplot() +
      geom_jitter(
        data = pilot2_data,
        mapping = aes(
          x = advisor_type,
          y = !!sym(response)
        ),
        width = 0.1,
        alpha = 0.1,
        size = 0.8,
        colour = colour_hex
      ) +
      geom_pointrange(
        data = filter(pilot2_overall_means, resp == response),
        mapping = aes(
          x = advisor_type,
          y = estimate,
          ymin = lower,
          ymax = upper
        )
      ) +
      scale_y_continuous(
        name = ylab,
        limits = c(1, 7),
        breaks = 1:7,
        oob = scales::squish
      ) +
      xlab(NULL) +
      theme_minimal()
    if (remove_x) {
      out + theme(axis.text.x = element_blank())
    } else {
      out + theme(axis.text.x = element_text(hjust = 1, vjust = 1, angle = 45))
    }
  }
  # individual plots
  pA <- plot_fun("trust",            "#E69F00", TRUE,  "Trust")
  pB <- plot_fun("trustotherissues", "#56B4E9", TRUE,  "Trust on other issues")
  pC <- plot_fun("empathy",          "#009E73", TRUE,  "Empathy")
  pD <- plot_fun("competency",       "#F0E442", FALSE, "Competency")
  pE <- plot_fun("likelyhuman",      "#CC79A7", FALSE, "Human-likelihood")
  pF <- plot_fun("surprisedAI",      "#D55E00", FALSE, "AI-surprise")
  # put together
  out <- 
    (pA + pB + pC) / plot_spacer() / (pD + pE + pF) + 
    plot_layout(heights = c(1, -0.2, 1)) +
    plot_annotation(tag_levels = "a")
  # save
  ggsave(
    file = "plots/pilot2_overall_results.pdf",
    plot = out,
    height = 5,
    width = 7
  )
  return(out)
}
