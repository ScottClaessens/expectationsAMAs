# function to plot responses to choice question
plot_study3_model2 <- function(study3_fit2, include, split_by_dilemma = FALSE) {
  # advisor and dilemma types
  advisor_types <- c(
    "ConsistentlyDeontological" = "Consistently\nDeontological",
    "ConsistentlyUtilitarian"   = "Consistently\nUtilitarian",
    "NormativelySensitive"      = "Normatively\nSensitive",
    "NonNormativelySensitive"   = "Non-normatively\nSensitive"
  )
  dilemma_types <- c(
    "InstrumentalHarm"     = "Instrumental harm",
    "ImpartialBeneficence" = "Impartial beneficence"
  )
  dilemmas <- c(
    "Bomb"         = "Bomb",
    "EnemySpy"     = "Enemy spy",
    "Hostage"      = "Hostage",
    "Donation"     = "Donation",
    "Marathon"     = "Marathon",
    "Volunteering" = "Volunteering"
  )
  # get model predictions
  if (split_by_dilemma) {
    d <- 
      expand_grid(
        condition = c("AI", "Human"),
        dilemma = names(dilemmas)
      ) |>
      mutate(
        dilemma_type = ifelse(
          dilemma %in% names(dilemmas)[1:3],
          "InstrumentalHarm",
          "ImpartialBeneficence"
        )
      )
  } else {
    d <- 
      expand_grid(
        condition = c("AI", "Human"),
        dilemma_type = names(dilemma_types)
      )
  }
  f <-
    fitted(
      object = study3_fit2,
      newdata = d,
      re_formula = if (split_by_dilemma) {
        ~ 1 + (1 + condition | dilemma)
      } else {
        NA
      },
    )
  # wrangle data
  d <-
    bind_cols(d, as_tibble(f)) |>
    pivot_longer(
      cols = !c(condition, starts_with("dilemma")),
      names_to = c(".value", "advisor_type"),
      names_pattern = "(.*).P\\(Y = (.*)\\)"
    ) |>
    mutate(
      advisor_type = factor(
        advisor_types[advisor_type],
        levels = advisor_types
      ),
      dilemma_type = factor(
        dilemma_types[dilemma_type],
        levels = dilemma_types
      )
    )
  if (split_by_dilemma) {
    d <-
      d |>
      mutate(
        dilemma = factor(
          dilemmas[dilemma],
          levels = dilemmas
        )
      )
  }
  # plot
  p <-
    ggplot(
      data = d,
      mapping = aes(
        x = advisor_type,
        y = Estimate,
        ymin = `Q2.5`,
        ymax = `Q97.5`,
        colour = condition
      )
    ) +
    geom_hline(
      yintercept = 0.25,
      linetype = "dashed"
    ) +
    geom_pointrange(
      position = position_dodge(width = 0.5)
    ) +
    facet_wrap(
      if (split_by_dilemma) {
        . ~ dilemma
      } else {
        . ~ dilemma_type
      }
    ) +
    scale_colour_manual(
      name = NULL,
      values = c("#2c00c4", "#c40500")
    ) +
    labs(
      x = NULL,
      y = "Probability of choosing advisor\nfor advice on another issue"
    ) +
    theme_classic() +
    theme(
      axis.text.x = element_text(size = 8),
      legend.position = "bottom"
    )
  # cleanup to cut object size
  rm(study3_fit2)
  # save and return
  ggsave(
    plot = p,
    filename = paste0(
      "plots/study3/",
      include,
      "/study3_results_",
      ifelse(split_by_dilemma, "by_dilemma_", ""),
      "choice.pdf"
    ),
    width = ifelse(split_by_dilemma, 9.5, 7),
    height = ifelse(split_by_dilemma, 5.5, 4)
  )
  return(p)
}
