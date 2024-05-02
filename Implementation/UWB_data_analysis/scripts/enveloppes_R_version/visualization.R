library(readr)
library(readxl)
library(dplyr)
library(writexl)
library(plotly)
library(ggpubr)
library(httpgd)

df <-read_excel("minute/experiment_1_1. contact duration 1h_matrice_seed.xlsx")

# Convert animal2 to a factor
df$Cap2 <- as.factor(df$Cap2)

# Create the scatterplot with colored labels
p1 <- ggplot(df, aes(x = time_min, y = mean_dist, color = Cap2)) +
  geom_point(alpha = 1) +
  geom_hline(yintercept = 2.5, color = "black") +
  geom_density_2d(alpha = 0.3, n = 100) +
  theme_minimal() +
  labs(color = "Cap2")

# Convert to an interactive plot
p1 <- ggplotly(p1)
p1

# =============================================================

summarized <- df %>%
  group_by(Cap2) %>%
  reframe(
    mean = mean(mean_dist),
    min = min(mean_dist),
    max = max(mean_dist)
  )

# =============================================================
# Get all unique patient names
captors <- unique(df$Cap2)

all_results <- list()
all_plots <- list()

for (cap in captors) {
  cap_df <- subset(df, Cap2 == cap)
  
  threshold <- 2
  sous_seuil <- cap_df$mean_dist <= threshold
  indices <- which(sous_seuil)
  group_changes <- c(TRUE, diff(indices) > 5 & cap_df$mean_dist[indices[-1]] < threshold)
  groupes <- cumsum(group_changes)
  intervals <- tapply(indices, groupes, range)
  
  # Calculer la période (durée) pour chaque intervalle
  durations <- lapply(intervals, function(x) {
    start_time <- cap_df$time_min[x[1]]
    end_time <- cap_df$time_min[x[2]]
    duration <-
      as.numeric(difftime(end_time, start_time, units = 'secs'))
    return(duration)
  })
  
  # Calculer la moyenne du rythme cardiaque pour chaque intervalle
  avg_distance <- lapply(intervals, function(x) {
    mean_distance <- mean(cap_df$mean_dist[x[1]:x[2]])
    return(mean_distance)
  })
  
  # Combiner les résultats dans un dataframe
  results <- data.frame(
    Captor = rep(cap, length(durations)),
    Interval_Start = sapply(intervals, `[`, 1),
    Interval_End = sapply(intervals, `[`, 2),
    Exposure_Time = unlist(durations),
    Avg_distance = unlist(avg_distance)
  )
  
  # Store the results in the list
  cap_df$group <- NA
  for (i in 1:length(intervals)) {
    cap_df$group[intervals[[i]][1]:intervals[[i]][2]] <- i
  }
  
  all_results[[cap]] <- results
  
  # Create the plot for the current patient
  plot <- ggplot(cap_df, aes(x=time_min, y=mean_dist)) + 
    geom_point(aes(color=factor(group)), alpha=0.5) + 
    scale_color_discrete(name='Groupes') +
    geom_hline(yintercept=threshold, linetype='dashed', color='red') +
    theme_minimal() +
    labs(title=paste('Groupes consécutifs respectant le seuil pour', cap), y='Average Distance (meter)', x='Time (min)')
  
  # Store the plot in the list
  all_plots[[cap]] <- plot
  
  # Optionally, save the plot to a file
  ggsave(filename=paste0(cap, "_plot.png"), plot=plot, width=10, height=6)
}

# Combine all results into a single dataframe
final_results <- do.call(rbind, all_results)



# =========================================================
animal <- subset(df, Cap1 == 436)
# 
# # Création d'une nouvelle colonne pour identifier les groupes
# animal$group <- NA
# for (i in 1:length(intervals)) {
#   animal$group[intervals[[i]][1]:intervals[[i]][2]] <- i
# }
# 
# # Visualisation avec ggplot2
# p2 <- ggplot(animal, aes(x = time_min, y = mean_dist)) +
#   geom_point(aes(color = factor(group)), alpha = 0.5) +
#   scale_color_discrete(name = 'Groupes') +
#   geom_hline(yintercept = threshold,
#              linetype = 'dashed',
#              color = 'red') +
#   theme_minimal() +
#   labs(title = 'Groupes consécutifs respectant le seuil', y = 'distance', x =
#          'exposure time')
# 
# p2 <- ggplotly(p2)
# 
# p2
hgd()
# Calculer la Transformée de Fourier Rapide (FFT)
fft_result <- fft(animal$mean_dist)

fft_result

# Afficher le spectre de magnitude
plot(Mod(fft_result), type='l', main="Magnitude Spectrum", ylab="Magnitude", xlab="Frequency")


linear_model <- lm(animal$mean_dist ~ animal$time_min)

# Afficher le résumé du modèle
summary(linear_model)

# Tracer la série temporelle avec la tendance
plot(animal$time_min, animal$mean_dist, type="l", main="Distance over Time with Trend", ylab="Distance", xlab="Time")
abline(linear_model, col="red")

hgd_browse()
