# function to plot results from pilot 2 by dilemma type
plot_pilot2_results_by_dilemma_type <- function(pilot2_data,
                                                pilot2_dilemma_type_means) {
  # prepare advisor and dilemma type variables for plotting
  advisor_types <- c(
    "ConsistentlyDeontological" = "Consistently\nnon-utilitarian",
    "ConsistentlyUtilitarian"   = "Consistently\nutilitarian",
    "NormativelySensitive"      = "Normatively\nsensitive",
    "NonNormativelySensitive"   = "Non-normatively\nsensitive"
  )
  dilemma_types <- c(
    "InstrumentalHarm"     = "Instrumental harm",
    "ImpartialBeneficence" = "Impartial beneficence"
  )
  pilot2_data <-
    pilot2_data %>%
    mutate(
      advisor_type = factor(advisor_types[advisor_type], levels = advisor_types),
      dilemma_type = factor(dilemma_types[dilemma_type], levels = dilemma_types)
    )
  pilot2_dilemma_type_means <-
    pilot2_dilemma_type_means %>%
    mutate(
      advisor_type = factor(advisor_types[advisor_type], levels = advisor_types),
      dilemma_type = factor(dilemma_types[dilemma_type], levels = dilemma_types)
    )
  # plotting function
  plot_fun <- function(response, remove_x, ylab) {
    out <-
      ggplot() +
      geom_jitter(
        data = pilot2_data,
        mapping = aes(
          x = advisor_type,
          y = !!sym(response),
          colour = dilemma_type
        ),
        width = 0.1,
        alpha = 0.1,
        size = 0.8
      ) +
      geom_pointrange(
        data = filter(pilot2_dilemma_type_means, resp == response),
        mapping = aes(
          x = advisor_type,
          y = estimate,
          ymin = lower,
          ymax = upper,
          colour = dilemma_type
        ),
        size = 0.2,
        position = position_dodge(width = 0.5)
      ) +
      scale_y_continuous(
        name = ylab,
        limits = c(1, 7),
        breaks = 1:7,
        oob = scales::squish
      ) +
      xlab(NULL) +
      theme_minimal() +
      theme(legend.title = element_blank())
    if (remove_x) {
      out + theme(axis.text.x = element_blank())
    } else {
      out + theme(axis.text.x = element_text(hjust = 1, vjust = 1, angle = 45))
    }
  }
  # individual plots
  pA <- plot_fun("trust",              TRUE,  "Trust")
  pB <- plot_fun("trust_other_issues", TRUE,  "Trust on other issues")
  pC <- plot_fun("empathy",            TRUE,  "Empathy")
  pD <- plot_fun("competency",         FALSE, "Competency")
  pE <- plot_fun("likely_human",       FALSE, "Human-likelihood")
  pF <- plot_fun("surprised_AI",       FALSE, "AI-surprise")
  # put together
  out <- 
    (pA + pB + pC) / plot_spacer() / (pD + pE + pF) & 
    theme(legend.position = "bottom")
  out <-
    out +
    plot_annotation(tag_levels = "a") +
    plot_layout(heights = c(1, -0.2, 1), guides = "collect")
  # save
  ggsave(
    file = "plots/pilot2/pilot2_results_by_dilemma_type.pdf",
    plot = out,
    height = 5,
    width = 7
  )
  return(out)
}