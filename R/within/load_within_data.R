# function to load within-subjects data
load_within_data <- function(within_data_file) {
  # read csv file
  read_csv(
    file = within_data_file,
    show_col_types = FALSE
  ) %>%
    # remove participants who did not correctly answer the attention check
    # and participants with low captcha scores
    filter(attention == "TikTok" & captcha >= 0.5) %>%
    dplyr::select(!c(attention, captcha))
}
