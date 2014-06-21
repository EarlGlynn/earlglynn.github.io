# Adapted selected comments from thread
# "Course project - pre processing, feature extraction and PCA

setwd("C:/MOOC/2014/coursera/2014-02-H-Machine-Learning/Peer-Assessment/")
#setwd("C:/Users/efg/Desktop/caret/")

###############################################################################

sink("assignment1.txt", split=TRUE)
pdf("assignment1.pdf")

library(caret)

time.stamp <- function()
{
  print(format(Sys.time(), "%Y-%m-%d-%H:%M:%S"))
}

###############################################################################

time.stamp()

### load data
rawTrain <- read.csv("pml-training.csv", as.is=TRUE, na.strings=c("", "NA", "#DIV/0!"))
rawTrain$classe <- as.factor(rawTrain$classe)
dim(rawTrain)

rawFinalTest  <- read.csv("pml-testing.csv",  as.is=TRUE, na.strings=c("", "NA", "#DIV/0!"))
rawFinalTest$problem_id <- as.factor(rawFinalTest$problem_id)
dim(rawFinalTest)

### Compute number of NAs per column
NAs <- apply(rawTrain, 2, function(x) { sum(is.na(x)) } )
table(NAs)

# Discard if > 97.9% missing
names(rawTrain)[NAs > 19000]

# Keep if no missing values
KEEP <- names(rawTrain)[NAs == 0]

# For now, remove first six variables.
# Some would be more difficult to use in analysis.
KEEP[1:6]
#[1] "X"                    "user_name"            "raw_timestamp_part_1"
#[4] "raw_timestamp_part_2" "cvtd_timestamp"       "new_window"
KEEP <- KEEP[-1:-6]

LAST <- length(KEEP)
# KEEP[LAST] == "classe" is the classifier

subsetTrain <- rawTrain[,KEEP]
dim(subsetTrain)

FinalTest  <- rawFinalTest[,c(KEEP[-LAST], "problem_id")]
dim(FinalTest)

str(subsetTrain)

###############################################################################
### Correlation Matrix

cor.matrix <- cor(subsetTrain[,-LAST])

### Identify and remove variables with correlation of 0.90 or greater
cor.high   <- findCorrelation(cor.matrix, 0.90)
cor.high

high.corr.remove <- row.names(cor.matrix)[cor.high]
high.corr.remove
#> high.corr.remove
#[1] "accel_belt_z"     "roll_belt"        "accel_belt_y"
#[4] "accel_belt_x"     "gyros_arm_y"      "gyros_forearm_z"
#[7] "gyros_dumbbell_x"

subsetTrain       <- subsetTrain[,     -cor.high]
FinalTest   <- FinalTest[, -cor.high]

dim(subsetTrain)
dim(FinalTest)

KEEP <- KEEP[!(KEEP %in% high.corr.remove)]
LAST <- length(KEEP)

cor.matrix <- cor(subsetTrain[,-LAST])
heatmap(cor.matrix)

###############################################################################
### SVD

svd1 <- svd(scale(subsetTrain[,-LAST]))
plot(cumsum(svd1$d^2/sum(svd1$d^2)), pch = 19,
     main = "Weight Lifting Methods",
     xlab = "Number of features identified by SVD",
     ylab = "Cumulative percent of variance explained", ylim=c(0,1))
grid()

###############################################################################
### Establish training and in validation subsets of original training file

inTrain <- createDataPartition(y=subsetTrain$classe, p=0.75, list=FALSE)

training <- subsetTrain[inTrain,]
dim(training)

nsv <- nearZeroVar(training, saveMetrics=TRUE)
nsv

Validation  <- subsetTrain[-inTrain,]
dim(Validation)

###############################################################################

time.stamp()
dev.off()
sink()

sink("assignment2.txt", split=TRUE)
pdf("assignment2.pdf")

###############################################################################
### Linear Discriminant Analysis (LDA)

time.stamp()

fit.LDA <- train(classe ~ ., data=training,
                 preProcess=c("center", "scale"), method="lda")
fit.LDA
varImp(fit.LDA)
dotPlot(varImp(fit.LDA), main="LDA: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.LDA, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.LDA <- predict(fit.LDA, newdata=FinalTest)
final.LDA

###############################################################################
### Quadratic Discriminant Analysis (QDA)

time.stamp()

fit.QDA <- train(classe ~ ., data=training,
                 preProcess=c("center", "scale"), method="qda")
fit.QDA
varImp(fit.QDA)
dotPlot(varImp(fit.QDA), main="QDA: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.QDA, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.QDA <- predict(fit.QDA, newdata=FinalTest)
final.QDA

###############################################################################
### Regression Partitioning (rpart)

set.seed(19)   # for reproducibility
time.stamp()

fit.rpart <- train(classe ~., data = training, method="rpart")
fit.rpart
varImp(fit.rpart)
dotPlot(varImp(fit.rpart), main="rpart: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.rpart, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.rpart <- predict(fit.rpart, newdata=FinalTest)
final.rpart


###############################################################################

time.stamp()
dev.off()
sink()

sink("assignment3.txt", split=TRUE)
pdf("assignment3.pdf")

###############################################################################
### Random forests

set.seed(219)  # for reproducibility
time.stamp()

fit.rf <- train(classe ~., data = training, method="rf", prox=TRUE)
fit.rf
varImp(fit.rf)
dotPlot(varImp(fit.rf), main="rf: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.rf, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.rf <- predict(fit.rf, newdata=FinalTest)
final.rf

###############################################################################
### Boosting with trees

set.seed(19937)   # for reproducibility
time.stamp()

fit.gbm <- train(classe ~., data = training, method="gbm")
fit.gbm
varImp(fit.gbm)
dotPlot(varImp(fit.gbm), main="gbm: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.gbm, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.gbm <- predict(fit.gbm, newdata=FinalTest)
final.gbm

###############################################################################

time.stamp()
dev.off()
sink()

sink("assignment4.txt", split=TRUE)
pdf("assignment4.pdf")

###############################################################################
### Support Vector Machine (svmPoly)

time.stamp()

fit.svm <- train(classe ~., data = training, method="svmPoly")
fit.svm
varImp(fit.svm)
dotPlot(varImp(fit.svm), main="svm: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.svm, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.svm <- predict(fit.svm, newdata=FinalTest)
final.svm

###############################################################################
### treebag

set.seed(37)   # for reproducibility
time.stamp()

fit.treebag <- train(classe ~., data = training, method="treebag")
fit.treebag
varImp(fit.treebag)
dotPlot(varImp(fit.treebag), main="treebag: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.treebag, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.treebag <- predict(fit.treebag, newdata=FinalTest)
final.treebag

###############################################################################

time.stamp()
dev.off()
sink()

sink("assignment5.txt", split=TRUE)
pdf("assignment5.pdf")

###############################################################################
### bagFDA

# library(earth)
# library(mda)

set.seed(203)   # for reproducibility
time.stamp()

fit.bagFDA <- train(classe ~., data = training, method="bagFDA")
fit.bagFDA
varImp(fit.bagFDA)
dotPlot(varImp(fit.bagFDA), main="bagFDA: Dotplot of variable importance values")

OutOfSampleEstimate  <- predict(fit.bagFDA, newdata=Validation)
confusionMatrix(Validation$classe, OutOfSampleEstimate)

final.bagFDA <- predict(fit.bagFDA, newdata=FinalTest)
final.bagFDA

###############################################################################
time.stamp()

dev.off()
sink()

