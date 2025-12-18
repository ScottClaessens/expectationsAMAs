# function for individual sankey plots
plot_pilot1_sankey_individual <- function(pilot1_data, plot_dilemma) {
  pilot1_data %>%
    pivot_wider(
      id_cols = id,
      names_from = c(type, dilemma, order), 
      values_from = decision
    ) %>%
    pivot_longer(
      cols = !id,
      names_sep = "_",
      names_to = c("type", "dilemma", ".value")
    ) %>%
    drop_na() %>%
    filter(dilemma == plot_dilemma) %>%
    ggsankey::make_long(Pre, Post) %>%
    mutate(
      node = factor(node, levels = 1:7),
      next_node = factor(next_node, levels = 1:7)
    ) %>%
    ggplot(
      mapping = aes(
        x = x, 
        next_x = next_x, 
        node = node, 
        next_node = next_node,
        fill = factor(node)
      )
    ) +
    geom_sankey(
      alpha = 0.7,
      node.color = 'black'
    ) +
    geom_sankey_text(
      aes(label = node),
      alpha = 0.75,
      size = 2,
      color = "black"
    ) +
    # viridis colour scheme
    scale_fill_manual(
      values = c(
        "1" = "#440154",
        "2" = "#443983",
        "3" = "#31688e",
        "4" = "#21918c",
        "5" = "#35b779",
        "6" = "#90d743",
        "7" = "#fde725"
      )
    ) +
    ggtitle(plot_dilemma) +
    theme_sankey() +
    theme(
      legend.position = "none",
      axis.title.x = element_blank(),
      plot.title = element_text(hjust = 0.5),
      plot.margin = margin(t = 5, r = -20, b = 5, l = -20)
    )
}

# function to produce all sankey plots
plot_pilot1_sankey <- function(pilot1_data) {
  # get all dilemmas in correct order
  dilemmas <-
    c(as.character(sort(unique(pilot1_data$dilemma[pilot1_data$type == "IB"]))),
      as.character(sort(unique(pilot1_data$dilemma[pilot1_data$type == "IH"]))))
  # get list of plots
  plot_list <- list()
  for (i in 1:length(dilemmas)) {
    plot_list[[i]] <- 
      plot_pilot1_sankey_individual(pilot1_data, plot_dilemma = dilemmas[i])
  }
  # put together
  p <- plot_grid(
    plotlist = plot_list,
    nrow = 2
    )
  # add title
  title <- 
    ggdraw() + 
    draw_label(
      "Do you think that [person] should [utilitarian option]?",
      fontface = 'bold',
      x = 0,
      hjust = 0
    ) +
    theme(
      plot.margin = margin(t = 0, r = 0, b = 0, l = 7)
      )
  p <- plot_grid(
    title, p, 
    ncol = 1,
    rel_heights = c(0.1, 1)
  )
  # save
  ggsave(
    plot = p,
    filename = "plots/pilot1/pilot1_sankey.pdf",
    height = 5,
    width = 8
  )
  return(p)
}
