targets_study1 <-
  list(
    # data file
    tar_target(study1_data_file, "data/study1/study1_data_clean.csv",
               format = "file"),
    # load data
    tar_target(study1_data, load_study1_data(study1_data_file)),
    # plot judgements
    tar_target(study1_plot_judgements, plot_own_judgements_study1(study1_data)),
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
      tar_target(study1_table3, create_table_study1_model3(study1_fit3)),
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
