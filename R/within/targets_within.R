targets_within <-
  list(
    # data file
    tar_target(
      within_data_file,
      "data/within-subjects/within_subjects_data_clean.csv",
      format = "file"
    ),
    # load data
    tar_target(within_data, load_within_data(within_data_file)),
    # exclude comprehension failures
    tar_target(within_data_exclude, exclude_within_data(within_data)),
    # fit model 1
    tar_map(
      values = list(outcome = c("trust", "empathy", "competent", "likely_AI")),
      tar_target(within_fit1, fit_within_model1(within_data, outcome)),
      tar_target(within_table1, create_table_within_model1(within_fit1)),
      tar_target(within_means1, extract_within_means1(within_fit1)),
      tar_target(within_plot1, plot_within_model1(within_data, within_means1,
                                                  outcome))
    )
  )
