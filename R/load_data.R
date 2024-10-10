# function to load in and clean data
load_data <- function(data_file) {
  # read csv file
  read_csv(
    file = data_file,
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
