library(readr)
library(dplyr)
library(writexl)

# Set data and output folders
data_folder <- "seed_merged/"
output_folder <- "minute/"

# List CSV files in data folder
files <- list.files(data_folder, pattern="*.csv", full.names=TRUE)

# Loop through files
for(f in files){
  df <- read.csv(f)
  
  df <- arrange(df, Cap1, Cap2, Time)
  
  # Définir tous les IDs uniques
  Cap1_all <- c(unique(df$Cap1))  
  Cap2_all <- c(unique(df$Cap2))
  
  # Initialiser la liste de résultats
  pairwise_dfs <- list()
  
  # Boucler sur chaque paire
  for(Cap1 in Cap1_all) {
    for(Cap2 in Cap2_all) {
      
      if(Cap1 != Cap2) {
        
        # Filtrer sur cette paire 
        pair_df <- filter(df, Cap1 == Cap1, Cap2 == Cap2)
        
        # Créer les intervalles
        bins <- seq(min(pair_df$Time), max(pair_df$Time), by=60)
        labels <- seq(min(pair_df$Time), max(pair_df$Time)/60, 1)
        pair_df$time_min <- cut(pair_df$Time, breaks=bins, labels=labels) 
        
        pair_df$time_min <- as.numeric(pair_df$time_min)
        
        max_val <- max(pair_df$time_min, na.rm = TRUE)
        pair_df$time_min[is.na(pair_df$time_min)] <- max_val + 1
        
        # Calculer la moyenne 
        pair_stats <- pair_df %>%
          group_by(Cap1, Cap2, time_min) %>%
          summarise(mean_dist = mean(Distance))
        
        key <- paste(Cap1, Cap2)
        if (!key %in% names(pairwise_dfs)) {
          pairwise_dfs[[key]] <- pair_stats 
        }
      }
    }
  }
  
  # Fusionner tout en un dataframe
  combined_df <- do.call(rbind, pairwise_dfs)
  
  df_unique <- combined_df[!duplicated(combined_df), ]
  
  filename <- basename(f)
  
  outputfile <- file.path(output_folder, gsub(".csv",".xlsx", filename))
  
  # Save output with same name in output folder
  
  write_xlsx(df_unique, outputfile)
  
}

print("Done processing files")

