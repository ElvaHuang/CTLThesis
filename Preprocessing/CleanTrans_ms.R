
#################################################################

##--      Data Cleaning & Transformation: Message Level      --##

#################################################################

rm(list=ls())

## set working directory
setwd("C:/School/Thesis")

## load data
load("./data/ms_rated.Rda")

## summary
names(ms)
str(ms)

## transform
for(i in c(1:3,6)){
  ms[,i] <- as.factor(ms[,i])
}


## convert message time
m_time <- strptime(ms$m_time, "%Y-%m-%d %H:%M:%S",tz="UTC")
any(is.na(m_time)) 
  # no missing value 
m_time <- as.POSIXct(m_time)  
ms$m_time <- m_time


## clean out confusing regular expression
require(stringr)
# ms$message <- str_replace_all(ms$message,"\\*","")
# ms$message <- str_replace_all(ms$message,"\\("," ")
# ms$message <- str_replace_all(ms$message,"\\)"," ")
  ## emoticon 
# ms$message <- str_replace_all(ms$message,"\\\\"," ")
# ms$message <- str_replace_all(ms$message,"\\["," ")
# ms$message <- str_replace_all(ms$message,"\\]"," ")
# ms$message <- str_replace_all(ms$message,"\\+"," ")
# ms$message <- str_replace_all(ms$message,"\\^"," ")
# ms$message <- str_replace_all(ms$message,"\\{"," ")
# ms$message <- str_replace_all(ms$message,"\\}"," ")


## clean special punctuations
ms$message <- str_replace_all(ms$message,"\\.\\.\\.", "\\.")
ms$message <- str_replace_all(ms$message,"\\.\\.", "\\.")

## save

save(ms, file="./data/ms_rated_cleaned.Rda")


