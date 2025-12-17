library(crew)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(
  packages = c("brms", "cowplot", "ggsankey", "patchwork", "tidyverse"),
  controller = crew_controller_local(workers = 8),
  deployment = "main"
)
tar_source()

# targets pipeline
list(
  # main pipelines
  #targets_pilot1,   # R/pilot1/targets_pilot1.R
  #targets_pilot2,   # R/pilot2/targets_pilot2.R
  #targets_pilot3,   # R/pilot3/targets_pilot3.R
  targets_study1,   # R/study1/targets_study1.R
  targets_study2,   # R/study2/targets_study2.R
  targets_study3    # R/study3/targets_study3.R
  # summary of pilot studies
  #tar_quarto(summary, "quarto/summary/summary.qmd")
)
