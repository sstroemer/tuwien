library(gdata)                   # load gdata package 
mydata = read.xls("Waermenachfrage_Uebung1.xls")

library(XLConnect)               # load XLConnect package 
wk = loadWorkbook("Waermenachfrage_Uebung1.xls") 
df = readWorksheet(wk, sheet="Tabelle1")



summary(df$Nachfrage)
boxplot(df$Nachfrage)
hist(df$Nachfrage, breaks=100, right=FALSE)



m <- lm(Nachfrage ~ Stunde + I(Stunde^2) + I(Stunde^3), data=df)
m2 <- lm(Nachfrage ~ as.factor(Stunde), data=df)



plot(fitted(m)[1680:1775], type="l", ylim=c(0,40))
lines(fitted(m)[6480:6575], col="red", type="l")




test <- data.frame(data=0:23)
colnames(test) <- "Stunde"

plot(predict(m, test), ylim = c(10,20), type="l")
lines(predict(m2, test), col="red")
