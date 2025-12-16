# Clean raw dataset

library(qualtRics) # v3.2.1
library(tidyverse) # v2.0.0

# attention codes
attention_codes <- c("TV", "Twitter", "Radio", "Facebook", "YouTube",
                     "Newspapers", "Reddit", "TikTok", "Other")

# gender codes
gender_codes <- c("Male", "Female", "Non-binary / third gender",
                  "Prefer to self-describe", "Prefer not to say")

# dilemmas
dilemmas <- c("Bomb", "EnemySpy", "Hostage", 
              "Donation", "Marathon", "Volunteering")

# columns to unite
cols_to_unite <- c("AdvisorA_Comp_Rel", "AdvisorA_Comp_Irrel",
                   "AdvisorB_Comp_Rel", "AdvisorB_Comp_Irrel",
                   "AdvisorC_Comp_Rel", "AdvisorC_Comp_Irrel",
                   "AdvisorD_Comp_Rel", "AdvisorD_Comp_Irrel",
                   "Decision_Original", "Decision_Relevant",
                   "Decision_Irrelevant")

# load raw data
d <-
  read_survey(
    file_name = 
      "Expectations+AMAs+-+Pilot+Full-Within_October+10,+2025_06.42.csv",
    add_var_labels = FALSE
  ) |>
  # add id column
  rowid_to_column("id")

# unite columns with the same name
for (col in cols_to_unite) {
  d <-
    d |>
    unite(!!sym(col), starts_with(col), na.rm = TRUE) |>
    mutate(!!col := parse_number(!!sym(col)))
}

d |>
  # unite dilemma check columns
  unite(check_dilemma, c(ComprehensionIH, ComprehensionIB), na.rm = TRUE) |>
  # get columns
  transmute(
    id                       = id,
    dilemma_type             = DilemmaType,
    dilemma                  = Dilemma,
    counterbalancing         = Counterbalancing,
    captcha                  = Q_RecaptchaScore,
    attention                = attention_codes[Attention_Check],
    age                      = Demographics_Age,
    gender                   = gender_codes[Demographics_Gender],
    education                = Education,
    ses                      = SES,
    political_ideology       = PoliticalIdeology,
    religiosity              = Religiosity,
    ai_familiarity           = AI_Familiarity,
    ai_frequency             = AI_Frequency,
    ai_trustworthy           = AI_Trustworthy,
    own_judgement_baseline   = Decision_Original,
    own_judgement_relevant   = Decision_Relevant,
    own_judgement_irrelevant = Decision_Irrelevant,
    check_dilemma            = dilemmas[parse_number(check_dilemma)],
    advisor_type1            = AdvisorA,
    advisor_type2            = AdvisorB,
    advisor_type3            = AdvisorC,
    advisor_type4            = AdvisorD,
    check_advice_relevant1   = c("Yes", "No")[AdvisorA_Comp_Rel], 
    check_advice_relevant2   = c("Yes", "No")[AdvisorB_Comp_Rel], 
    check_advice_relevant3   = c("Yes", "No")[AdvisorC_Comp_Rel], 
    check_advice_relevant4   = c("Yes", "No")[AdvisorD_Comp_Rel],
    check_advice_irrelevant1 = c("Yes", "No")[AdvisorA_Comp_Irrel], 
    check_advice_irrelevant2 = c("Yes", "No")[AdvisorB_Comp_Irrel], 
    check_advice_irrelevant3 = c("Yes", "No")[AdvisorC_Comp_Irrel], 
    check_advice_irrelevant4 = c("Yes", "No")[AdvisorD_Comp_Irrel],
    trust1                   = AdvisorA_Trust,
    trust2                   = AdvisorB_Trust,
    trust3                   = AdvisorC_Trust,
    trust4                   = AdvisorD_Trust,
    empathy1                 = AdvisorA_Empathy,
    empathy2                 = AdvisorB_Empathy,
    empathy3                 = AdvisorC_Empathy,
    empathy4                 = AdvisorD_Empathy,
    competent1               = AdvisorA_Competent,
    competent2               = AdvisorB_Competent,
    competent3               = AdvisorC_Competent,
    competent4               = AdvisorD_Competent,
    likely_AI1               = AdvisorA_LikelyAI,
    likely_AI2               = AdvisorB_LikelyAI,
    likely_AI3               = AdvisorC_LikelyAI,
    likely_AI4               = AdvisorD_LikelyAI
  ) |>
  pivot_longer(
    cols = ends_with(as.character(1:4)),
    names_to = c(".value", "order"),
    names_pattern = "(.*)([1-4])"
  ) |>
  # write clean data to csv file
  write_csv(file = "study2_data_clean.csv")
  