library(nimble)
df<-data.frame("Id"=c("A","A","A","A","B","B","C","D","D","D"),"time"=c(10,20,5,10,5,9,15,40,20,30),"dist"=c(1,0.4,0.8,1.9,0.4,0.9,1.2,0.8,0.6,0.4),"status"=c(1,1,1,1,0,0,1,0,0,0))
uniqueidsta<-unique(df[c("Id","status")])


############################# 5 tentative#########################
lengthids<-4
lengthenv<-c(4,2,1,3)
alltimes<-matrix(0,max(lengthenv),lengthids)
alldist<-matrix(0,max(lengthenv),lengthids)

for(i in 1:nrow(uniqueidsta)){
  id_c<-uniqueidsta[i,]$Id
  timesid<-df[df$Id==id_c,]$time
  distid<-df[df$Id==id_c,]$dist
  for(l in 1:length(timesid)){
    alltimes[i,l]<-timesid[l]
    alldist[i,l]<-distid[l]
  }

}

p5 <- nimbleFunction(
  run=function(alltimes=integer(2),alldist=double(2),maxlengthenv=integer(0),lengthids=integer(0),p0=double(0),lambda=double(0)) ## Vector of length 3 giving the dimensions of x
  {
    pvec <- c(1.0,1.0,1.0,1.0)
    for(i in 1:lengthids){
      p<-1.0
      for(j in 1:maxlengthenv ){
        p<-p*(1.0-p0*exp(-lambda*alldist[i,j]))^alltimes[i,j]
      }
      pvec[i]<-1.0-p
    }
    
    returnType(double(1))
    return(pvec)
  }
) 

p5(alltime=alltimes,alldist=alldist,maxlengthenv=max(lengthenv),lengthids=4,p0=0.01,lambda=0.05)  ## correct
cp5 <- compileNimble(p5, showCompilerOutput = TRUE)
cp5(alltime=alltimes,alldist=alldist,maxlengthenv=max(lengthenv),lengthids=4,p0=0.01,lambda=0.05)  ## correct


################################################################################

infectionCode<- nimbleCode({
  l0 ~ dunif(0,1)
  pm0 ~ dunif(0.01,0.91)
  p<-c(1,1,1,1)
 
  for(i in 1:4){
    p[i]<-1.0
    for(j in 1:4 ){
      p[i]<-p[i]*(1.0-p0*exp(-l0*alldist[i,j]))^alltimes[i,j]
    }
    y[i] ~ dbern(1.0-p[i])
  }
  
})



infectionConsts<-list(alltimes=alltimes,alldist=alldist)

infectionData<-list(y=uniqueidsta$status)

infectionInits<-list(l0=0.01,pm0=0.01)
infectionModel <- nimbleModel(code = infectionCode, name = 'Infection', constants = infectionConsts,data = infectionData, inits = infectionInits)

infectionMCMC <- buildMCMC(infectionModel)
CinfectionModel <- compileNimble(infectionModel,showCompilerOutput = TRUE)
CinfectionMCMC <- compileNimble(infectionMCMC, project = infectionModel)
runMCMC_samples <- runMCMC(CinfectionMCMC , nburnin = 2000,thin=10, niter = 40000,nchains = 10)








# Failed codes ------------------------------------------------------------



#####################################################################@
p3 <- nimbleFunction(
  run=function(time=integer(1),dist=double(1),lengthenv=integer(1),lengthids=integer(0),p0=double(0),lambda=double(0)) ## Vector of length 3 giving the dimensions of x
  {
    countervec<-c(cumsum(lengthenv))
    pvec <- rep(1,lengthids)
    i<-1
    counter<-1
    for(ix in 1:10) {
      pvec[i]<-pvec[i]*(1-p0*exp(-lambda*dist[ix]))**time[ix]
      counter<-counter+1
      if(counter==countervec[i]){
        pvec[i]<-1-pvec[i]
        i<-i+1
      }
    }
    returnType(double(1))
    return(pvec)
  }
) 



p4 <- nimbleFunction(
  run=function(time=integer(1),dist=double(1),lengthenv=integer(1),lengthids=integer(0),p0=double(0),lambda=double(0)) ## Vector of length 3 giving the dimensions of x
  {
    countervec<-c(0,cumsum(lengthenv))
    pvec <- c(1.0,1.0,0,0)
    end<- length(countervec)-1
    for(j in 1:4){
      begid<-countervec[j]+1
      endid<-countervec[j+1]
      p<-1.0
      for(ix in begid:endid ){
        p<-p*(1.0-p0*exp(-lambda*dist[ix]))^time[ix]
      }
      pvec[j]<-1.0-p
    }
    
    returnType(double(1))
    return(pvec)
  }
) 


p4(time=df$time,dist=df$dist,lengthenv=c(4,2,1,3),lengthids=4,p0=0.01,lambda=0.05)  ## correct
cp4 <- compileNimble(p4, showCompilerOutput = TRUE)
cp4(time=df$time,dist=df$dist,lengthenv=c(4,2,1,3),lengthids=4,p0=0.01,lambda=0.05)

