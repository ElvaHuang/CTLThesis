
##########################################################

##--      Data Preparation for Modeling               --##

##########################################################

rm(list=ls())


## set working directory
setwd("D:/School/Thesis")


## read in convo meta data, texter language feature data, and counselor language feature data
convo <- read.csv("./data/convo_metaFeature_rated.csv", header = T)
counselor <- read.csv("./data/counselor_liwc_rated.csv", header = T)
texter <- read.csv("./data/texter_liwc_rated.csv", header = T)

names(convo)
names(counselor)
names(texter)


## convert severity to binary

unique(convo$severity) # missing data
convo$severity.b <- 0
convo$severity.b[convo$severity == 5] <- 1
table(convo$severity.b)


## mark linguistic features with counselor or texter

names(counselor) <- paste("c_", names(counselor), sep="")
names(texter) <- paste("t_", names(texter), sep="")
names(convo) <- paste("m_", names(convo), sep="")

# merge three data set using conv_id

convo_counselor <- merge(x = convo, y = counselor, by.x = "m_conv_id", by.y = "c_conv_id")
names(convo_counselor)
convo_counselor_texter <- merge (x = convo_counselor, y = texter, by.x = "m_conv_id", by.y = "t_conv_id")
names(convo_counselor_texter)


## delete unwanted columns: 
## c_X, c_Dic, c_leadership_simple, c_leadership_complex, c_leadership_z
## t_X, t_Dic, t_leadership_simple, t_leadership_complex, t_leadership_z, 
## m_X, m_texter_id, m_counselor_id, m_specialist_name, 
## m_specialist_rating, m_severity, m_texter_rating_desc

unwant.index <- which(names(convo_counselor_texter) %in% c("c_X", "c_Dic", "c_leadership_simple", "c_leadership_complex", "c_leadership_z",
                                           "t_X", "t_Dic", "t_leadership_simple", "t_leadership_complex", "t_leadership_z",
                                           "m_X", "m_texter_id", "m_counselor_id", "m_specialist_name",
                                           "m_specialist_rating", "m_severity", "m_texter_rating_desc"))

data <- convo_counselor_texter[, -unwant.index]
names(data)

save(data, file = "./data/data_aggregated.Rda")
save(data, file = "./data/data_aggregated.csv")


## train test split 3/4 1/4
set.seed(123456)
test.index <- sample(1:nrow(data), size = 4570, replace = F)

test <- data[test.index, ]
table(test$m_texter_rating)
save(test, file = "./data/test.Rda")
save(test, file = "./data/test.csv")


train <- data[-test.index, ]
table(train$m_texter_rating)
save(train, file = "./data/train.Rda")
save(train, file = "./data/train.csv")

