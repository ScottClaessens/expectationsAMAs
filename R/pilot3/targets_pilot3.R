targets_pilot3 <-
  list(
    # data file
    tar_target(pilot3_data_file, "data/pilot3/pilot3_data_clean.csv", 
               format = "file"),
    # load data
    tar_target(pilot3_data, load_pilot3_data(pilot3_data_file)),
    # fit models
    tar_target(pilot3_fit1, fit_pilot3_model1(pilot3_data)), # between-subjects
    tar_target(pilot3_fit2, fit_pilot3_model2(pilot3_data)), # direct comparison
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
    tar_target(plot_power, plot_power_analysis_pilot3(power))
  )
