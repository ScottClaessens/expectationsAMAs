# function to plot overall means from between-subjects perceptions
plot_pilot3_between_subjects_perceptions <- 
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
    # prepare response variable for plotting
    responses <- c(
      "trust" = "Trust",
      "trust_other_issues" = "Trust on other issues",
      "empathy" = "Empathy",
      "competency" = "Competency"
    )
    # pivot data long
    pilot3_data <-
      pilot3_data %>%
      select(
        advisor_type | 
          ((ends_with("_baseline") | ends_with("_overall")) & 
             !own_judgement_baseline)
        ) %>%
      pivot_longer(
        cols = ends_with("_baseline") | ends_with("_overall"),
        names_to = c(".value", "type"),
        names_pattern = "^(.*)_(baseline|overall)$"
      ) %>%
      pivot_longer(
        cols = trust:competency,
        names_to = "resp"
      ) %>%
      mutate(
        resp = factor(responses[resp], levels = responses),
        type = ifelse(type == "baseline", "Baseline evaluation", 
                      "Overall evaluation")
        )
    # wrangle extracted means
    pilot3_between_subjects_means <-
      pilot3_between_subjects_means %>%
      filter(str_detect(resp, "baseline") | str_detect(resp, "overall")) %>%
      mutate(
        type = ifelse(str_detect(resp, "baseline"), "baseline", "overall"),
        resp = str_remove(resp, "baseline"),
        resp = str_remove(resp, "overall"),
        resp = ifelse(resp == "trustotherissues", "trust_other_issues", resp)
        ) %>%
      select(advisor_type, type, resp, estimate, lower, upper) %>%
      mutate(
        resp = factor(responses[resp], levels = responses),
        type = ifelse(type == "baseline", "Baseline evaluation", 
                      "Overall evaluation")
        )
    # plot
    out <-
      ggplot() +
      geom_point(
        data = pilot3_data,
        mapping = aes(
          x = advisor_type,
          y = value,
          colour = type
        ),
        alpha = 0.05,
        size = 0.8,
        position = position_jitterdodge(
          jitter.width = 0.1,
          jitter.height = 0.45,
          dodge.width = 0.4
          )
      ) +
      geom_pointrange(
        data = pilot3_between_subjects_means,
        mapping = aes(
          x = advisor_type,
          y = estimate,
          ymin = lower,
          ymax = upper,
          colour = type
        ),
        position = position_dodge(width = 0.4)
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
      xlab(NULL) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(hjust = 1, vjust = 1, angle = 45),
        strip.placement = "outside",
        legend.title = element_blank(),
        legend.position = "top",
        panel.spacing = unit(1.0, "lines")
      )
    # save
    ggsave(
      file = "plots/pilot3_between_subjects_perceptions.pdf",
      plot = out,
      height = 5,
      width = 6
    )
    return(out)
  }
