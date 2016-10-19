setwd("C:/Users/Jason/Documents/BCBI/Atom")
library(psych)
data <- read.csv("Sepsis_final3.csv", header = TRUE)

csv <- describe(data)
write.csv(csv, file="sepsis description.csv")
