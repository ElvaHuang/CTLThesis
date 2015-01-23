
##########################################################

##--      Data Preprocessing: Conversation Level      --##

##########################################################

rm(list=ls())

## set working directory
setwd("C:/School/Thesis")


## read in data
convo <- read.csv("./data/convo_rated.csv", header=T, sep=",", na.string="", colClass="character")   


## inspect data
str(convo)
names(convo)

sapply(names(convo), function(x) sum(is.na(convo[,x])))
  # data missing for all post-convo survey questions
  # data missing for phone number request and conversation rating description
  # data complete for texter rating coded as conv_rating

## general conversation info data
length(unique(convo$conv_id))
  # all conversations are unique, 18021 conversations in total
length(unique(convo$texter_id))
  # 12773 unique texters, meaning there are repeat texters
length(unique(convo$counselor_id))
  # 410 unique counselors 
length(unique(convo$crisis_center))
  # 12 unique crisis centers
unique(convo$crisis_center)
length(unique(convo$specialist_name))
head(convo$specialist_name)
  # less than unique counselor_id, why? Can one specialist have multiple id?
  # can be used for determining gender of specialist
head(convo[,6:11]); tail(convo[,6:11])
  # multiple timestamp as string, need to be transformed
table(convo$Q2_conv_type)
# specialist fill out single choice, 10 categories
# may need to filter irrelavent conversations

## texter risk level related data
unique(convo$Q66_suicidal_intent); unique(convo$Q67_suicidal_capability); unique(convo$Q75_active_rescue)
  # gathered from survey questions for risk assessment
table(convo$phone_number_requested)
  # 0 for not requested, 1 for requested?
unique(convo$Q78_desire_notes)
  # specialist notes, unstructured

## texter issue related data
unique(convo$Q15_presenting_issue)
  # specialist notes, unstructured
unique(convo$Q79_main_issue)
  # specialist fill out multiple choice
unique(convo$Q13_issues)
  # specialist fill out multiple choice

## outcome evaluation related data
table(convo$engaged)
# all engaged conversation
unique(convo$Q8_conv_resolution)
  # combinition of assisted, rescued, referral, transfer, abuse_report, other, disengaged
table(convo$Q36_visitor_feeling)
  # counselor report anxiety level of texters, 3 level
unique(convo$conv_rating_desc)
  # texter self-report immediate outcome detail
table(convo$conv_rating)
  # texter report conversation outcome, 3 levels

## write out data as Rda file
save(convo,file="./data/convo_rated.Rda")


