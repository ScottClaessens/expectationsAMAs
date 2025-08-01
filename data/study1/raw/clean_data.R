# Clean raw dataset

library(qualtRics) # v3.2.1
library(tidyverse) # v2.0.0

# attention codes
attention_codes <- c("TV", "Twitter", "Radio", "Facebook", "YouTube",
                     "Newspapers", "Reddit", "TikTok", "Other")

# gender codes
gender_codes <- c("Male", "Female", "Non-binary / third gender",
                  "Prefer to self-describe", "Prefer not to say")

# short labels for advisors
advisor_labels <- c(
  "ConsistentlyDeontological" = "cons_deon",
  "ConsistentlyUtilitarian"   = "cons_util",
  "NormativelySensitive"      = "norm_sens",
  "NonNormativelySensitive"   = "non_norm_sens"
)

# load raw data
read_survey(
  file_name = "Expectations+AMAs+-+Study+1_July+30,+2025_07.18.csv",
  add_var_labels = FALSE
) |>
  # add id column
  rowid_to_column("id") |>
  # get columns
  transmute(
    id                          = id,
    dilemma_type                = DilemmaType,
    dilemma                     = Dilemma,
    advisor_type                = AdvisorType,
    counterbalancing            = Counterbalancing,
    advisor_comparison_order    = paste(AdvisorA, AdvisorB, AdvisorC, AdvisorD, 
                                        sep = "_"),
    advisorA                    = AdvisorA,
    advisorB                    = AdvisorB,
    advisorC                    = AdvisorC,
    advisorD                    = AdvisorD,
    age                         = Demographics_Age,
    gender                      = gender_codes[Demographics_Gender],
    captcha                     = Q_RecaptchaScore,
    attention                   = attention_codes[Attention_Check],
    trust_baseline              = Trust1,
    trust_other_issues_baseline = TrustOtherIssues1,
    empathy_baseline            = Empathy1,
    competence_baseline         = Competency1,
    trust_overall               = Trust2,
    trust_other_issues_overall  = TrustOtherIssues2,
    empathy_overall             = Empathy2,
    competence_overall          = Competency2,
    likely_human                = LikelyHuman,
    surprised_AI                = SurprisedAI,
    compare_trustA              = Trust_Compare_1,
    compare_trustB              = Trust_Compare_2,
    compare_trustC              = Trust_Compare_3,
    compare_trustD              = Trust_Compare_4,
    compare_likely_humanA       = LikelyHuman_Compare_1,
    compare_likely_humanB       = LikelyHuman_Compare_2,
    compare_likely_humanC       = LikelyHuman_Compare_3,
    compare_likely_humanD       = LikelyHuman_Compare_4,
    rank_likely_humanA          = RankHumanAI_1,
    rank_likely_humanB          = RankHumanAI_2,
    rank_likely_humanC          = RankHumanAI_3,
    rank_likely_humanD          = RankHumanAI_4,
    own_judgement_baseline      = OwnDecision1,
    own_judgement_irrelevant = ifelse(
      counterbalancing == "MorallyIrrelevant_First", OwnDecision2, OwnDecision3
    ),
    own_judgement_relevant = ifelse(
      counterbalancing == "MorallyRelevant_First", OwnDecision2, OwnDecision3
    )
  ) |>
  # rearrange shuffled advisors A-D by pivoting
  pivot_longer(
    cols = c(advisorA:advisorD, compare_trustA:rank_likely_humanD),
    names_to = c(".value", "advisorID"),
    names_pattern = 
      "(advisor|compare_trust|compare_likely_human|rank_likely_human)([A-D])"
  ) |>
  mutate(advisor = advisor_labels[advisor]) |>
  dplyr::select(!advisorID) |>
  pivot_wider(
    names_from = advisor,
    values_from = c(
      compare_trust,
      compare_likely_human, 
      rank_likely_human
    )
  ) |>
  # reorder columns
  dplyr::relocate(
    id,
    dilemma_type,
    dilemma,
    advisor_type,
    counterbalancing,
    advisor_comparison_order,
    age,
    gender,
    captcha,
    attention,
    trust_baseline,
    trust_other_issues_baseline,
    empathy_baseline,
    competence_baseline,
    trust_overall,
    trust_other_issues_overall,
    empathy_overall,
    competence_overall,
    likely_human,
    surprised_AI,
    compare_trust_cons_deon,
    compare_trust_cons_util,
    compare_trust_norm_sens,
    compare_trust_non_norm_sens,
    compare_likely_human_cons_deon,
    compare_likely_human_cons_util,
    compare_likely_human_norm_sens,
    compare_likely_human_non_norm_sens,
    rank_likely_human_cons_deon,
    rank_likely_human_cons_util,
    rank_likely_human_norm_sens,
    rank_likely_human_non_norm_sens,
    own_judgement_baseline,
    own_judgement_irrelevant,
    own_judgement_relevant
  ) |>
  # write clean data to csv file
  write_csv(file = "study1_data_clean.csv")
