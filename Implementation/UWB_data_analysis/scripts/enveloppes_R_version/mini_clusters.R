# Libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(plotly)
library(viridis)

data_folder <- "minute/"

files <- list.files(data_folder, pattern = "*.xlsx", full.names = TRUE)

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
  
  all_scatters <- list()
  all_clusters <- list()
  
  for (cap in captors) {
    
    get_base_name <- function(file_path) {
      sub("\\..*$", "", basename(file_path))
    }
    
    experiment <- get_base_name(f)
    
    cap_df <- subset(df, Captors == cap)
    
    threshold <- 2
    
    # Get the indices of the filtered rows in the original dataframe
    indices <- which(cap_df$Distance <= threshold)
    
    distance_seq <- split(cap_df$Distance[indices],
                          cumsum(c(TRUE, diff(indices) > 5)))
    
    distance_seq <-
      distance_seq[sapply(distance_seq, function(x)
        all(x <= threshold))]
    
    filtered_rows <- cap_df[indices, ]
    
    time_seq <- lapply(distance_seq, function(x) {
      filtered_rows$Timestamps[filtered_rows$Distance %in% x]
    })
    
    breaks <- which(diff(unlist(time_seq)) > 1)
    
    breaks <- unique(c(0, breaks, length(time_seq)))
    
    time_pieces <-
      split(time_seq, cut(seq_along(time_seq), breaks = breaks))
    distance_pieces <-
      split(distance_seq, cut(seq_along(distance_seq), breaks = breaks))
    
    # Création d'un dataframe pour le traçage
    plot_data <-
      do.call(rbind, lapply(1:length(time_seq), function(i) {
        time <- unlist(time_seq[[i]])
        distance <- unlist(distance_seq[[i]])
        
        avg_distance <- mean(distance)
        duration <- length(time)
        
        data.frame(
          seq_id = i,
          time = time,
          distance = distance,
          avg_distance = avg_distance,
          duration = duration
        )
      }))
    
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
    ggsave(
      filename = paste0(experiment, "_seed_",  cap, "_scatter_plot.png"),
      plot = scatters,
      width = 10,
      height = 6,
      bg = "white"
    )
    
    ggsave(
      filename = paste0(experiment,"_seed_", cap, "_cluster_plot.png"),
      plot = clusters,
      width = 10,
      height = 6,
      bg = "white"
    )
    
  }
  
}

print("Done processing files")