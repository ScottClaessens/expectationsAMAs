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
  #targets_pilot1,
  #targets_pilot2,
  #targets_pilot3,
  targets_study1,
  targets_study2
  # summary of pilot studies
  #tar_quarto(summary, "quarto/summary/summary.qmd")
)
