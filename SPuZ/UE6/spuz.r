k.max = 26 # maximales k
T1year = 2008 # Ende des Schätzzeitraums
dat = read.csv("UnemploymentDE.txt", comment.char="#", header=TRUE)

# Arbeitslosenzahlen
X = ts(dat$UU/1e6, start=c(1990,9), frequency=12)
T = length(X)
T1 = sum(time(X)<(T1year+1))
# jährliche Wachstumsraten
d = 12
x = window(diff(log(X),lag=d),start=start(X),end=end(X),extend=TRUE)
# Mittelwertbereinigung
mean.x = mean(x, na.rm = TRUE)
x = x - mean.x
# ACF berechnen
g = acf(x[1:T1], lag.max = k.max, type = "covariance",
        plot = FALSE, demean = FALSE, na.action = na.omit)
# Prognose aus k=3 vergangenen Werten:
# Prognosekoeffizienten + Fehlervarianz berechnen
k = 3
G = toeplitz(g$acf[1:k])
c = solve(G,g$acf[2:(k+1)])
s2 = g$acf[1] - c %*% g$acf[2:(k+1)]
# ein-Schrittprognosen der (mittelwertbereinigten) Wachstumsraten
xh = rep(NA,T)
Xh = xh
for (t in ((k+1):T)) {
  xh[t] = c %*% x[(t-1):(t-k)]
}
uh = x - xh
mean.expuh = mean(exp(uh[1:T1]), na.rm = TRUE)
# ein-Schrittprognosen der Arbeitslosenzahlen
Xh = rep(NA,T)
for (t in (13:T)) {
  Xh[t] = exp(log(X[t-12]) + mean.x + xh[t])*mean.expuh
}
Uh = X - Xh
# RMSE berechnen
stats = c(sqrt(s2), mean.expuh,
          sqrt(mean(uh[1:T1]^2,na.rm = TRUE)), sqrt(mean(Uh[1:T1]^2,na.rm = TRUE)),
          sqrt(mean(uh[(T1+1):T]^2,na.rm = TRUE)), sqrt(mean(Uh[(T1+1):T]^2,na.rm = TRUE)))
