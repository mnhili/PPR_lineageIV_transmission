library(readxl)
library(dplyr)
library(ggplot2)

df <- read.csv("D:/Programming/project1/UWB_data_analysis/distance_boxplot/experiment_2_2. contact duration 24h_matrice_seed.csv")


ggplot(df, aes(x=Cap1, y=Distance), aes(group = x)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8) + coord_cartesian()
