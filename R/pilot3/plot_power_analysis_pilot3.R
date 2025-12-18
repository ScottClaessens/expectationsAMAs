# plot power analysis results
plot_power_analysis_pilot3 <- function(power) {
  # create plot
  p <- 
    ggplot(
      data = power,
      aes(
        x = sim_id,
        y = Estimate,
        ymin = Q2.5,
        ymax = Q97.5
        )
      ) +
    geom_hline(
      yintercept = 0,
      colour = "white"
      ) +
    geom_pointrange(fatten = 0.1) +
    facet_grid(comparison ~ .) +
    ylab("Estimated difference from CU") +
    theme(
      panel.grid = element_blank(),
      strip.text = element_text(size = 7)
    )
  # save
  ggsave(
    filename = "plots/pilot3/pilot3_power.pdf",
    plot = p,
    height = 6,
    width = 4
    )
  return(p)
}
