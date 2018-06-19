data = read.csv("sunspotnumbers.txt", sep="", header=TRUE, skip=3, quote="", na.strings="", stringsAsFactors=FALSE)



acf(x=data$ssn, type = c("correlation", "covariance", "partial"), plot=TRUE)

ar(x=data$ssn, aic=TRUE)

spectrum(x=data$ssn, method = c("pgram", "ar"))
