# Data README file

**Dataset title:** Clean data from pilot study for project on "Expectations of 
Artificial Moral Advisors across Countries"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 1200 rows x 12 columns

**Data collected on:** 10th October 2024

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `counterbalancing` - character, order in which the two blocks were presented,
either "IH_First" (meaning the instrumental harm block was presented first) or 
"IB_First" (meaning the impartial beneficence block was presented first)
- `attention` - character, response to the attention check question. The
question was "When an important event is happening or is about to happen, many 
people try to get informed about the development of the situation. In such 
situations, where do you get your information from?" On the previous page,
participants are asked to respond to this question by saying "TikTok"
- `age` - numeric, participant's reported age in years
- `gender` - character, participant's self-reported gender identity
- `type` - character, the type of moral dilemma that was presented to 
participants, either "IH" (instrumental harm) or "IB" (impartial beneficence)
- `dilemma` - character, the specific moral dilemma that was presented to
participants. Instrumental harm dilemmas include "Bomb", "Passcode", "EnemySpy",
"Sniper", and "Hostage". Impartial beneficence dilemmas include "Volunteering",
"Donation", "Exam", "Architect", and "Marathon".
- `order` - character, the order in which dilemma variants were shown, either
"Pre" (the baseline moral dilemma) or "Post" (the moral dilemma that includes
the morally-relevant change, i.e. an increase in the number of people that can
be saved/helped)
- `decision` - numeric, 1-7 Likert scale, response to the question "Do you think
that [character] should [do the utilitarian option in the dilemma]?"
- `confident` - numeric, 1-7 Likert scale, response to the question "How 
confident are you in your decision?"
- `understand` - numeric, 1-7 Likert scale, response to the question "How
easy to understand is this [updated] scenario?"
- `feedback` - character, participant's open-ended response to the statement "If
you have any other thoughts or opinions about this scenario, please write them 
below."
