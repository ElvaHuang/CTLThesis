

##########################################################

##--      LIWC Counselor Language Use Feature         --##

##########################################################


rm(list=ls())

## set working directory
setwd("C:/School/Thesis")

## read in data
# readLines("./data/LIWC/counselor/counselor_results_1203.dat", n = 10)
counselor_liwc <- read.table("./data/LIWC/LIWC2007_counselor.dat", header = T)

## inspect data
dim(counselor_liwc)
names(counselor_liwc)
head(counselor_liwc$Filename)

## create conv_id and subset the data
require(stringr)
counselor_liwc$conv_id <- sapply(counselor_liwc$Filename, function(i) str_sub(i, 1, regexpr("_",i) - 1))

counselor_liwc <- counselor_liwc[-c(1,2)]


## save
save(counselor_liwc, file = "./data/counselor_liwc.Rda")
