
##########################################################

##--      Data Preprocessing: Message Level      --##

##########################################################


rm(list=ls())

## set working directory
setwd("C:/School/Thesis")

## read in data
ms <- read.csv("./data/ms_rated.csv", header = F, sep = ",", na.string = "", colClass = "character")   
colnames(ms) <- c("m_id", "conv_id", "actor_id", "message", "type", "area_code", "m_time")



## inspect data

str(ms)
sapply(names(ms),function(x)sum(is.na(ms[,x])))
  ## all type missing
  ## 85 messages missing
View(ms[is.na(ms$message), ])
View(ms[ms$conv_id %in% ms$conv_id[is.na(ms$message)], ])
  ## don't seem to have any pattern. Are these empty messages?
  ## based on areacode, a majority of these are sent by texters.
  ## can exclude from sample
head(ms)
  ## data is in time order:texter and specialist take turns in a conversation



## exclude records of missing messages
ms <- ms[!is.na(ms$message), ]

## create actor type variable based on area code and actor_id
unique(ms$area_code)
ms$type <- "texter"
ms$type[ms$area_code=="NA" & ms$actor_id!="1"] <- "counselor"
ms$type[ms$actor_id=="1"] <- "system"
unique(ms$type)
ms$type <- as.factor(ms$type)



## match message level data with convo level
load("./data/convo_rated.Rda")
length(unique(convo$conv_id)) == length(unique(ms$conv_id))
any(!(ms$conv_id %in% convo$conv_id))
  ## the two dataset match, with exactly the same conversations

save(ms,file="./data/ms_rated.Rda")
