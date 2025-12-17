targets_study3 <-
  list(
    # data file
    tar_target(
      study3_data_file,
      "data/study3/study3_data_clean.csv",
      format = "file"
    ),
    # load data
    tar_target(study3_data, load_study3_data(study3_data_file)),
    # exclude comprehension failures
    tar_target(study3_data_exclude, exclude_study3_data(study3_data)),
    # plot judgements
    tar_target(study3_plot_judgements, plot_own_judgements_study3(study3_data)),
    # fit model 1
    tar_map(
      values = list(outcome = c("trust", "empathy", "competent")),
      tar_target(study3_fit1, fit_study3_model1(study3_data, outcome)),
      tar_target(
        study3_table1_condition,
        create_table_condition_study3_model1(study3_fit1)
      ),
      tar_target(
        study3_table1_advisor,
        create_table_advisor_study3_model1(study3_fit1)
      ),
      tar_target(study3_means1, extract_study3_means1(study3_fit1)),
      tar_target(study3_plot1, plot_study3_model1(study3_data, study3_means1,
                                                  outcome)),
      tar_target(
        study3_means1_by_dilemma,
        extract_study3_means1(study3_fit1, split_by_dilemma = TRUE)
      ),
      tar_target(
        study3_plot1_by_dilemma,
        plot_study3_model1(study3_data, study3_means1_by_dilemma, outcome,
                           split_by_dilemma = TRUE)
      )
    )
  )
