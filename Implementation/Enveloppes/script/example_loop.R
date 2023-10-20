
for( i in 1: length(y)){
  p[i]=1
  datai<-subset(data, cap_ID==i, Experiment==exp) # on extrait les lignes du dataframe envelloppe concernant l'animal i dans l'exp Exp
  duree<-datai$duration
  dist<-datai$dist
  for( l in 1:length(duree)){
    ptemp<-(1-p0*exp(-lambda*dist[l]))^duree[l]
    p[i]<-p[i]*ptemp
  }
  p[i]<-1-p[i]
}

############# pour l'AUC
AUCvect<-c()

for (f in p0_sample) {
  # Extract parameter draws
  p0 <- p0_samples[f]
  lambda <- lambda_samples[f]
  for (i in 1:length(y)) {
    p[i] = 1
    datai <-
      subset(data, cap_ID == i, Experiment == exp) # on extrait les lignes du dataframe envelloppe concernant l'animal i dans l'exp Exp
    duree <- datai$duration
    dist <- datai$dist
    for (l in 1:length(duree)) {
      ptemp <- (1 - p0 * exp(-lambda * dist[l])) ^ duree[l]
      p[i] <- p[i] * ptemp
    }
    p[i] <- 1 - p[i]
  }
  predicted<-p
  actual<df$infected # check infected pour chaque individu in chaque exper
  # Create a prediction object
  prediction <- prediction(predicted, actual)
  
  # Create a performance object to calculate ROC and AUC
  performance <- performance(prediction, "tpr", "fpr")
  auc <- performance(prediction, "auc")
  AUCvect<-c(AUCvect,auc@y.values[[1]])
}
