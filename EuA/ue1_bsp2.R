library(gdata)
library(stringr)
library(lubridate) # easy date to hour, ...

## Data Loading ----------------------------------------------------------------------------------------------

data.2012 = read.xls("Strompreise/Daten_Preise_Last_2012.xlsx")
data.2015 = read.xls("Strompreise/Daten_Preise_Last_2015.xlsx")
data.2016 = read.xls("Strompreise/Daten_Preise_Last_2016.xlsx")

data.2015$X <- NULL
rename <- c("year", "month", "day", "hour", "load", "wind", "pv", "price")
colnames(data.2012) <- rename
colnames(data.2015) <- rename

rename <- c("CET", "loadDA", "load", "windDA", "wind", "pvDA", "pv", "priceDA", "priceIntraday")
colnames(data.2016) <- rename


## Data Preparation ------------------------------------------------------------------------------------------

# construct general renewable input to not lose out on to many observation while log-transforming (since pv = 0 often (early/late)!)
data.2012$re <- data.2012$pv + data.2012$wind
data.2015$re <- data.2015$pv + data.2015$wind

# for a "fair" comparison fix not log-transformable data points from the beginning
# (to be honest: we should probably consider censoring instead of truncating)
data.2012$price <- pmax(data.2012$price, 0.001)
data.2015$price <- pmax(data.2015$price, 0.001)
data.2012$re <- pmax(data.2012$re, 0.001)
data.2015$re <- pmax(data.2015$re, 0.001)

## Aufgabe 1.2.1 / 1.2.2 --------------------------------------------------------------------------------------

model.2012.1 <- lm(price ~ re + load, data=data.2012)
model.2015.1 <- lm(price ~ re + load, data=data.2015)

model.2012.2 <- lm(log(price) ~ log(re) + log(load), data=data.2012)
model.2015.2 <- lm(log(price) ~ log(re) + log(load), data=data.2015)

n <- nrow(data.2012)
model.2012.3 <- lm(price[-1] ~ re[-1] + load[-1] + price[-n], data=data.2012)
n <- nrow(data.2015)
model.2015.3 <- lm(price[-1] ~ re[-1] + load[-1] + price[-n], data=data.2015)

n <- nrow(data.2012)
model.2012.4 <- lm(price[-(1:24)] ~ pv[-(1:24)] + wind[-(1:24)] + I(re/load)[-(1:24)] +
                                    load[-(1:24)] + log(load[-(1:24)]) + I(1/load)[-(1:24)] + 
                                    price[-c(1:23,n)] + price[-((n-23):n)] +
                                    as.factor(month)[-(1:24)] + as.factor(hour)[-(1:24)], data=data.2012)
n <- nrow(data.2015)
model.2015.4 <- lm(price[-(1:24)] ~ pv[-(1:24)] + wind[-(1:24)] + I(re/load)[-(1:24)] +
                                    load[-(1:24)] + log(load[-(1:24)]) + I(1/load)[-(1:24)] + 
                                    price[-c(1:23,n)] + price[-((n-23):n)] +
                                    as.factor(month)[-(1:24)] + as.factor(hour)[-(1:24)], data=data.2015)

# todo: all summaries

## Aufgabe 1.2.3 ----------------------------------------------------------------------------------------------

# These forecasts/explenations could be vastly improved by allowing the last known price to be used!
model.2016.dayahead <- lm(priceDA ~ load + loadDA + wind + windDA + pv + pvDA, data=data.2016)
model.2016.intraday <- lm(priceIntraday ~ load + loadDA + wind + windDA + pv + pvDA, data=data.2016)

data.2016$date <- as.POSIXct(str_sub(data.2016$CET, end=16), format="%d.%m.%Y %H:%M")
model.full.dayahead <- lm(priceDA ~ load + loadDA + wind + windDA + pv + pvDA +
                          as.factor(hour(date)) + months(date) + weekdays(date) +
                          I((wind+pv)/load) + I((windDA+pvDA)/loadDA) +
                          I((wind+pv)/(windDA+pvDA)) + I(load/loadDA), data=data.2016)
model.full.intraday <- lm(priceIntraday ~ I(load - loadDA) + I(sign(load-loadDA) * (load-loadDA) ^ 2) +
                          I(wind-windDA) + I(sign(wind-windDA) * (wind-windDA) ^ 2) +  
                          as.factor(hour(date)) + months(date) + 
                          I((wind+pv)/load) + I((wind+pv)/(windDA+pvDA)) + I(wind > windDA), data=data.2016)

# todo: all summaries

