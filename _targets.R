library(targets)
library(tarchetypes)

# set options for targets and source R functions
tar_option_set(packages = c("brms", "cowplot", "ggsankey", "tidyverse"))
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
  #tar_target(pilot1_fit, fit_pilot1_model(pilot1_data)),
  ## extract estimated means from the model
  #tar_target(pilot1_means, extract_pilot1_means(pilot1_fit)),
  ## plot results
  #tar_target(pilot1_plot1, plot_pilot1_results(pilot1_data, pilot1_means)),
  #tar_target(pilot1_plot2, plot_pilot1_sankey(pilot1_data)),
  
  #### Pilot 2 ####
  
  # data file
  tar_target(pilot2_data_file, "data/pilot2/pilot2_data_clean.csv", 
             format = "file"),
  # load data
  tar_target(pilot2_data, load_pilot2_data(pilot2_data_file)),
  # fit model
  tar_target(pilot2_fit, fit_pilot2_model(pilot2_data))
)
