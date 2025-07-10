# TEST CONSTRUCTION SCRIPT

setwd(dir = "C:/Users/menassol/Documents/_RECHERCHE/2. SOCIAL NETWORKS OVINS/5. RESEAUX SYNAPSE & EPIDEMIOLOGIE/PROJET PPR ADAMA DIALLO/DONNEES/DONNEES UWB/_raw/experiment_1/1heure/")
rm(list=ls())

library(data.table)
library(readr)
library(dplyr)
library(tidyr)

raw <- fread("09-38-19_distances.csv")

rawUWB <- raw[,-23,with=FALSE] #retrait colonne suppl?mentaire
rawUWB[] <- lapply(rawUWB, gsub, pattern = '[,]', replacement =".") #remplacement des virgules par des points
rawUWB[, 1:22 := lapply(.SD, as.numeric), .SDcols = 1:22] #passage des variables X Y Z en valeurs num?riques

rawUWB[, diff := timestamp_ns - shift(timestamp_ns, fill = first(timestamp_ns))] #diff?rence de temps entre deux acquisitions

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

rawUWB[, group := my_cumsum(rawUWB$diff)[1]] #application de la fonction pour retrouver les groupes dans le tableau
rawUWB2 <- copy(rawUWB)
rawUWB2[, c("timestamp_ns","diff"):=NULL]

rawUWB2 <- rawUWB2[, lapply(.SD, function(x) if(length(y<-na.omit(x))) y else first(x)), by=group]#cr?ation d'une extraction avec en ligne une acquisition X,Y et Z par capteur pour tous les capteurs
rawUWB3 <- copy(rawUWB2)

rawUWB3 <-rawUWB3[rawUWB, on = 'group', nanosecondes := i.timestamp_ns] #tableau avec nanosecondes (derni?re valeur par acquisition Hz)
#fwrite(rawUWB3, "essai_extraction.csv")

df_melted <- melt(rawUWB3, id.vars = "group", measure.vars = colnames(rawUWB3[,2:22]))

df <- df_melted %>%
  mutate(sensor = gsub("[^[:digit:]]", "", variable),
         variable = gsub("[[:digit:]]", "", variable))

df_transformed <- dcast(df, group + sensor ~ variable, value.var = "value")