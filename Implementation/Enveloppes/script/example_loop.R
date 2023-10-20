
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

