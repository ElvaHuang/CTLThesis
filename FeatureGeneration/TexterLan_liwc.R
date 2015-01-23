

##########################################################

##--      LIWC Texter Language Use Feature            --##

##########################################################


rm(list=ls())

## set working directory
setwd("D:/lele/Thesis")

## read in data
# readLines("./data/LIWC/texter/texter_results_1203.dat", n = 10)
texter_liwc <- read.table("./data/LIWC/LIWC2007_texter.dat", header = T)

## inspect data
dim(texter_liwc)
names(texter_liwc)
head(texter_liwc$Filename)

## create conv_id and subset the data
require(stringr)
texter_liwc$conv_id <- sapply(texter_liwc$Filename, function(i) str_sub(i, 1, regexpr("_",i) - 1))

texter_liwc <- texter_liwc[-c(1,2)]


## save
save(texter_liwc, file = "./data/texter_liwc.Rda")



