library(targets)
library(tarchetypes)

# set options for targets and source R functions
tar_option_set(packages = c("brms", "cowplot", "ggsankey", "tidyverse"))
tar_source()

# targets pipeline
list(
  # pilot data file
  tar_target(data_file, "data/pilot1/pilot1_data_clean.csv", format = "file"),
  # load data
  tar_target(data, load_data(data_file)),
  # fit model
  tar_target(fit, fit_model(data)),
  # extract estimated means from the model
  tar_target(means, extract_means(fit)),
  # plot results
  tar_target(plot1, plot_results(data, means)),
  tar_target(plot2, plot_sankey(data))
)
