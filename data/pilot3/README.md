# Data README file

**Dataset title:** Clean data from third pilot study for project on 
"Expectations of Artificial Moral Advisors across Countries"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 401 rows x 34 columns

**Data collected on:** 19th November 2024

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `dilemma_type` - character, type of dilemma presented to participant,
always "InstrumentalHarm" in this pilot
- `dilemma` - character, specific dilemma randomly presented to participant, 
possible dilemmas were "Bomb", "Hostage", and "EnemySpy"
- `advisor_type` - character, advisor type randomly presented to participant,
possible advisor types were "ConsistentlyUtilitarian",
"ConsistentlyDeontological", "NormativelySensitive", and 
"NonNormativelySensitive"
- `counterbalancing` - character, random counterbalancing order, either
"MorallyRelevant_First" or "MorallyIrrelevant_First"
- `advisor_comparison_order` - character, order in which the four advisor types
were presented in the comparison section, separated by underscores, first was
labelled "Advisor A", second was labelled "Advisor B", third was labelled
"Advisor C", fourth was labelled "Advisor D"
- `age` - numeric, participant's self-reported age in years
- `gender` - character, participant's self-reported gender identity
- `attention` - character, response to the attention check question. The
question was "When an important event is happening or is about to happen, many 
people try to get informed about the development of the situation. In such 
situations, where do you get your information from?" On the previous page,
participants are asked to respond to this question by saying "TikTok"
- `trust_baseline` - numeric, 1-7 Likert scale, response to the question 
"How trustworthy do you think this advisor is?" from Not At All (1) to Very
Much (7), asked after participants saw the baseline dilemma
- `trust_other_issues_baseline` - numeric, 1-7 Likert scale, response to the 
question "Based on their advice, how willing would you be to trust this advisor
on other issues?" from Not At All (1) to Very Much (7), asked after participants
saw the baseline dilemma
- `empathy_baseline` - numeric, 1-7 Likert scale, response to the question "How
empathic do you think this advisor is?" from Not At All (1) to Very Much (7),
asked after participants saw the baseline dilemma
- `competency_baseline` - numeric, 1-7 Likert scale, response to the question
"How competent do you think this advisor is?" from Not At All (1) to Very Much
(7), asked after participants saw the baseline dilemma
- `trust_overall` - numeric, 1-7 Likert scale, response to the question 
"How trustworthy do you think this advisor is?" from Not At All (1) to Very
Much (7), asked after participants saw all dilemma variants
- `trust_other_issues_overall` - numeric, 1-7 Likert scale, response to the 
question "Based on their advice, how willing would you be to trust this advisor
on other issues?" from Not At All (1) to Very Much (7), asked after participants
saw all dilemma variants
- `empathy_overall` - numeric, 1-7 Likert scale, response to the question "How
empathic do you think this advisor is?" from Not At All (1) to Very Much (7),
asked after participants saw all dilemma variants
- `competency_overall` - numeric, 1-7 Likert scale, response to the question
"How competent do you think this advisor is?" from Not At All (1) to Very Much
(7), asked after participants saw all dilemma variants
- `likely_human` - numeric, 1-7 Likert scale, response to the question "How
likely is this advisor to be AI or human?" from Very Likely To Be AI (1) to Very
Likely To Be Human (7), asked after participants saw all dilemma variants
- `surprised_AI` - numeric, 1-7 Likert scale, response to the question "How
surprised would you be if you found out this advisor is AI?" from Not At All
Surprised (1) to Very Surprised (7), asked after participants saw all dilemma
variants
- `compare_trust_cons_deon` - numeric, 1-7 Likert scale, response to the 
question "How trustworthy do you think each of these advisors are? [Consistently 
deontological advisor]" from Not At All (1) to Very Much (7), asked in the
direct comparison section
- `compare_trust_cons_util` - numeric, 1-7 Likert scale, response to the 
question "How trustworthy do you think each of these advisors are? [Consistently 
utilitarian advisor]" from Not At All (1) to Very Much (7), asked in the direct
comparison section
- `compare_trust_norm_sens` - numeric, 1-7 Likert scale, response to the 
question "How trustworthy do you think each of these advisors are? [Normatively 
sensitive advisor]" from Not At All (1) to Very Much (7), asked in the direct 
comparison section
- `compare_trust_non_norm_sens` - numeric, 1-7 Likert scale, response to the 
question "How trustworthy do you think each of these advisors are?
[Non-normatively sensitive advisor]" from Not At All (1) to Very Much (7), asked
in the direct comparison section
- `compare_likely_human_cons_deon` - numeric, 1-7 Likert scale, response to the 
question "How likely are each of these advisors to be AI or human? [Consistently 
deontological advisor]" from Very Likely To Be AI (1) to Very Likely To Be Human
(7), asked in the direct comparison section
- `compare_likely_human_cons_util` - numeric, 1-7 Likert scale, response to the 
question "How likely are each of these advisors to be AI or human? [Consistently 
utilitarian advisor]" from Very Likely To Be AI (1) to Very Likely To Be Human
(7), asked in the direct comparison section
- `compare_likely_human_norm_sens` - numeric, 1-7 Likert scale, response to the 
question "How likely are each of these advisors to be AI or human? [Normatively 
sensitive advisor]" from Very Likely To Be AI (1) to Very Likely To Be Human
(7), asked in the direct comparison section
- `compare_likely_human_non_norm_sens` - numeric, 1-7 Likert scale, response to
the question "How likely are each of these advisors to be AI or human?
[Non-normatively sensitive advisor]" from Very Likely To Be AI (1) to Very 
Likely To Be Human (7), asked in the direct comparison section
- `rank_likely_human_cons_deon` - numeric, 1-4 rank order, response to the
statement "Please rank these advisors from most likely to be human (1) to most
likely to be AI (4). [Consistently deontological advisor]"
- `rank_likely_human_cons_util` - numeric, 1-4 rank order, response to the
statement "Please rank these advisors from most likely to be human (1) to most
likely to be AI (4). [Consistently utilitarian advisor]"
- `rank_likely_human_norm_sens` - numeric, 1-4 rank order, response to the
statement "Please rank these advisors from most likely to be human (1) to most
likely to be AI (4). [Normatively sensitive advisor]"
- `rank_likely_human_non_norm_sens` -  - numeric, 1-4 rank order, response to 
the statement "Please rank these advisors from most likely to be human (1) to
most likely to be AI (4). [Non-normatively sensitive advisor]"
- `own_judgement_baseline` - numeric, 1-7 Likert scale, participant's own
judgement regarding the baseline dilemma, response to the question "Do you think
that [person] should [utilitarian option]?" from Definitely No (1) to Definitely
Yes (7), asked at end of survey
- `own_judgement_irrelevant` - numeric, 1-7 Likert scale, participant's own
judgement regarding the dilemma with the morally irrelevant change, response to
the question "Do you think that [person] should [utilitarian option]?" from
Definitely No (1) to Definitely Yes (7), asked at end of survey
- `own_judgement_relevant` - numeric, 1-7 Likert scale, participant's own
judgement regarding the dilemma with the morally relevant change, response to
the question "Do you think that [person] should [utilitarian option]?" from
Definitely No (1) to Definitely Yes (7), asked at end of survey
