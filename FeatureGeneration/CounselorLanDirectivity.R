
##########################################################

##--      Counselor Language Use: Directivity         --##

##########################################################

rm(list=ls())

## set working directory
setwd("D:/School/Thesis")

## read in convo meta data, counselor language feature data and texter language feature data
counselor <- read.csv("./data/counselor_liwc_rated.csv", header = T)
names(counselor)

texter <- read.csv("./data/texter_liwc_rated.csv", header = T)
names(texter)

convo <- read.csv("./data/convo_metaFeature_rated.csv", header = T)
names(convo)


## chronic texter and directivity: anova

couns_meta <- merge(x = counselor, y = convo, by.x = "conv_id", by.y = "conv_id")
names(couns_meta)

couns.aov <- aov(as.matrix(couns_meta$counselorDir_z) ~ texter_chronicity, couns_meta)
summary(couns.aov)

require(plyr)
mean.lan <- function(data) {
  mean(data$counselorDir_z)
}

couns_mean.chronicity <- ddply(couns_meta, .(texter_chronicity), mean.lan)

couns.aov <- aov(as.matrix(couns_meta$counselorDir_z) ~ texter_rating, couns_meta)
summary(couns.aov)

couns_mean.rating <- ddply(couns_meta, .(texter_rating), mean.lan)

require(ggplot2)

ggplot(data = couns_meta, aes(x = counselorDir_z)) + geom_density()
