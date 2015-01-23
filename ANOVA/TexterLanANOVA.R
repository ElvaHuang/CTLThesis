
##########################################################

##--      Texter Language Use ANOVA                   --##

##########################################################

rm(list=ls())

## set working directory
setwd("D:/School/Thesis")

## read in convo meta data, texter language feature data
load("./data/convo_meta_feature.Rda")
load("./data/texter_liwc.Rda")
names(convo)
names(texter_liwc)

## merge 2 dataset
texterlan <- merge(x = texter_liwc, y = convo, by.x = "conv_id", by.y = "conv_id")

## MANOVA: language feature ~ rating
names(texterlan)

texterlan.aov <- manova(as.matrix(texterlan[, 2:65]) ~ texter_rating, texterlan)
summary(texterlan.aov)
summary.aov(texterlan.aov)

capture.output(summary(texterlan.aov), file = "./results/texter_manova.doc")
# capture.output(summary(texterlan.aov), file = "./results/texter_manova.xls")
capture.output(summary.aov(texterlan.aov), file = "./results/texter_manova.doc", append = TRUE)

## MANOVA : language feature ~ chronicity
texterlan.aov <- manova(as.matrix(texterlan[, 2:65]) ~ texter_chronicity, texterlan)
summary(texterlan.aov)
summary.aov(texterlan.aov)
capture.output(summary(texterlan.aov), file = "./results/texter_manova.doc", append = TRUE)


