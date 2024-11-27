# function to plot overall means from between-subjects AI questions
plot_pilot3_between_subjects_AI <- 
  function(pilot3_data, pilot3_between_subjects_means) {
    # prepare advisor type variable for plotting
    advisor_types <- c(
      "ConsistentlyDeontological" = "Consistently\nnon-utilitarian",
      "ConsistentlyUtilitarian"   = "Consistently\nutilitarian",
      "NormativelySensitive"      = "Normatively\nsensitive",
      "NonNormativelySensitive"   = "Non-normatively\nsensitive"
    )
    pilot3_data$advisor_type <- 
      factor(
        advisor_types[pilot3_data$advisor_type],
        levels = advisor_types
      )
    pilot3_between_subjects_means$advisor_type <-
      factor(
        advisor_types[pilot3_between_subjects_means$advisor_type],
        levels = advisor_types
      )
    # prepare response variables for plotting
    responses <- c(
      "likelyhuman" = "Human-likelihood",
      "surprisedAI" = "AI-surprise"
    )
    # pivot data long
    pilot3_data <-
      pilot3_data %>%
      pivot_longer(
        cols = likely_human:surprised_AI,
        names_to = "resp",
        values_to = "rating"
      ) %>%
      mutate(
        resp = factor(responses[str_remove(resp, "_")], levels = responses),
        type = "Overall evaluation"
      ) %>%
      select(advisor_type, resp, type, rating)
    # wrangle extracted means
    pilot3_between_subjects_means <-
      pilot3_between_subjects_means %>%
      filter(resp %in% c("likelyhuman", "surprisedAI")) %>%
      mutate(
        type = "Overall evaluation",
        resp = factor(responses[resp], levels = responses)
      ) %>%
      select(advisor_type, resp, type, estimate, lower, upper)
    # plot
    out <-
      ggplot() +
      geom_jitter(
        data = pilot3_data,
        mapping = aes(
          x = advisor_type,
          y = rating,
          colour = type
        ),
        alpha = 0.05,
        size = 0.8,
        width = 0.1
      ) +
      geom_pointrange(
        data = pilot3_between_subjects_means,
        mapping = aes(
          x = advisor_type,
          y = estimate,
          ymin = lower,
          ymax = upper,
          colour = type
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
      file = "plots/pilot3_between_subjects_AI.pdf",
      plot = out,
      height = 4,
      width = 5
    )
    return(out)
  }
