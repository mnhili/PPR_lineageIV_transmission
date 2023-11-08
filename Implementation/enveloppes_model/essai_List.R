




net<-data.frame("Origine"=c("A","B","C","A"),"Destination"=c("B","D","E","E"),"Weight"=c(1,10,20,5))
tmax<-10
S_vec<-c("E","C","D")
I_vec<-c("A","B")
trans_prob<-0.5
WEIGHT<-TRUE
ListDestination <- split(setNames(net$Weight,net$Origine), net$Destination)