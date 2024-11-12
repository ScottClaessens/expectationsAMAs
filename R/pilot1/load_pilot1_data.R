# function to load in and clean data
load_pilot1_data <- function(pilot1_data_file) {
  # read csv file
  read_csv(
    file = pilot1_data_file,
    show_col_types = FALSE
    ) %>%
    # remove participants who did not correctly answer the attention check
    filter(attention == "TikTok") %>%
    dplyr::select(!attention) %>%
    # convert characters to factors
    mutate(
      counterbalancing = factor(counterbalancing),
      gender = factor(gender),
      type = factor(type),
      dilemma = factor(dilemma),
      order = factor(order, levels = c("Pre", "Post"))
      )
}
