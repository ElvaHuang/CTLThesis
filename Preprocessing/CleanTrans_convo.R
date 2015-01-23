
#################################################################

##--      Data Cleaning & Transformation: Conversation Level --##

#################################################################

rm(list=ls())

## set working directory
setwd("C:/School/Thesis")

## load data
load("./data/convo_rated.Rda")
names(convo)
str(convo)

## convert id variable to factor
convo$conv_id <- as.factor(convo$conv_id)
convo$texter_id <- as.factor(convo$texter_id)
convo$counselor_id <- as.factor(convo$counselor_id)
convo$counselor_id <- as.factor(convo$counselor_id)
convo$last_message_id <- as.factor(convo$last_message_id)

## convert time-date variables

head(convo$conv_start)
conv_start <- strptime(convo$conv_start, "%Y-%m-%d %H:%M:%S",tz="UTC")
convo$conv_start <- as.POSIXct(conv_start)

head(convo$queue_enter)
queue_enter <- strptime(convo$queue_enter, "%Y-%m-%d %H:%M:%S",tz="UTC")
convo$queue_enter <- as.POSIXct(queue_enter)   

head(convo$queue_exit)
queue_exit <- strptime(convo$queue_exit, "%Y-%m-%d %H:%M:%S",tz="UTC")
convo$queue_exit <- as.POSIXct(queue_exit)   # this stored dates as seconds from January 1, 1970 & POSIXlt store them as list

conv_end <- strptime(convo$conv_end, "%Y-%m-%e %H:%M:%S",tz="UTC")
convo$conv_end <- as.POSIXct(conv_end)   # this stored dates as seconds from January 1, 1970 & POSIXlt store them as list



## specialist rating
unique(convo$Q36_visitor_feeling)  
  #much better is an old version, need to exclude that
sum(convo$Q36_visitor_feeling=="Much better",na.rm=T)
  # 81 much better
convo$Q36_visitor_feeling[convo$Q36_visitor_feeling=="Much better"] <- "reduced"

specialist_rating <- as.factor(convo$Q36_visitor_feeling) 
levels(specialist_rating)

sum(is.na(specialist_rating))   
  #5923 missing value

convo$specialist_rating <- specialist_rating



## texter rating
unique(convo$conv_rating)

convo$conv_rating[convo$conv_rating=="-1"] <- "worse"
convo$conv_rating[convo$conv_rating=="1"] <- "same"
convo$conv_rating[convo$conv_rating=="2"] <- "better"

texter_rating <- as.factor(convo$conv_rating) 

levels(texter_rating)
sum(is.na(texter_rating))   

convo$texter_rating <- texter_rating


## save 
save(convo, file = "./data/convo_rated_cleaned.Rda")
