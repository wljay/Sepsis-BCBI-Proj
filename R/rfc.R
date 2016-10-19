setwd("C:/Users/Jason/Documents/BCBI/Atom")
df = read.csv("Sepsis_final2.csv")
library("mice")
library("randomForestSRC")
library("VIM")
df1=df[1:10000,2:16]

aggr_plot <- aggr(df, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))
forest <- rfsrc(Blood_Culture_value ~., data = df1, importance = TRUE)

df2=df[10001:20000,2:16]
pred<- predict(forest,df2)

find.interaction(forest, method="vimp", nrep =3, na.action = "na.impute")
forest1 <- rfsrc(Blood_Culture_value ~., data = df, importance = FALSE, nodesize=42)