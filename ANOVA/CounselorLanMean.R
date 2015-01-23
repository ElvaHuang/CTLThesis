
##########################################################

##--      Counselor Language Use: Diff in Means       --##

##########################################################

rm(list=ls())

## set working directory
setwd("D:/lele/Thesis")

## read in convo meta data, counselor language feature data
load("./data/convo_meta_feature.Rda")
load("./data/counselor_liwc.Rda")
names(convo)
names(counselor_liwc)


## merge 2 dataset
counselorlan <- merge(x = counselor_liwc, y = convo, by.x = "conv_id", by.y = "conv_id")
names(counselorlan)


## compute means for 3 levels of conv_rating

require(plyr)

mean.lan <- function(data) {
  colMeans(data[, 2:65])
}

counselorlan_mean.rating <- ddply(counselorlan, .(texter_rating), mean.lan)

## transpose the data frame
counselorlan_mean.rating <- t(counselorlan_mean.rating)
colname <- counselorlan_mean.rating[1, 1:3]
counselorlan_mean.rating <- counselorlan_mean.rating[-1, ]
colnames(counselorlan_mean.rating)  <- colname

## save the results
save(counselorlan_mean.rating, file = "./results/counselorlanmean_rating.csv")
capture.output(counselorlan_mean.rating, file ="./results/counselorlanmean_rating.xls")
## to solve encoding issue in chinese version excel



