library(dplyr)
library(ggplot2)
library(tidyr)

library(geosphere)

library(plotly)

rm(list=ls())
setwd("C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/ANALYSES/PRECISION TESTS/")

#####################################################

path <- "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/ANALYSES/PRECISION TESTS/"

# Get a list of file names in the directory that match the pattern "position3d.csv"
files <- list.files(path = path, pattern = "position3d.csv")

# Initialize a list to store the summary data frames for each file
df_summary <- list()

# Use a for loop to iterate over the list of file names
for(i in 1:length(files)) {
  # Read the CSV file
  data <- read.csv(file = paste0(path, files[i]), stringsAsFactors = FALSE)
  
  # Calculate the summary statistics for each sensor
  df_summary[[i]] <- data %>%
    group_by(sensor) %>%
    summarize(mean_x = mean(X, na.rm=TRUE), sd_x = sd(X, na.rm=TRUE),
              mean_y = mean(Y, na.rm=TRUE), sd_y = sd(Y, na.rm=TRUE),
              mean_z = mean(Z, na.rm=TRUE), sd_z = sd(Z, na.rm=TRUE))
  
  names(df_summary)[i] <- files[i]
  }

list_plots  <-
  lapply(1:length(df_summary),function(i) {
    plot_ly(df_summary[[i]], x = ~mean_x, y = ~mean_y, z = ~mean_z,
            type = "scatter3d", mode = "markers",
            marker = list(size = 10),
            error_x = list(array = ~sd_x),
            error_y = list(array = ~sd_y),
            error_z = list(array = ~sd_z),
            text = ~sensor,
            legendgroup = ~sensor) %>%
      
      layout(title=paste0(files[i]))
  })

df_summary
list_plots

#####################################################


# Generate a list of all pairs of sensors
combine <- combn(df_summary[[1]]$sensor, 2)

distances <- c()

# Iterate over all pairs of sensors
for(j in 1:length(df_summary)){
  for (i in 1:ncol(combine)) {
    # Calculate the distance between each pair of sensors using their mean_x, mean_y, and mean_z coordinates and append the distance to the vector of distances
    distances <- c(distances, dist(df_summary[[j]][match(combine[, i],df_summary[[j]]$sensor), c("mean_x", "mean_y", "mean_z")], method = "euclidean"))
    
  }
}

dist_pairs <- as.data.frame(t(combine))
dist_pairs[, seq(3,11)] <- distances

nomcol <- files[1:9]
patterns <- c('_validation tests_test_', '_position3d.csv')
expr = paste0(patterns, collapse = '|')
colnames(dist_pairs)[3:11] <- gsub(expr, '', nomcol)


#Vérifier hauteur au sol
#tableau de relation distance et erreure de mesure