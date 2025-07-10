library(readr)
library(readxl)
library(writexl)
library(dplyr)

df <- read.csv("output/experiment_6_2. contact duration 8h reduced_matrice_seed.csv")

df <- subset(df, select = -1)

df <- arrange(df, Cap1, Cap2, Time)

unique(df$Cap1)
unique(df$Cap2)

indices <- which(df$Cap1 == "3837" & df$Cap2 == "742")

df[indices, c("Cap1", "Cap2")] <- df[indices, c("Cap2", "Cap1")]

df <- arrange(df, Cap1, Cap2, Time)

unique(df$Cap1)
unique(df$Cap2)

write.csv(df, "one colomn pair/experiment_6_2. contact duration 8h reduced_matrice_seed.csv")
