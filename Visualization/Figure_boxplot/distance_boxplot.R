# Load required packages
library(readxl)
library(ggplot2)
library(dplyr)
library(gridExtra)

# Read the three Excel files
df1 <- read_excel("experiment_1_1. contact duration 1h_matrice_seed.xlsx")
df1$id <- "experiment_1_1h"
  
df2 <- read_excel("experiment_1_2. contact duration 6h_matrice_seed.xlsx")
df2$id <- "experiment_1_6h"
  
df3 <- read_excel("experiment_1_3. contact duration 24h_matrice_seed.xlsx")
df3$id <-  "experiment_1_24h"

  
df4 <- read_excel("experiment_2_2. contact duration 24h_matrice_seed.xlsx")
df3$id <-   "experiment_2_24h"
  
df5 <- read_excel("experiment_2_3. contact duration 44h_matrice_seed.xlsx")
df5$id <-   "experiment_2_44h"
  
df6 <- read_excel("experiment_3_2. contact duration 24h_matrice_seed.xlsx")
df6$id <- "experiment_3_24h"
df6 <- df6 %>%
  filter(Cap2 != 742 & Cap2 != 376)
  
df7 <- read_excel("experiment_4_1. contact duration 24h_matrice_seed.xlsx")
df7$id <- "experiment_4_24h"
  
df8 <- read_excel("experiment_4_2. contact duration 48h_matrice_seed.xlsx")
df8$id <- "experiment_4_48h"

df9 <- read_excel("experiment_5_1. contact duration 24h_matrice_seed.xlsx")
df9$id <- "experiment_5_24h"

df10 <- read_excel("experiment_5_2. contact duration 48h_matrice_seed.xlsx")
df10$id <- "experiment_5_48h"

df11 <- read_excel("experiment_6_2. contact duration 8h reduced_matrice_seed.xlsx")
df11$id <- "experiment_6_8h"



#===============================================================================

df1_plot <- ggplot(df1, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 1_1h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df1$Distance), color = "red", linetype = "dashed")

df1_plot

df2_plot <- ggplot(df2, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 1_6h") +
  coord_flip() + 
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df2$Distance), color = "red", linetype = "dashed")

df2_plot

df3_plot <- ggplot(df3, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 1_24h") +
  coord_flip() + 
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df3$Distance), color = "red", linetype = "dashed")

df3_plot


df4_plot <- ggplot(df4, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 2_24h") +
  coord_flip() + 
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df4$Distance), color = "red", linetype = "dashed")

df4_plot


df5_plot <- ggplot(df5, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 2_44h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df5$Distance), color = "red", linetype = "dashed")

df5_plot


df6_plot <- ggplot(df6, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 3_24h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df6$Distance), color = "red", linetype = "dashed")

df6_plot


df7_plot <- ggplot(df7, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 4_24h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df7$Distance), color = "red", linetype = "dashed")

df7_plot


df8_plot <- ggplot(df8, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 4_48h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df8$Distance), color = "red", linetype = "dashed")

df8_plot


df9_plot <- ggplot(df9, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 5_24h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df9$Distance), color = "red", linetype = "dashed")

df9_plot

df10_plot <- ggplot(df10, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 5_48h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df10$Distance), color = "red", linetype = "dashed")

df10_plot

df11_plot <- ggplot(df11, aes(x = factor(Cap2), y = Distance, fill= factor(Cap2))) +
  geom_boxplot(outlier.shape = 21, outlier.color = "red", outlier.size = 2, varwidth = TRUE, alpha=0.3) +
  labs(x = "Captor IDs", y = "Distance", title = "Boxplot for Distance/sec by Individual - experiment 6_8h") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10, by = 1), limits = c(0,10)) +
  geom_hline(yintercept = median(df11$Distance), color = "red", linetype = "dashed")

df11_plot


grid.arrange(df1_plot, df2_plot, df3_plot, nrow = 1)



all_medians = c(median(df1$Distance),
      median(df2$Distance),
      median(df3$Distance),
      median(df4$Distance),
      median(df5$Distance),
      median(df6$Distance),
      median(df7$Distance),
      median(df8$Distance),
      median(df9$Distance),
      median(df10$Distance),
      median(df11$Distance))

data <- data.frame(all_medians)

boxplot <- ggplot(data, aes(x = all_medians)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  labs(title = "Distribution of all experiments distance medians", x = "", y = "Medians")
boxplot

library(patchwork)

# Combine all plots into one grid
all_plots <- (df1_plot + df2_plot + df3_plot) /
  (df4_plot + df5_plot + df6_plot) /
  (df7_plot + df8_plot + df9_plot) /
  (df10_plot + df11_plot)

# Display the combined plot
all_plots
