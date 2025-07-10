library(readr)
library(readxl)
library(writexl)
library(dplyr)
library(tidyr)

# Lire les fichiers
part1 <- read.csv("one colomn pair/experiment_4_2. contact duration 48h part1_matrice_seed.csv")
part2 <- read.csv("one colomn pair/experiment_4_2. contact duration 48h part2_matrice_seed.csv")
part3 <- read.csv("one colomn pair/experiment_4_2. contact duration 48h part3_matrice_seed.csv")



# Calculer le temps maximal pour chaque paire dans la première partie
max_time_per_pair_part1 <- part1 %>%
  group_by(Cap1, Cap2) %>%
  summarise(max_time = max(Time))

# Fonction pour ajuster la séquence temporelle
adjust_time_sequence_2 <- function(df, max_times) {
  df %>%
    left_join(max_times, by = c("Cap1", "Cap2")) %>%
    mutate(Time = ifelse(is.na(max_time), Time, Time + max_time )) %>%
    select(-max_time)
}

# Appliquer l'ajustement à la partie 2 
part2 <- adjust_time_sequence_2(part2, max_time_per_pair_part1)

# Calculer le temps maximal pour chaque paire dans la deuxième partie
max_time_per_pair_part2 <- part2 %>%
  group_by(Cap1, Cap2) %>%
  summarise(max_time = max(Time))

adjust_time_sequence_3 <- function(df, max_times) {
  df %>%
    left_join(max_times, by = c("Cap1", "Cap2")) %>%
    mutate(Time = ifelse(is.na(max_time), Time, Time + max_time -1 )) %>%
    select(-max_time)
}

# Appliquer l'ajustement à la partie 3
part3 <- adjust_time_sequence_3(part3, max_time_per_pair_part2)

# Concaténer les trois parties ajustées
final_df <- rbind(part1, part2, part3)

# Résultat final dans un seul dataframe
final_df <- arrange(final_df, Cap1, Cap2, Time)

final_df <- subset(final_df, select = -1)

write.csv(final_df, "seed_merged/experiment_2_2. contact duration 24h_matrice_seed.csv" , row.names = FALSE)
