# function to implement comprehension q exclusions from study 3 data
exclude_study3_data <- function(study3_data) {
  study3_data |>
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
    ) |>
    # exclude participants with failed dilemma check
    filter(dilemma == check_dilemma) |>
    # exclude participants with failed condition check
    filter(
      (condition == "AI" & check_condition == "All advisors were AI") |
        (condition == "Human" & check_condition == "All advisors were human")
    )
}
