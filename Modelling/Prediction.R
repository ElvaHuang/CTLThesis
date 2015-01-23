
##########################################################

##--      Prediction                                 --##

##########################################################

rm(list=ls())


## set working directory
setwd("D:/School/Thesis")


## read in convo meta data, texter language feature data, and counselor language feature data
load("./data/train.Rda")
load("./data/test.Rda")
load("./data/data_aggregated.Rda")


## multinomial logistic regression
require(foreign)
require(nnet)
require(caret)
# require(DAAG)
require(boot)

train$outcome <- relevel(train$m_texter_rating, ref = "same")
test$outcome <- relevel(test$m_texter_rating, ref = "same")
data$outcome <- relevel(data$m_texter_rating, ref = "same")
head(train$outcome)

model0 <- multinom(outcome ~ ., data = train[,c(2:9,11:16,176)])
predict0 <- predict(model0, newdata = test[,c(2:9,11:16)])
confusion0 <- confusionMatrix(data = predict0, reference = test$outcome)
confusion0

# model00 <- multinom(outcome ~ ., data = data[,c(2:9,11:16,176)])
# cv.glm(data = data[,c(2:9,11:16,176)], glmfit = model00, K = 5)

model1 <- multinom(outcome ~ ., data = train[,-c(1,10)])
predict1 <- predict(model1, newdata = test[,-c(1,10,176)])
confusion1 <- confusionMatrix(data = predict1, reference = test$outcome)
confusion1


## logistic regression
table(train$outcome)

## treats same and worse as not better
train$outcome.bb <- 0
train$outcome.bb[train$outcome == "better"] <- 1
table(train$outcome.bb)

test$outcome.bb <- 0
test$outcome.bb[test$outcome == "better"] <- 1
table(test$outcome.bb)

## treats same and better as not worse
train$outcome.bw <- 0
train$outcome.bw[train$outcome == "worse"] <- 1
table(train$outcome.bw)

test$outcome.bw <- 0
test$outcome.bw[test$outcome == "worse"] <- 1
table(test$outcome.bw)


## binomial logistic regression
if(FALSE){
  model2 <- glm(outcome.bb ~ ., data = train[,-c(1,10,176,178)])
  predict2 <- predict(model2, newdata = test[,-c(1,10,176,177,178)])
  
  predict2[predict2>=0.5] <- 1 
  predict2[predict2<0.5] <- 0
  
  confusion2 <- confusionMatrix(data = predict2, reference = test$outcome.bb)
  confusion2
}

model2 <- glm(outcome.bw ~ ., data = train[,-c(1,10,176,177)])
predict2 <- predict(model2, newdata = test[,-c(1,10,176,177,178)])

predict2[predict2>=0.5] <- 1 
predict2[predict2<0.5] <- 0

confusion2 <- confusionMatrix(data = predict2, reference = test$outcome.bw)
confusion2


## svm
require(e1071)
model3 <- svm(outcome ~ ., data = train[,-c(1,10,177,178)])
predict3 <- predict(model3, newdata = test[,-c(1,10,177,176,178)])
confusion3 <- confusionMatrix(data = predict3, reference = test$outcome)
confusion3

if(FALSE){
  model4 <- svm(outcome.bb ~ ., data = train[,-c(1,10,176,178)])
  predict4 <- predict(model4, newdata = test[,-c(1,10,176,177,178)])
  predict4[predict4>=0.5] <- 1 
  predict4[predict4<0.5] <- 0
  confusion4 <- confusionMatrix(data = predict4, reference = test$outcome.bb)
  confusion4
}

model4 <- svm(outcome.bw ~ ., data = train[,-c(1,10,176,177)])
predict4 <- predict(model4, newdata = test[,-c(1,10,176,177,178)])
predict4[predict4>=0.5] <- 1 
predict4[predict4<0.5] <- 0
confusion4 <- confusionMatrix(data = predict4, reference = test$outcome.bw)
confusion4





