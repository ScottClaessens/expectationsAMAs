# function to plot probabilities of each rank from fitted model
plot_pilot3_ranking <- function(pilot3_fit2) {
  # advisor types
  advisor_types <- c(
    "ConsistentlyDeontological" = "Consistently\nnon-utilitarian",
    "ConsistentlyUtilitarian"   = "Consistently\nutilitarian",
    "NormativelySensitive"      = "Normatively\nsensitive",
    "NonNormativelySensitive"   = "Non-normatively\nsensitive"
  )
  # marginal effects plot from brms
  c <- conditional_effects(
    pilot3_fit2,
    resp = "ranklikelyhuman",
    categorical = TRUE
  )
  # edit the plot
  p <- 
    plot(c, plot = FALSE)[[1]] +
    scale_x_discrete(labels = function(x) advisor_types[x]) +
    ylim(c(0.0, 0.6)) +
    labs(
      x = NULL,
      y = "Estimated probability\nof rank position"
    ) +
    theme_classic() +
    theme(legend.title = element_blank())
  # save
  ggsave(
    plot = p,
    filename = "plots/pilot3_ranking.pdf",
    width = 6,
    height = 4
  )
  return(p)
}
