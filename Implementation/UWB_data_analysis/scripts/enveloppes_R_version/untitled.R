library(readr)
library(readxl)
library(dplyr)
library(writexl)
library(ggplot2)
library(httpgd)
library(plotly)
library(ggpubr)

df <- read_excel("minute/experiment_4_1. contact duration 24h_matrice_seed.xlsx")
df$Cap2 <- as.character(df$Cap2)
df <- subset(df, Cap2 == "255")

# df <- df[df$mean_dist < 2,]
threshold <- 2
below_threshold <- df$mean_dist <= threshold
indices <- which(below_threshold)

speed_seq <- split(df$mean_dist[indices],
                   cumsum(c(TRUE, diff(indices) > 3)))

speed_seq <-
  speed_seq[sapply(speed_seq, function(x)
    all(x <= threshold))]

filtered_rows <- df[indices, ]

time_seq <- lapply(speed_seq, function(x) {
  filtered_rows$time_min[filtered_rows$mean_dist %in% x]
})


# Calcul des intervalles de temps, de la durée et de la vitesse moyenne
result <- lapply(1:length(time_seq), function(i) {
  piece_times <- unlist(time_seq[[i]])
  piece_speeds <- unlist(speed_seq[[i]])
  
  start_time <- min(piece_times)
  end_time <- max(piece_times)
  duration <- length(piece_times)
  avg_speed <- mean(piece_speeds)
  
  return(
    data.frame(
      start_time = start_time,
      end_time = end_time,
      duration = duration,
      avg_speed = avg_speed
    )
  )
})

# Combinaison des résultats en un seul DataFrame
result_df <- do.call(rbind, result)

# Affichage du DataFrame résultant
print(result_df)

# Pour le traçage
breaks <- which(diff(unlist(time_seq)) > 1)

pieces <- split(time_seq, cut(seq_along(time_seq), breaks = c(0, breaks, length(time_seq))))
spd_pieces <- split(speed_seq, cut(seq_along(speed_seq), breaks = c(0, breaks, length(speed_seq))))

hgd()
# Fonction pour tracer une séquence individuelle

plot_sequence <- function(times, speeds) {
  if (length(times) > 1) {
    lines(times, speeds, col = "blue")
    points(times[1], speeds[1], col = "green", pch = 19) # Point de début en vert
    points(times[length(times)], speeds[length(speeds)], col = "red", pch = 19) # Point de fin en rouge
    
    # Calcul de la moyenne des vitesses
    avg_speed <- mean(speeds)
    
    # Calcul de la durée
    duration <- length(times)
    
    # Ajout du texte au graphique
    text_position <- mean(times)
    text_y_position <- max(speeds) + (y_max - y_min) * 0.05 # Ajustement pour éviter la superposition
    text(text_position, text_y_position, paste("Avg Speed:", round(avg_speed, 2), "\nDuration:", duration, "mins"), pos = 4, offset = 0.5, cex = 0.7)
    
  } else {
    points(times, speeds, col = "blue", pch = 4) # Utilisation de croix pour les points individuels
  }
}

# Préparation du graphique
y_min <- min(unlist(speed_seq))
y_max <- max(unlist(speed_seq))
plot(
  NA,
  type = "n",
  xlim = range(df$time_min),
  ylim = c(y_min, y_max),
  xlab = "Time",
  ylab = "Speed"
)

# Traçage de chaque séquence
for (i in seq_along(time_seq)) {
  plot_sequence(unlist(time_seq[[i]]), unlist(speed_seq[[i]]))
}

# =================================================================

# Création d'un dataframe pour le traçage
plot_data <- do.call(rbind, lapply(1:length(time_seq), function(i) {
  times <- unlist(time_seq[[i]])
  speeds <- unlist(speed_seq[[i]])
  
  avg_speed <- mean(speeds)
  duration <- (max(times) - min(times)) + 1
  
  data.frame(
    seq_id = i,
    time = times,
    speed = speeds,
    avg_speed = avg_speed,
    duration = duration
  )
}))

# Traçage avec ggplot2
ggplot(plot_data, aes(x = time, y = speed)) +
  geom_line(aes(group = seq_id), color = "blue") +
  geom_point(data = plot_data %>% group_by(seq_id) %>% slice(1), color = "green", size = 1) + # Point de début en vert
  geom_point(data = plot_data %>% group_by(seq_id) %>% slice(n()), color = "red", size = 1) + # Point de fin en rouge
  labs(x = "Time", y = "Speed") +
  theme_minimal()


p <- ggplot(plot_data, aes(x = time, y = speed, group = seq_id, 
                           color = paste("Avg Speed:", round(avg_speed, 2), 
                                         "- Duration:", duration, "mins"))) +
  geom_line() +
  # Highlight start and end points without inheriting the color aesthetic
  geom_point(data = plot_data %>% group_by(seq_id) %>% slice(1), aes(color = NULL), size = 1, color = "red") + # Start point
  geom_point(data = plot_data %>% group_by(seq_id) %>% slice(n()), aes(color = NULL), size = 1, color = "blue") + # End point
  
  # Customize the legend
  scale_color_discrete(name = "Sequence Info", guide = guide_legend(override.aes = list(size = 1))) +
  labs(x = "Time", y = "Speed") +
  theme_minimal()

p <- ggplotly(p)
p

# Create the ggplot
p2 <- ggplot(plot_data, aes(x = time, y = speed, group = seq_id)) +
  geom_line(aes(color = duration)) + # Color by duration
  
  # Annotate start points
  geom_text(data = plot_data %>% group_by(seq_id) %>% slice(1), 
            aes(label = "Start", y = speed + (y_max - y_min) * 0.05), 
            vjust = -0.5, hjust = 0.5, size = 3, color = "black") +
  
  # Annotate end points
  geom_text(data = plot_data %>% group_by(seq_id) %>% slice(n()), 
            aes(label = "End", y = speed + (y_max - y_min) * 0.05), 
            vjust = -0.5, hjust = 0.5, size = 3, color = "black") +
  
  # Highlight start and end points without inheriting the color aesthetic
  geom_point(data = plot_data %>% group_by(seq_id) %>% slice(1), aes(color = NULL), size = 3, color = "green") + # Start point
  geom_point(data = plot_data %>% group_by(seq_id) %>% slice(n()), aes(color = NULL), size = 3, color = "red") + # End point
  
  # Customize the color scale
  scale_color_gradient(name = "Duration (mins)", low = "blue", high = "red") +
  labs(x = "Time", y = "Speed") +
  theme_minimal()

p2 + xlim(min(plot_data$time) - 200, max(plot_data$time) + 200)

p2 + facet_wrap(~ seq_id, scales = "free_x")
# ==============================================================



library(viridis)

# Determine the number of unique sequences
num_colors <- length(unique(plot_data$seq_id))

# Generate a set of colors
colors <- viridis(num_colors)

# Create a mapping of seq_id to color
color_mapping <- data.frame(seq_id = unique(plot_data$seq_id), color = colors)

# Join this mapping back to the plot_data to assign colors to each sequence
plot_data <- merge(plot_data, color_mapping, by = "seq_id")

# 2. Map Colors to the Entire Dataframe
# Créer une colonne d'index pour chaque dataframe
df$index <- 1:nrow(df)
plot_data$index <- match(plot_data$time, df$time_min)

# Fusionner les dataframes en utilisant la colonne d'index
df <- merge(df, plot_data[, c("index", "color")], by = "index", all.x = TRUE)

# Supprimer la colonne d'index
df$index <- NULL
hgd_browse()
