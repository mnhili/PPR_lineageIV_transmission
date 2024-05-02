library(readxl)
library(tidyr)
library(dplyr)
library(writexl)


df <- read_excel("C:/Users/manhi/OneDrive/Bureau/PPR_lineage_IV/enveloppes_data_seconds/enveloppe1_0.1.xlsx")


# Trouver les noms de colonnes à remplacer
cols <- names(df)[grepl("Duree_min_", names(df))]

# Créer les nouveaux noms
new_cols <- sub("Duree_min_", "time_", cols)

# Renommer les colonnes
names(df)[names(df) %in% cols] <- new_cols


cols <- names(df)[grepl("Distance_Mediane_", names(df))]

# Créer les nouveaux noms
new_cols <- sub("Distance_Mediane_", "distance_", cols)

# Renommer les colonnes
names(df)[names(df) %in% cols] <- new_cols


df_long <- df %>%
  pivot_longer(cols = c(matches("^distance_"), matches("^time_")),
               names_to = ".value",
               names_pattern = "([A-Za-z]+)_")


head(df_long)


df_long <- na.omit(df_long)


write_xlsx(df_long, "C:/Users/manhi/OneDrive/Bureau/PPR_lineage_IV/enveloppes_data_seconds/enveloppe1_0.1_pivot.xlsx")
