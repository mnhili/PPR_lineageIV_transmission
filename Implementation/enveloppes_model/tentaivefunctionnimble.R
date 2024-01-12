library(nimble)
df<-data.frame("Id"=c("A","A","A","A","B","B","C","D","D","D"),"time"=c(10,20,5,10,5,9,15,40,20,30),"dist"=c(1,0.4,0.8,1.9,0.4,0.9,1.2,0.8,0.6,0.4),"status"=c(1,1,1,1,0,0,1,0,0,0))
uniqueidsta<-unique(df[c("Id","status")])

infectionCode<- nimbleCode({
  l0 ~ dunif(0,1)
  pm0 ~ dunif(0.01,0.91)
  p<-pm0*exp(-l0 )
  for(i in 1:length(ids)){
  
  y[i] ~ dbern(p)
  }
})
p3 <- nimbleFunction(
  run=function(time=integer(1),dist=double(1),lengthenv=integer(1),lengthids=integer(0),p0=double(0),lambda=double(0)) ## Vector of length 3 giving the dimensions of x
  {
    pvec <- rep(0,lengthids)
    for(i in 1:4){
      for(ix in 1:10) {
        pvec[i]<-pvec[i]+time[ix]*log(1-p0*exp(-lambda*dist[ix]))
    }
    
     
    }
    returnType(double(1))
    return(pvec)
  }
) 

p3(time=df$time,dist=df$dist,lengthenv=c(4,2,1,3),lengthids=4,p0=0.01,lambda=0.05)  ## correct
cp3 <- compileNimble(p3, showCompilerOutput = TRUE)
cp3(time=df$time,dist=df$dist,lengthenv=c(4,2,1,3),lengthids=4,p0=0.01,lambda=0.05)


infectionConsts<-list(ids=uniqueidsta$Id,time=df$time,dist=df$dist)

infectionData<-list(y=uniqueidsta$status)

infectionInits<-list(l0=0.01,pm0=0.01)
infectionModel <- nimbleModel(code = infectionCode, name = 'Infection', constants = infectionConsts,data = infectionData, inits = infectionInits)

infectionMCMC <- buildMCMC(infectionModel)
CinfectionModel <- compileNimble(infectionModel,showCompilerOutput = TRUE)
CinfectionMCMC <- compileNimble(infectionMCMC, project = infectionModel)
runMCMC_samples <- runMCMC(CinfectionMCMC , nburnin = 2000,thin=10, niter = 40000,nchains = 10)
