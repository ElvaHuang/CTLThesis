
##########################################################

##--      Texter Language Use: Diff in Means         --##

##########################################################

rm(list=ls())

## set working directory
setwd("D:/lele/Thesis")

## read in convo meta data, texter language feature data
load("./data/convo_meta_feature.Rda")
load("./data/texter_liwc.Rda")
names(convo)
names(texter_liwc)


## merge 2 dataset
texterlan <- merge(x = texter_liwc, y = convo, by.x = "conv_id", by.y = "conv_id")
names(texterlan)


## compute means for 3 levels of conv_rating

require(plyr)

mean.lan <- function(data) {
  colMeans(data[, 2:65])
}

texterlan_mean.rating <- ddply(texterlan, .(texter_rating), mean.lan)

## transpose the data frame
texterlan_mean.rating <- t(texterlan_mean.rating)
colname <- texterlan_mean.rating[1, 1:3]
texterlan_mean.rating <- texterlan_mean.rating[-1, ]
colnames(texterlan_mean.rating)  <- colname

## save the results
save(texterlan_mean.rating, file = "./results/texterlanmean_rating.csv")
capture.output(texterlan_mean.rating, file ="./results/texterlanmean_rating.xls")
  ## to solve encoding issue in chinese version excel



## compute means for 3 levels of chronicity

texterlan_mean.chron <- ddply(texterlan, .(texter_chronicity), mean.lan)

## transpose the data frame
texterlan_mean.chron <- t(texterlan_mean.chron)
colname <- texterlan_mean.chron[1, 1:3]
texterlan_mean.chron <- texterlan_mean.chron[-1, ]
colnames(texterlan_mean.chron)  <- colname

## save the results
save(texterlan_mean.chron, file = "./results/texterlanmean_chron.csv")
capture.output(texterlan_mean.chron, file ="./results/texterlanmean_chron.xls")
  ## to solve encoding issue in chinese version excel

