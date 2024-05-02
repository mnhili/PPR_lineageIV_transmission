inidividu=3
enveloppes<-c(4,10,5)
#dist<-df$Median
dist<-c(1,2,3,4,20,21,22,23,24,25,26,27,28,29,31,32,33,34,35)
temp<-c(1,2,3,4,20,21,22,23,24,25,26,27,28,29,31,32,33,34,35)
p0<-0.05
lambda<-0.12
probinsuc<-c()
for( l in 1:length(temp)){
  pl<-(1-p0*exp(-lambda*dist[l]))^temp[l]
  probinsuc<-c(probinsuc,pl)
}
probinsuc # probabilité de n'etre pas infecté aprè etre expose pour un  enveloppe d'une certaine durée et une certain distane
# Je vais fragment er les vecterus pour trouver les  valeurs pour chaque individu
probind<-c()# vecteur contenant pour chaque individu la probabilité d'etre infecté
counter<-1
for(e in enveloppes){
  
  fine<-counter+e-1
  probinsucind<-probinsuc[counter:fine]# pour chaque individu contien  les valeurs de la probabilit d'echec après cahque enveloppe
  print(probinsucind)
  pind<-1-prod(probinsucind)# probabilité d'etre infecté après avoir etre expose au virus pour une certaine period et bcp de enveloppe
  print(pind)
  probind<-c(probind,pind)
  counter<-counter+e
}
probind
