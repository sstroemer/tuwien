k.max = 26 # maximales k
T1year = 2008 # Ende des Schätzzeitraums
dat = read.csv("C:/Users/matth/Documents/Studium/Stat Prozesse und Zeitreihen/UnemploymentDE.txt", comment.char="#", header=TRUE)

# Arbeitslosenzahlen
X = ts(dat$UU/1e6,start=c(1990,9),frequency=12) #time series erstellen, Arbeitslose in Millionen, jaehrliche Frequenz (12 Obs. pro Jahr)
T = length(X)      #Anzahl Obs.
T1 = sum(time(X)<(T1year+1)) #Anzahl Obs. vor 2009
# jährliche Wachstumsraten
d = 12
x = window(diff(log(X),lag=d),start=start(X),end=end(X),extend=TRUE) #Jaehrliche Differenzen von log(X) (aufgestockt auf Laenge von X)
# Mittelwertbereinigung
mean.x = mean(x, na.rm = TRUE) #Empir. Mittel (NA's ignoriert)
x = x - mean.x
# ACF berechnen (aus Werten vor 2009)
g = acf(x[1:T1], lag.max = k.max, type = "covariance",
        plot = FALSE, demean = FALSE, na.action = na.omit)

# Prognose aus k vergangenen Werten:
stats=matrix(0,nrow=k.max,ncol=6)
for(k in 1:k.max){
  
# Prognosekoeffizienten + Fehlervarianz berechnen
G = toeplitz(g$acf[1:k])
c = solve(G,g$acf[2:(k+1)])   #Koeffizienten
s2 = g$acf[1] - c %*% g$acf[2:(k+1)]    #Prognosefehlervarianz (geschaetzt)
# ein-Schrittprognosen der (mittelwertbereinigten) Wachstumsraten
xh = rep(NA,T)
Xh = xh
for (t in ((k+1):T)) {
  xh[t] = c %*% x[(t-1):(t-k)]
}
uh = x - xh  #Prognosefehler
mean.expuh = mean(exp(uh[1:T1]), na.rm = TRUE)
# ein-Schrittprognosen der Arbeitslosenzahlen
Xh = rep(NA,T)

for (t in (13:T)) {
  Xh[t] = exp(log(X[t-12]) + mean.x + xh[t])*mean.expuh
}
Uh = X - Xh
# RMSE berechnen
stats[k,] = c(sqrt(s2), mean.expuh,
          sqrt(mean(uh[1:T1]^2,na.rm = TRUE)), sqrt(mean(Uh[1:T1]^2,na.rm = TRUE)),
          sqrt(mean(uh[(T1+1):T]^2,na.rm = TRUE)), sqrt(mean(Uh[(T1+1):T]^2,na.rm = TRUE)))
}

#Plot Resultate
k1<-which.min(stats[,5]) #minimiert out-of-sample RMSE bei Wachstumsrate
k2<-which.min(stats[,6]) #minimiert out-of-sample RMSE bei Arbeitslosenzahl


plot(1:k.max,stats[,1],type="l",main="Geschätzte Prognosefehlervarianz",xlab="k",ylab="sd")
#plot(1:k.max,stats[,2],type="l")
#RMSE für Wachstumsrate
plot(1:k.max,stats[,3],type="l",main="RMSE für Wachstumsrate, in-sample",xlab="k",ylab="RMSE")
plot(1:k.max,stats[,5],type="l",main="RMSE für Wachstumsrate, out-of-sample",xlab="k",ylab="RMSE")
abline(v=k1)
#RMSE für Arbeitslosenzahl
plot(1:k.max,stats[,4],type="l",main="RMSE für Arbeitslosenzahl, in-sample",xlab="k",ylab="RMSE")
plot(1:k.max,stats[,6],type="l",main="RMSE für Arbeitslosenzahl, out-of-sample",xlab="k",ylab="RMSE")
abline(v=k2)

#k=13 optimal
