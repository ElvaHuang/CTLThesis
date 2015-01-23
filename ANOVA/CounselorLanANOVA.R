
##########################################################

##--      Counselor Language Use ANOVA                --##

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
counslan <- merge(x = counselor_liwc, y = convo, by.x = "conv_id", by.y = "conv_id")

## MANOVA: language feature ~ texter_rating
names(counslan)

counslan.aov <- manova(as.matrix(counslan[, 2:65]) ~ texter_rating, counslan)
summary(counslan.aov)
summary.aov(counslan.aov)

capture.output(summary(counslan.aov), file = "./results/counselor_manova.doc")
capture.output(summary(counslan.aov), file = "./results/counselor_manova.xls")
capture.output(summary.aov(counslan.aov), file = "./results/counselor_manova.doc", append = TRUE)

