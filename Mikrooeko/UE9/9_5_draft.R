# read: https://cran.r-project.org/web/packages/mlogit/vignettes/mlogit.pdf

library(AER)
library(mlogit)
library(stats)

# "Data on travel mode choice for travel between Sydney and Melbourne, Australia."
data("TravelMode")

# mlogit:
# alternative specific variables xij with a generic coefficient β | 
# individual specific variables zi with an alternative specific coefficients γj |
# alternative specific variables wij with an alternative specific coefficient δj

# Mixed-Logit Model
mlm.wI  <- mlogit(choice ~ wait + travel + vcost | 1 + income | 0, data = TravelMode,
                  shape = "long", alt.var = "mode", reflevel = "car")
mlm.woI <- mlogit(choice ~ wait + travel + vcost | 0 + income | 0, data = TravelMode,
                  shape = "long", alt.var = "mode", reflevel = "car")

summary(mlm.wI)
summary(mlm.woI)


# Nested-Logit Model
nlm <- mlogit(choice ~ wait + travel + vcost | 1 + income | 0, data = TravelMode,
              shape = "long", alt.var = "mode", reflevel = "car",
              nests = list(bt = c("bus","train"), ca = c("car","air")))

summary(nlm)
# iv:* ... "nest elasticity", not close to each other
# otherwise we could improve the model with un.nest.el = TRUE

# "... it can be shown ...  that this model is compatible with the random utility maximisation hypothesis if all the nest elasticities are in the 0 − 1 interval"

lrtest(mlm.wI, nlm)

D <- 2 * (nlm$logLik - mlm.wI$logLik)
qchisq(.95, df=11 - 9)
