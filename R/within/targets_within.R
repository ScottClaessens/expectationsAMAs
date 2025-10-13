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
    tar_target(within_data_exclude, exclude_within_data(within_data))
  )
