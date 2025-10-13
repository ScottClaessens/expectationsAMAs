# function to implement comprehension q exclusions from within-subjects data
exclude_within_data <- function(within_data) {
  within_data %>%
    # exclude cases with failed advisor checks
    filter(
      (advisor_type == "ConsistentlyDeontological" &
         check_advice_relevant == "No" &
         check_advice_irrelevant == "No") |
        (advisor_type == "ConsistentlyUtilitarian" &
           check_advice_relevant == "Yes" &
           check_advice_irrelevant == "Yes") |
        (advisor_type == "NormativelySensitive" &
           check_advice_relevant == "Yes" &
           check_advice_irrelevant == "No") |
        (advisor_type == "NonNormativelySensitive" &
           check_advice_relevant == "No" &
           check_advice_irrelevant == "Yes")
    ) %>%
    # exclude participants with failed dilemma check
    filter(dilemma == check_dilemma)
}
