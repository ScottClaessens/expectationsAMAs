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
    # fit model 1
    tar_map(
      values = list(outcome = c("trust", "empathy", "competent", "likely_AI")),
      tar_target(study2_fit1, fit_study2_model1(study2_data, outcome)),
      tar_target(study2_table1, create_table_study2_model1(study2_fit1)),
      tar_target(study2_means1, extract_study2_means1(study2_fit1)),
      tar_target(study2_plot1, plot_study2_model1(study2_data, study2_means1,
                                                  outcome))
    )
  )
