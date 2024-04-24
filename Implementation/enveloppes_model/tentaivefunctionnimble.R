library(nimble)


# Fake dataframe ----------------------------------------------------------
# We have considered that 5 animals get exposed to the same infected animal.
# Due to movement they interact differntly to the sma animlas , for differnt lenth of time and at different distance
# We would like to estimate , à aprtir de la calibration la prob de infection
# Considering:
# For each animal , for each minute the probability of getting infected is :p=p0exp(-lambda*r) ou r is teh distance , `
# and  p0 and Lambda the parameter to estimate
# The cumulative probability for a singele animal at the end of the experience is
# P_i=1-\Prod_j (1-p_j)^t_j
# wher t-j is the duration of jth interval

df<-data.frame("Id"=c("A","A","A","A","B","B","C","D","D","D","E","E"),"time"=c(10,20,5,10,5,9,15,40,20,30,10,5),"dist"=c(1,0.4,0.8,1.9,0.4,0.9,1.2,0.8,0.6,0.4,0.9,0.5),"status"=c(1,1,1,1,0,0,1,0,0,0,1,1))

df
# Extraction unique ids and  status
uniqueidsta<-unique(df[c("Id","status")])
lengthids<-length(uniqueidsta$Id)

# For each id we extract the number of interval identified 
lengthenv<-c()
for(i in 1:nrow(uniqueidsta)){
  id_c<-uniqueidsta[i,]$Id
  timesid<-df[df$Id==id_c,]$time
  lengthenv<-c(lengthenv,length(timesid))
}  
maxenv<-max(lengthenv) # maX number of intervals detected


# Create matrices for calculations probabilities --------------------------

# Create matrices  for duration of interval and distance
# Each lien correspond to a device 
# The number of the column to max number of interval identified
# The matrix will be filled with values of each interval And left 0 when data are anota vailable



alltimes<-matrix(0,lengthids,maxenv)
alldist<-matrix(0,lengthids,maxenv)

for(i in 1:nrow(uniqueidsta)){
  id_c<-uniqueidsta[i,]$Id
  timesid<-df[df$Id==id_c,]$time
  distid<-df[df$Id==id_c,]$dist
  for(l in 1:length(timesid)){
    alltimes[i,l]<-timesid[l]
    alldist[i,l]<-distid[l]
  }

}



# Nimble function ---------------------------------------------------------

############################# 5 tentative#########################
# The function p5  creates a vector of the lenght of te number of captors 
# each entry corresponds to  the cumulative probability f exposure
# The function runs on each line of the alltimes matrix 
# estimate the probability of failng for that interval 
# and multiply with previous ones
# tend it takes teh complementary (1-)
p5 <- nimbleFunction(
  run=function(alltimes=integer(2),alldist=double(2),maxenv=integer(0),lengthids=integer(0),p0=double(0),lambda=double(0),pvec=double(1)) ## Vector of length 3 giving the dimensions of x
  {
    
    for(i in 1:lengthids){
      p<-1.0
      for(j in 1:maxenv){
        p<-p*(1.0-p0*exp(-lambda*alldist[i,j]))^alltimes[i,j]
      }
      pvec[i]<-1.0-p
    }
    
    returnType(double(1))
    return(pvec)
  }
) 

# Test that function in r and compiled give the same results
p5(alltime=alltimes,alldist=alldist,maxenv=maxenv,lengthids=lengthids,p0=0.01,lambda=0.05,pvec=rep(1.0,lengthids))  ## correct
cp5 <- compileNimble(p5, showCompilerOutput = TRUE)
cp5(alltime=alltimes,alldist=alldist,maxenv=maxenv,lengthids=lengthids,p0=0.01,lambda=0.05,pvec=rep(1.0,lengthids))  ## correct


################################################################################

# Calibration -------------------------------------------------------------


infectionCode<- nimbleCode({
  l0 ~ dunif(0,1)
  pm0 ~ dunif(0.01,0.91)
  pvecf<-cp5(alltime=alltimes,alldist=alldist,maxenv=maxenv,lengthids=lengthids,p0=pm0,lambda=l0,pvec=pvec0) 
 
  for(i in 1:lengthids){
    y[i] ~ dbern(pvecf[i])
  }
  
})



infectionConsts<-list(alltimes=alltimes,alldist=alldist,maxenv=maxenv,lengthids=lengthids,pvec0=rep(1.0,lengthids))

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

