# function for individual sankey plots
plot_sankey_individual <- function(data, plot_dilemma) {
  data %>%
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
plot_sankey <- function(data) {
  # get all dilemmas in correct order
  dilemmas <-
    c(as.character(unique(data$dilemma[data$type == "IH"])),
      as.character(unique(data$dilemma[data$type == "IB"])))
  # get list of plots
  plot_list <- list()
  for (i in 1:length(dilemmas)) {
    plot_list[[i]] <- 
      plot_sankey_individual(data, plot_dilemma = dilemmas[i])
  }
  # put together
  p <- plot_grid(plotlist = plot_list, nrow = 2)
  # save
  ggsave(
    plot = p,
    filename = "plots/pilot_sankey.pdf",
    height = 5,
    width = 8
  )
  return(p)
}