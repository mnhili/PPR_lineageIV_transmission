# Libraries
library(readxl)
library(writexl)
library(ggplot2)
library(viridis)
library(tidyverse)

setwd("D:/Thesis/Tasks/DATA")

data_folder <- "minute/"

files <-
  list.files(data_folder, pattern = "*.xlsx", full.names = TRUE)

all_results <- list()

for (f in files) {
  df <- read_excel(f)
  
  # Rename columns using the rename() function
  df <- df %>%
    rename(
      Seed = Cap1,
      Captors = Cap2,
      Distance = mean_dist,
      Timestamps = time_min
    )
  
  df$Captors <- as.character(df$Captors)
  
  captors <- unique(df$Captors)
  
  experiment_list <- list()
  all_scatters <- list()
  all_clusters <- list()
  
  
  get_base_name <- function(file_path) {
    sub("\\..*$", "", basename(file_path))
  }
  
  experiment <- get_base_name(f)
  
  for (cap in captors) {
    cap_df <- subset(df, Captors == cap)
    
    threshold <- 2
    
    # Get the indices of the filtered rows in the original dataframe
    indices <- which(cap_df$Distance <= threshold)
    
    distance_seq <- split(cap_df$Distance[indices],
                          cumsum(c(TRUE, diff(indices) > 1)))
    
    distance_seq <-
      distance_seq[sapply(distance_seq, function(x)
        all(x <= threshold))]
    
    filtered_rows <- cap_df[indices,]
    
    time_seq <- lapply(distance_seq, function(x) {
      filtered_rows$Timestamps[filtered_rows$Distance %in% x]
    })
    
    time_discontinuities <- which(diff(unlist(time_seq)) > 1)
    distance_discontinuities <-
      which(diff(unlist(distance_seq)) > 0.5)
    
    combined_discontinuities <-
      unique(c(time_discontinuities, distance_discontinuities))
    breaks <-
      unique(c(0, combined_discontinuities, length(time_seq)))
    
    
    time_pieces <-
      split(time_seq, cut(seq_along(time_seq), breaks = breaks))
    distance_pieces <-
      split(distance_seq, cut(seq_along(distance_seq), breaks = breaks))
    
    
    # Création d'un dataframe pour le traçage
    plot_data <-
      do.call(rbind, lapply(1:length(time_seq), function(i) {
        time <- unlist(time_seq[[i]])
        
        if (length(time) < 1) {
          return(NULL)
        }
        
        distance <- unlist(distance_seq[[i]])
        
        avg_distance <- mean(distance)
        duration <- length(time)
        
        data.frame(
          seq_id = i,
          time = time,
          distance = distance,
          Interval_Start = min(time),
          Interval_End = max(time) ,
          duration = duration,
          avg_distance = avg_distance
        )
      }))
    
    
    cap_summary <- data.frame(
      seq_id = plot_data$seq_id,
      Start = plot_data$Interval_Start,
      End = plot_data$Interval_End ,
      duration = plot_data$duration,
      avg_distance = plot_data$avg_distance
    )
    
    cap_summary <- cap_summary[!duplicated(cap_summary), ]
    
    
    clusters <- ggplot(plot_data,
                       aes(
                         x = time,
                         y = distance,
                         group = seq_id,
                         color = paste(
                           "- Duration:",
                           duration,
                           "mins",
                           "Avg Distance:",
                           round(avg_distance, 2)
                         )
                       )) +
      geom_line() +
      geom_point(data = plot_data %>% group_by(seq_id) %>%
                   slice(1),
                 size = 1) +
      geom_point(data = plot_data %>%
                   group_by(seq_id)
                 %>% slice(n()),
                 size = 1) +
      scale_color_discrete(name = "Sequence Info", guide = guide_legend(override.aes = list(size = 0.5))) +
      labs(x = "Time", y = "Distance") +
      theme_minimal()
    
    # Determine the number of unique sequences
    num_colors <- length(unique(plot_data$seq_id))
    
    # Generate a set of colors
    colors <- viridis(num_colors)
    
    # Create a mapping of seq_id to color
    color_mapping <-
      data.frame(seq_id = unique(plot_data$seq_id), Cluster = colors)
    
    # Join this mapping back to the plot_data to assign colors to each sequence
    plot_data <- merge(plot_data, color_mapping, by = "seq_id")
    
    # 2. Map Colors to the Entire Dataframe
    # Créer une colonne d'index pour chaque dataframe
    cap_df$index <- 1:nrow(cap_df)
    plot_data$index <- match(plot_data$time, cap_df$Timestamps)
    
    # Fusionner les dataframes en utilisant la colonne d'index
    cap_df <-
      merge(cap_df, plot_data[, c("index", "Cluster")], by = "index", all.x = TRUE)
    
    # Supprimer la colonne d'index
    cap_df$index <- NULL
    
    # Create the plot for the current patient
    scatters <- ggplot(cap_df, aes(x = Timestamps, y = Distance)) +
      geom_point(aes(color = factor(Cluster)), alpha = 0.5) +
      scale_color_discrete(name = 'Groupes') +
      geom_hline(yintercept = threshold,
                 linetype = 'dashed',
                 color = 'red') +
      theme_minimal()
    
    
    # Store the plot in the list
    all_scatters[[cap]] <- scatters
    all_clusters[[cap]] <- clusters
    
    # Optionally, save the plot to a file
    # ggsave(
    #   filename = paste0(experiment, "_seed_",  cap, "_scatter_plot.png"),
    #   plot = scatters,
    #   width = 10,
    #   height = 6,
    #   bg = "white",
    #   path = "D:/Thesis/Tasks/DATA/Plots/Scatters/"
    # )
    # 
    # ggsave(
    #   filename = paste0(experiment, "_seed_", cap, "_cluster_plot.png"),
    #   plot = clusters,
    #   width = 10,
    #   height = 6,
    #   bg = "white",
    #   path = "D:/Thesis/Tasks/DATA/Plots/Clusters/"
    # )
  
  experiment_list[[as.character(cap)]] <- cap_summary
  }
  
  #Store the group list in the master list with group_id as the name
  # experiment_id <- which(files == f)
  experiment_id <- experiment
  all_results[[paste0(experiment_id)]] <- experiment_list
}

group_df <- all_results %>%
  enframe(name = "Experiment") %>%
  unnest_wider(value, names_sep = "_") %>%
  pivot_longer(cols = -Experiment, names_to = "Captors", values_drop_na = TRUE) %>%
  unnest(cols = c(value))

group_df$Captors <- gsub("^value_", "", group_df$Captors)

# max exposure time in close contact below 2 meters

max_duration_data <- group_df %>%
  group_by(Experiment, Captors) %>%
  arrange(desc(duration), avg_distance) %>%
  slice(1) %>%
  ungroup() %>%
  arrange(Experiment, as.numeric(Captors))

write_xlsx(max_duration_data, "data_max_exposure.xlsx")

# min distance 

min_distance_data <- group_df %>%
  group_by(Experiment, Captors) %>%
  arrange(avg_distance, desc(duration)) %>%
  slice(1) %>%
  ungroup() %>%
  arrange(Experiment, as.numeric(Captors))


write_xlsx(min_distance_data, "data_close_distance.xlsx")



#_______________________________________________________________________________


library(dtwclust)
library(cluster)


df_clust <- subset(all_results[["experiment_1_3"]][["116"]], select = c(-1, -2, -3))

dtw_cluster = tsclust(df_clust, type = "partitional", k = 2, distance = "dtw_basic", centroid = "pam", trace = T )

clusters <- dtw_cluster@cluster

plot(dtw_cluster)

wss <- (nrow(df_clust) - 1) * sum(apply(df_clust, 2, var))
for (i in 2:15) {
  km.out <- kmeans(df_clust, centers = i, nstart = 20)
  wss[i] <- km.out$tot.withinss
}

print("Done processing files")




