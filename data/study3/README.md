# Data README file

**Dataset title:** Clean data from third main study for project on "Trust in 
human and AI moral advisors favours rule-based over calculating moral reasoning"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 6400 rows x 29 columns

**Data collected on:** 15th December 2025

**Data format:** Long form

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `condition` - character, between-subjects experimental condition, either "AI"
or "Human"
- `dilemma_type` - character, type of dilemma presented to participant, either 
"InstrumentalHarm" or "ImpartialBeneficence"
- `dilemma` - character, specific dilemma randomly presented to participant, 
possible dilemmas were "Bomb", "Hostage", "EnemySpy", "Donation", "Marathon", 
and "Volunteer"
- `counterbalancing` - character, random counterbalancing order, either
"MorallyRelevant_First" or "MorallyIrrelevant_First"
- `captcha` - numeric, participant's Captcha score between 0 and 1
- `attention` - character, response to the attention check question. The
question was "When an important event is happening or is about to happen, many 
people try to get informed about the development of the situation. In such 
situations, where do you get your information from?" On the previous page,
participants are asked to respond to this question by saying "TikTok"
- `age` - numeric, participant's self-reported age in years
- `gender` - character, participant's self-reported gender identity
- `education` - numeric, 1-8, response to the question "What is the highest 
level of education you have completed?": (1) some primary school, (2) completed 
primary school, (3) some secondary school, (4) completed secondary school, (5) 
some university, (6) completed university, (7) some advanced study beyond 
university, (8) advanced degree beyond university
- `ses` - numeric, 1-10, response to the MacArthur Scale of Subjective Social 
Status, where 1 is the lowest rung on the ladder and 10 is the highest rung on 
the ladder
- `political_ideology` - numeric, 1-7 Likert, response to the question "In 
political matters, people talk of 'the left' and 'the right'. Generally
speaking, how would you place your views on this scale?" ranging from Left (1) 
to Neutral (4) to Right (7)
- `religiosity` - numeric, 1-7 Likert, response to the question "How religious
are you?" ranging from Not At All Religious (1) to Somewhat Religious (4) to
Very Religious (7)
- `ai_familiarity` - numeric, 1-7 Likert, response to the question "How familiar
are you with AI tools like ChatGPT?" ranging from Extremely Unfamiliar (1) to
Extremely Familiar (7)
- `ai_frequency` - numeric, 1-5 Likert, response to the question "How frequently
do you use AI tools like ChatGPT?", possible responses include Never (1),
Rarely (2), Occasionally (3), Frequently (4), and Very Frequently (5)
- `ai_trustworthy` - numeric, 1-7 Likert, response to the question "How 
trustworthy do you think AI tools like ChatGPT are?" ranging from Extremely
Untrustworthy (1) to Extremely Trustworthy (7)
- `advisor_choice` - character, the advisor that the participant chose when
given a comparison between all four advisors. The question was "Imagine that you
were facing a very difficult moral dilemma in your own life and did not know 
what to do. If you could receive advice from any one of these advisors, who 
would you choose?"
- `own_judgement_baseline` - numeric, 1-7 Likert scale, participant's own
judgement regarding the baseline dilemma, response to the question "Do you think
that [person] should [utilitarian option]?" from Definitely No (1) to Definitely
Yes (7), asked at end of survey
- `own_judgement_relevant` - numeric, 1-7 Likert scale, participant's own
judgement regarding the dilemma with the morally relevant change, response to
the question "Do you think that [person] should [utilitarian option]?" from
Definitely No (1) to Definitely Yes (7), asked at end of survey
- `own_judgement_irrelevant` - numeric, 1-7 Likert scale, participant's own
judgement regarding the dilemma with the morally irrelevant change, response to
the question "Do you think that [person] should [utilitarian option]?" from
Definitely No (1) to Definitely Yes (7), asked at end of survey
- `check_dilemma` - character, participant's response to the question "To ensure
that you were paying attention, which of the following dilemmas did you read in
this study?", should match the dilemma that they saw
- `check_condition` - character, participant's response to the question "In the 
study, we presented you with moral advice from four different advisors. Were 
these advisors human or AI?"
- `order` - numeric, 1-4, the order in which advisors were presented
- `advisor_type` - character, advisor type randomly presented to participant,
possible advisor types were "ConsistentlyUtilitarian",
"ConsistentlyDeontological", "NormativelySensitive", and 
"NonNormativelySensitive"
- `check_advice_relevant` - character, participant's response to the question
"What did the advisor say when [morally relevant change]?", either Yes or No
- `check_advice_irrrelevant` - character, participant's response to the question
"What did the advisor say when [morally irrelevant change]?", either Yes or No
- `trust` - numeric, 1-7 Likert scale, response to the question "How trustworthy
do you think [advisor] is?" from Not At All (1) to Very Much (7)
- `empathy` - numeric, 1-7 Likert scale, response to the question "How empathic
do you think [advisor] is?" from Not At All (1) to Very Much (7)
- `competent` - numeric, 1-7 Likert scale, response to the question "How 
competent do you think [advisor] is?" from Not At All (1) to Very Much (7)
