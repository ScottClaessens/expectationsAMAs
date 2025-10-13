targets_pilot2 <-
  list(
    # data file
    tar_target(pilot2_data_file, "data/pilot2/pilot2_data_clean.csv", 
               format = "file"),
    # load data
    tar_target(pilot2_data, load_pilot2_data(pilot2_data_file)),
    # fit models
    tar_target(pilot2_fit1, fit_pilot2_model1(pilot2_data)),
    tar_target(pilot2_fit2, fit_pilot2_model2(pilot2_data)),
    # extract overall means
    tar_target(pilot2_overall_means, extract_overall_pilot2_means(pilot2_fit1)),
    # extract means split by dilemma
    tar_target(pilot2_dilemma_means, 
               extract_pilot2_means_by_dilemma(pilot2_fit1)),
    # extract means split by dilemma type
    tar_target(
      pilot2_dilemma_type_means,
      extract_pilot2_means_by_dilemma_type(pilot2_fit2)
    ),
    # plot overall results
    tar_target(
      pilot2_plot_overall,
      plot_pilot2_overall_results(pilot2_data, pilot2_overall_means)
    ),
    # plot results by dilemma type
    tar_target(
      pilot2_plot_by_dilemma_type,
      plot_pilot2_results_by_dilemma_type(pilot2_data,
                                          pilot2_dilemma_type_means),
    ),
    # plot results by dilemma
    tar_map(
      values = tibble(
        response = c("trust", "trust_other_issues", "empathy", 
                     "competency", "likely_human", "surprised_AI"),
        colour_hex = c("#E69F00", "#56B4E9", "#009E73", 
                       "#F0E442", "#CC79A7", "#D55E00"),
        ylab = c("Trust", "Trust on other issues", "Empathy", "Competency",
                 "Human-likelihood", "AI-surprise")
      ),
      names = response,
      tar_target(
        pilot2_plot_by_dilemma,
        plot_pilot2_results_by_dilemma(pilot2_data, pilot2_dilemma_means,
                                       response, colour_hex, ylab)
      )
    )
  )
