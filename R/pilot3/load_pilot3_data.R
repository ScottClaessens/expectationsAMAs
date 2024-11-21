# function to load in and clean data
load_pilot3_data <- function(pilot3_data_file) {
  # read csv file
  read_csv(
    file = pilot3_data_file,
    show_col_types = FALSE
  ) %>%
    # remove participants who did not correctly answer the attention check
    filter(attention == "TikTok") %>%
    dplyr::select(!attention)
}
