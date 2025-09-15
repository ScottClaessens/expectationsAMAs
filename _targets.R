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
  
  tar_quarto(summary, "quarto/summary/summary.qmd"),
  
  #### Study 1 ####
  
  # data file
  tar_target(study1_data_file, "data/study1/study1_data_clean.csv",
             format = "file"),
  # load data
  tar_target(study1_data, load_study1_data(study1_data_file)),
  # fit and plot model 1 - between-subjects perceptions
  tar_map(
    values = list(
      outcome = c("trust", "trust_other_issues", "empathy", "competence")
    ),
    tar_target(study1_fit1, fit_study1_model1(study1_data, outcome)),
    tar_target(study1_table1, create_table_study1_model1(study1_fit1)),
    tar_target(study1_means1, extract_study1_means1(study1_fit1)),
    tar_target(study1_plot1, plot_study1_model1(study1_data, study1_means1,
                                                outcome)),
    tar_target(
      study1_means1_by_dilemma,
      extract_study1_means1(study1_fit1, split_by_dilemma = TRUE)
    ),
    tar_target(
      study1_plot1_by_dilemma,
      plot_study1_model1(study1_data, study1_means1_by_dilemma, outcome,
                         split_by_dilemma = TRUE)
    )
  ),
  # fit and plot model 2 - between-subjects AI
  tar_map(
    values = list(outcome = c("likely_human", "surprised_AI")),
    tar_target(study1_fit2, fit_study1_model2(study1_data, outcome)),
    tar_target(study1_table2, create_table_study1_model2(study1_fit2)),
    tar_target(study1_means2, extract_study1_means2(study1_fit2)),
    tar_target(study1_plot2, plot_study1_model2(study1_data, study1_means2,
                                                outcome)),
    tar_target(
      study1_means2_by_dilemma,
      extract_study1_means2(study1_fit2, split_by_dilemma = TRUE)
    ),
    tar_target(
      study1_plot2_by_dilemma,
      plot_study1_model2(study1_data, study1_means2_by_dilemma, outcome,
                         split_by_dilemma = TRUE)
    )
  ),
  # fit and plot model 3 - direct comparisons
  tar_map(
    values = list(outcome = c("compare_trust", "compare_likely_human")),
    tar_target(study1_fit3, fit_study1_model3(study1_data, outcome)),
    tar_target(study1_means3, extract_study1_means3(study1_fit3)),
    tar_target(study1_plot3, plot_study1_model3(study1_data, study1_means3,
                                                outcome)),
    tar_target(
      study1_means3_by_dilemma,
      extract_study1_means3(study1_fit3, split_by_dilemma = TRUE)
    ),
    tar_target(
      study1_plot3_by_dilemma,
      plot_study1_model3(study1_data, study1_means3_by_dilemma, outcome,
                         split_by_dilemma = TRUE)
    )
  ),
  # fit and plot model 4 - ranking
  tar_target(study1_fit4, fit_study1_model4(study1_data)),
  tar_target(study1_means4, extract_study1_means4(study1_fit4)),
  tar_target(study1_plot4, plot_study1_model4(study1_fit4))
)
