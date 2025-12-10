targets_study2 <-
  list(
    # data file
    tar_target(
      study2_data_file,
      "data/study2/study2_data_clean.csv",
      format = "file"
    ),
    # load data
    tar_target(study2_data, load_study2_data(study2_data_file)),
    # exclude comprehension failures
    tar_target(study2_data_exclude, exclude_study2_data(study2_data)),
    # plot judgements
    tar_target(study2_plot_judgements, plot_own_judgements_study2(study2_data)),
    # fit model 1
    tar_map(
      values = list(outcome = c("trust", "empathy", "competent", "likely_AI")),
      tar_target(study2_fit1, fit_study2_model1(study2_data, outcome)),
      tar_target(study2_table1, create_table_study2_model1(study2_fit1)),
      tar_target(study2_means1, extract_study2_means1(study2_fit1)),
      tar_target(study2_plot1, plot_study2_model1(study2_data, study2_means1,
                                                  outcome)),
      tar_target(
        study2_means1_by_dilemma,
        extract_study2_means1(study2_fit1, split_by_dilemma = TRUE)
      ),
      tar_target(
        study2_plot1_by_dilemma,
        plot_study2_model1(study2_data, study2_means1_by_dilemma, outcome,
                           split_by_dilemma = TRUE)
      )
    ),
    # run power analysis based on study 2 data
    tar_target(power_id_study2, 1:100),
    tar_target(
      power_model_study2,
      update(
        object = study2_fit1_trust,
        chains = 0,
        backend = "cmdstanr" # compile with cmdstanr for speed gains
      )
    ),
    tar_target(
      power_study2,
      run_power_analysis_study2(study2_fit1_trust, power_model_study2,
                                n = 750, power_id_study2),
      pattern = map(power_id_study2),
      deployment = "worker"
    )
  )
