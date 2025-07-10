#EXTRACTION SUR FICHIERS TESTS DE VALIDATION 1/2

rm(list=ls())

library(data.table)
library(readr)
library(dplyr)
library(tidyr)

my_function<-function(dirs)
{
  #apply the same function for all the entries in the dirs vector
  sapply(dirs, function(workd){
    setwd(workd)
    #Locate the file inside each directory that has "distances" and is a csv file
    all.files <- list.files(path = workd, 
                            pattern = "distances.csv")
    l <- lapply(all.files, fread)
    dt <- rbindlist( l, use.names=TRUE, fill=TRUE)
    
    dtUWB <- dt %>% select(-contains("V")) #remplacement des colonnes supplementaires crees
    dtUWB[] <- lapply(dtUWB, gsub, pattern = '[,]', replacement =".") #remplacement des virgules par des points
    dtUWB <- dtUWB[, lapply(.SD, as.numeric)] #passage des variables X Y Z en valeurs numeriques
    dtUWB[, diff := timestamp_ns - shift(timestamp_ns, fill = first(timestamp_ns))] #difference de temps entre deux acquisitions
    
    my_cumsum <- function(x){ #fonction pour obtenir une identite de groupe par seconde
      grp = integer(length(x))
      grp[1] = 1
      for(i in 2:length(x)){
        if(x[i-1] + x[i] <= 980000000){
          grp[i] = grp[i-1]
          x[i] = x[i-1] + x[i]
        } else {
          grp[i] = grp[i-1] + 1
          x[i]=0
        }
      }
      data.frame(grp, x)
    }
    
    dtUWB[, group := my_cumsum(dtUWB$diff)[1]] #application de la fonction pour retrouver les groupes dans le tableau
    dtUWB2 <- copy(dtUWB)
    dtUWB2[, c("timestamp_ns","diff"):=NULL]
    
    dtUWB2 <- dtUWB2[, lapply(.SD, function(x) if(length(y<-na.omit(x))) y else first(x)), by=group]#cr?ation d'une extraction avec en ligne une acquisition X,Y et Z par capteur pour tous les capteurs
    dtUWB3 <- copy(dtUWB2)
    
    dtUWB3 <-dtUWB3[dtUWB, on = 'group', nanosecondes := i.timestamp_ns] #tableau avec nanosecondes (derni?re valeur par acquisition Hz)
    
    dt_melted <- melt(dtUWB3, id.vars = "group", measure.vars = colnames(dtUWB3[,2:22]))
    
    dt_melted <- dt_melted %>%
      mutate(sensor = gsub("[^[:digit:]]", "", variable),
             variable = gsub("[[:digit:]]", "", variable))
    
    df_transformed <- dcast(dt_melted, group + sensor ~ variable, value.var = "value")
    df_transformed <- df_transformed %>% rename(time = group)
    
    fwrite(df_transformed, file=paste0(save_directory,basename(dirname(workd)),"_",basename(workd),"_position3d.csv"))
    
  })
}

save_directory <- "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/ANALYSES/PRECISION TESTS/"

data_folders <- c("C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_banc_516_20/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_hexa_150mm/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_hexa_300mm/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_hexa_1000mm/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_ligne_sol_6/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_ligne_sol_10/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_ligne_sol_15/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_ligne_sol_30/",
                  "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_validation tests/test_ligne_sol_50/")

my_function(data_folders)