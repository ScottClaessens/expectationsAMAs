library(crew)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(
  packages = c("brms", "cowplot", "ggsankey", "patchwork", "tidyverse"),
  controller = crew_controller_local(workers = 8),
  deployment = "main"
  )
tar_source()

# targets pipeline
list(
  
  #### Pilot 1 ####
  
  # data file
  tar_target(pilot1_data_file, "data/pilot1/pilot1_data_clean.csv", 
             format = "file"),
  # load data
  tar_target(pilot1_data, load_pilot1_data(pilot1_data_file)),
  ## fit model
  tar_target(pilot1_fit, fit_pilot1_model(pilot1_data)),
  ## extract estimated means from the model
  tar_target(pilot1_means, extract_pilot1_means(pilot1_fit)),
  ## plot results
  tar_target(pilot1_plot1, plot_pilot1_results(pilot1_data, pilot1_means)),
  tar_target(pilot1_plot2, plot_pilot1_sankey(pilot1_data)),
  
  #### Pilot 2 ####
  
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
  tar_target(pilot2_dilemma_means, extract_pilot2_means_by_dilemma(pilot2_fit1)),
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
    plot_pilot2_results_by_dilemma_type(pilot2_data, pilot2_dilemma_type_means),
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
  ),
  
  #### Pilot 3 ####
  
  # data file
  tar_target(pilot3_data_file, "data/pilot3/pilot3_data_clean.csv", 
             format = "file"),
  # load data
  tar_target(pilot3_data, load_pilot3_data(pilot3_data_file)),
  # fit models
  tar_target(pilot3_fit1, fit_pilot3_model1(pilot3_data)), # between-subjects
  tar_target(pilot3_fit2, fit_pilot3_model2(pilot3_data)), # direct comparisons
  # extract overall means for between-subjects section of survey
  tar_target(
    pilot3_between_subjects_means,
    extract_pilot3_between_subjects_means(pilot3_fit1)
    ),
  # extract overall means for direct comparison section of survey
  tar_target(
    pilot3_comparison_means,
    extract_pilot3_comparison_means(pilot3_fit2)
    ),
  # plot between-subjects perceptions
  tar_target(
    pilot3_plot_perceptions,
    plot_pilot3_between_subjects_perceptions(
      pilot3_data,
      pilot3_between_subjects_means
      )
    ),
  # plot between-subjects AI questions
  tar_target(
    pilot3_plot_AI,
    plot_pilot3_between_subjects_AI(
      pilot3_data,
      pilot3_between_subjects_means
      )
    ),
  # plot direct comparison
  tar_target(
    pilot3_plot_comparison,
    plot_pilot3_comparison(
      pilot3_fit2,
      pilot3_comparison_means
    )
  ),
  # run power analysis based on pilot 3 data
  tar_target(power_id, 1:100),
  tar_target(
    power,
    run_power_analysis_pilot3(pilot3_fit1, n = 400, power_id),
    pattern = map(power_id),
    deployment = "worker"
  ),
  tar_target(plot_power, plot_power_analysis_pilot3(power)),
  
  #### Summary of pilots ####
  
  tar_quarto(summary, "quarto/summary/summary.qmd")
  
)
