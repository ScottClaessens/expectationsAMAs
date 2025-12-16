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
    tar_target(study3_plot_judgements, plot_own_judgements_study3(study3_data))
  )
