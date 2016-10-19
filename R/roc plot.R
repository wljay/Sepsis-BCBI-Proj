library(pROC)
setwd("C:/Users/Jason/Documents/BCBI/Atom/ROC45k")
setwd("C:/Users/Jason/Documents/BCBI/Atom/ROC500")
temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i]))


rocobj1 <- plot.roc(DecisionTree.csv$x1, DecisionTree.csv$x3, percent=TRUE, main="500", col="#8dd3c7", lwd=3, ci=TRUE, print.auc=TRUE)
rocobj2 <- lines.roc(LinearDiscriminantAnalysis.csv$x1, LinearDiscriminantAnalysis.csv$x3, percent=TRUE, col="#bebada", lwd=3)
rocobj3 <- lines.roc(LinearSVM.csv$x1, LinearSVM.csv$x3, percent=TRUE, col="#fb8072", lwd=3)
rocobj4 <- lines.roc(NaiveBayes.csv$x1, NaiveBayes.csv$x3, percent=TRUE, col="#80b1d3", lwd=3)
rocobj5 <- lines.roc(NearestNeighbors.csv$x1, NearestNeighbors.csv$x3, percent=TRUE, col="#fdb462", lwd=3)
rocobj6 <- lines.roc(QuadraticDiscriminantAnalysis.csv$x1, QuadraticDiscriminantAnalysis.csv$x3, percent=TRUE, col="#b3de69", lwd=3)
rocobj7 <- lines.roc(RandomForest.csv$x1, RandomForest.csv$x3, percent=TRUE, col="#fccde5", lwd=3)
rocobj8 <- lines.roc(RBFSVM.csv$x1, RBFSVM.csv$x3, percent=TRUE, col="#d9d9d9", lwd=3)


#legend("right", legend=c("Decision Tree", "Linear Discriminant Analysis", "Linear SVM", "Naive Bayes", "Nearest Neighbors", "Quadratic Discriminant Analysis", "Random Forest", "RBF SVM"), col=c("#8dd3c7","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9"), lwd=2)

names <- c("Decision Tree", "Linear Discriminant Analysis", "Linear SVM", "Naive Bayes", "Nearest Neighbors", "Quadratic Discriminant Analysis", "Random Forest", "RBF SVM")
auc_scores <- array()

psens <- array()
testobj <- roc.test(rocobj7, rocobj1)
psens <- rbind(psens, testobj$p.value)
testobj <- roc.test(rocobj7, rocobj2)
psens <- rbind(psens, testobj$p.value)
testobj <- roc.test(rocobj7, rocobj3)
psens <- rbind(psens, testobj$p.value)
testobj <- roc.test(rocobj7, rocobj4)
psens <- rbind(psens, testobj$p.value)
testobj <- roc.test(rocobj7, rocobj5)
psens <- rbind(psens, testobj$p.value)
testobj <- roc.test(rocobj7, rocobj6)
psens <- rbind(psens, testobj$p.value)
testobj <- roc.test(rocobj7, rocobj8)
psens <- rbind(psens, testobj$p.value)

pspec

for (i in 1:length(temp)){
  t <- read.csv(temp[i])
  auc_scores <- c(auc_scores, auc(t[,1],t[,3]))
}

ci_auc <- array()
for (i in 1:length(temp)){
  t <- read.csv(temp[i])
  ci_auc <- rbind(ci_auc, ci.auc(t[,1],t[,3]))
}

se <- array()
for (i in 1:length(temp)){
  t <- read.csv(temp[i])
  se <- rbind(se,ci.se(roc(t[,1],t[,3]), specificities = 0.77))
}

sp <- array()
for (i in 1:length(temp)){
  t <- read.csv(temp[i])
  sp <- rbind(sp,ci.sp(roc(t[,1],t[,3]), sensitivities = 0.7))
}

ci <- rbind(ci.auc(DecisionTree.csv$x1, DecisionTree.csv$x3), ci.auc(LinearDiscriminantAnalysis.csv$x1, LinearDiscriminantAnalysis.csv$x3), ci.auc(LinearSVM.csv$x1, LinearSVM.csv$x3), ci.auc(NaiveBayes.csv$x1, NaiveBayes.csv$x3), ci.auc(NearestNeighbors.csv$x1, NearestNeighbors.csv$x3), ci.auc(QuadraticDiscriminantAnalysis.csv$x1, QuadraticDiscriminantAnalysis.csv$x3), ci.auc(RandomForest.csv$x1, RandomForest.csv$x3), ci.auc(RBFSVM.csv$x1, RBFSVM.csv$x3))
auc_scores <- c(auc(DecisionTree.csv$x1, DecisionTree.csv$x3), auc(LinearDiscriminantAnalysis.csv$x1, LinearDiscriminantAnalysis.csv$x3), auc(LinearSVM.csv$x1, LinearSVM.csv$x3), auc(NaiveBayes.csv$x1, NaiveBayes.csv$x3), auc(NearestNeighbors.csv$x1, NearestNeighbors.csv$x3), auc(QuadraticDiscriminantAnalysis.csv$x1, QuadraticDiscriminantAnalysis.csv$x3), auc(RandomForest.csv$x1, RandomForest.csv$x3), auc(RBFSVM.csv$x1, RBFSVM.csv$x3))
auc_table <- cbind(names, auc_scores[3:10], ci_auc[3:10,], se[3:10,], sp[3:10])


auc_table
write.csv(auc_table, file = "C:/Users/Jason/Documents/BCBI/Atom/auc_score_table_detailed.csv")
write.csv(sp, file = "C:/Users/Jason/Documents/BCBI/Atom/sp.csv")
write.csv(se, file = "C:/Users/Jason/Documents/BCBI/Atom/se.csv")

#data = read.csv("C:/Users/Jason/Documents/BCBI/Atom/true-pred-roc used for proj.csv")
#data1 = read.csv("C:/Users/Jason/Documents/BCBI/Atom/roc_Nearest Neighbors.csv")
#data2 = read.csv("C:/Users/Jason/Documents/BCBI/Atom/roc_Decision Tree (Julia).csv")
testobj <- roc.test(rocobj7, rocobj5)
text(50, 50, labels=paste("p-value =", format.pval(testobj$p.value)), adj=c(0, .5))


#library(ROCR)
pred <- prediction(data$x3, data$x1)
perf <- performance (pred, measure="tpr", x.measure="fpr")
plot(perf, xaxis.col='green' )

pred1 <- prediction(data1$x3, data1$x1)
perf1 <- performance (pred1, measure="tpr", x.measure="fpr")
plot(perf1, colorize=TRUE, add=TRUE)



