# function to load study 1 data
load_study1_data <- function(study1_data_file) {
  # read csv file
  read_csv(
    file = study1_data_file,
    show_col_types = FALSE
  ) %>%
    # remove participants who did not correctly answer the attention check
    # and participants with low captcha scores
    filter(attention == "TikTok" & captcha >= 0.5) %>%
    dplyr::select(!c(attention, captcha))
}
