library(ggbiplot)
library(FactoMineR)
require(caret)
setwd("C:/Users/Jason/Documents/BCBI/Atom/")
data <- read.csv("Sepsis_filled_merged_nacounted_coded1.csv", header = TRUE)

features <- data[,2:7]
label <- data[,14]

features$Age_Yrs <- as.numeric(as.character(features$Age_Yrs))
features$Temp <- as.numeric(as.character(features$Temp))
features$Pulse <- as.numeric(as.character(features$Pulse))
features$Resp <- as.numeric(as.character(features$Resp))
features$Bpsys <- as.numeric(as.character(features$Bpsys))
features$Bpdia <- as.numeric(as.character(features$Bpdia))
features$WBC_value <- as.numeric(as.character(features$WBC_value))
features$Glucose_value <- as.numeric(as.character(features$Glucose_value))
features$CO2_value <- as.numeric(as.character(features$CO2_value))
features$Creatinine_value <- as.numeric(as.character(features$Creatinine_value))
features$BUN_value <- as.numeric(as.character(features$BUN_value))
features$Platelets_value <- as.numeric(as.character(features$Platelets_value))

trans = preProcess(features, method=c("BoxCox", "center", "scale", "pca"))

PC = predict(trans, features)
PC <- cbind(PC,label)
PC <- na.omit(PC)
pca <- prcomp(PC[,1:11], center = TRUE, scale. = TRUE) 
pca3 = PCA(na.omit(features))



aload <- abs(pca$rotation)
dat<-sweep(aload, 2, colSums(aload), "/")
ev <- pca$sdev^2
write.csv(ev, file="eigen.csv")










g <- ggbiplot(pca, obs.scale = 10, var.scale = 1, 
              groups = PC[,12], ellipse = TRUE, 
              circle = TRUE, alpha=0.1)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)      

graph <- biplot(pca, scale=0)
print(graph)
