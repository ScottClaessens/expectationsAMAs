# Data README file

**Dataset title:** Clean data from second pilot study for project on 
"Expectations of Artificial Moral Advisors"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 401 rows x 18 columns

**Data collected on:** 11th November 2024

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `dilemma_type` - character, type of dilemma randomly presented to participant,
either "InstrumentalHarm" or "ImpartialBeneficence"
- `dilemma` - character, specific dilemma randomly presented to participant, 
possible dilemmas were "Bomb", "Hostage", "EnemySpy", "Donation", "Marathon", 
and "Volunteer"
- `advisor_type` - character, advisor type randomly presented to participant,
possible advisor types were "ConsistentlyUtilitarian",
"ConsistentlyDeontological", "NormativelySensitive", and 
"NonNormativelySensitive"
- `counterbalancing` - character, random counterbalancing order, either
"MorallyRelevant_First" or "MorallyIrrelevant_First"
- `captcha`- numeric, participant's captcha score between 0 and 1
- `age` - numeric, participant's self-reported age in years
- `gender` - character, participant's self-reported gender identity
- `attention` - character, response to the attention check question. The
question was "When an important event is happening or is about to happen, many 
people try to get informed about the development of the situation. In such 
situations, where do you get your information from?" On the previous page,
participants are asked to respond to this question by saying "TikTok"
- `trust` - numeric, 1-7 Likert scale, response to the question "How trustworthy
do you think this advisor is?" from Not At All (1) to Very Much (7)
- `trust_other_issues` - numeric, 1-7 Likert scale, response to the question
"Based on their advice, how willing would you be to trust this advisor on other
issues?" from Not At All (1) to Very Much (7)
- `empathy` - numeric, 1-7 Likert scale, response to the question "How empathic
do you think this advisor is?" from Not At All (1) to Very Much (7)
- `competency` - numeric, 1-7 Likert scale, response to the question "How
competent do you think this advisor is?" from Not At All (1) to Very Much (7)
- `likely_human` - numeric, 1-7 Likert scale, response to the question "How
likely is this advisor to be AI or human?" from Very Likely To Be AI (1) to Very
Likely To Be Human (7)
- `surprised_AI` - numeric, 1-7 Likert scale, response to the question "How
surprised would you be if you found out this advisor is AI?" from Not At All
Surprised (1) to Very Surprised (7)
- `own_judgement_baseline` - numeric, 1-7 Likert scale, participant's own
judgement regarding the baseline dilemma, response to the question "Do you think
that [person] should [utilitarian option]?" from Definitely No (1) to Definitely
Yes (7)
- `own_judgement_irrelevant` - numeric, 1-7 Likert scale, participant's own
judgement regarding the dilemma with the morally irrelevant change, response to
the question "Do you think that [person] should [utilitarian option]?" from
Definitely No (1) to Definitely Yes (7)
- `own_judgement_relevant` - numeric, 1-7 Likert scale, participant's own
judgement regarding the dilemma with the morally relevant change, response to
the question "Do you think that [person] should [utilitarian option]?" from
Definitely No (1) to Definitely Yes (7)
