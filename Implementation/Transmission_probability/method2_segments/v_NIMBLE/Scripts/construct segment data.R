library(readxl)
library(dplyr)
library(writexl)

# import data of experiments 

df <- read.csv("D:/Thesis/Tasks/DATA/seed_merged/experiment_6_2. contact duration 8h reduced_matrice_seed.csv")

#df1 <- subset(df, Cap1 != 376 & Cap1 != 742)

unique(df$Cap1)
unique(df$Cap2)

data <- data.frame()

for(i in unique(df$Cap1)){
  
  df_1m <- subset(df, Distance <= 0.3 & Cap1 == i)
  df_1m$experiment <- 6
  df_1m$duration <- 8
  df_1m$time <- round(nrow(df_1m)/60, 2)
  
  df_temp <- distinct(select(df_1m, experiment, duration, Cap1, Cap2, time))
  
  data <- rbind(data, df_temp)
}
View(data)

write_xlsx(data, "D:/Thesis/segmented_model/segmented_data.xlsx")

df_1m <- subset(df, Distance <= 0.3 & Cap2 == 3008)
df_1m$experiment <- 3
df_1m$duration <- 24
df_1m$time <- round(nrow(df_1m)/60, 2)

df_temp <- distinct(select(df_1m, experiment, duration, Cap1, Cap2, time))
