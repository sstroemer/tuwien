library(sampleSelection)
data(Mroz87)

Mroz87$kids = as.numeric((Mroz87$kids5 + Mroz87$kids618) > 0)

model.ml <- selection( 
  selection = (lfp  ~ 1 + age + I(age^2) + faminc + kids + educ),
  outcome   = (wage ~ 1 + exper + I(exper^2) + educ + city),
  data=Mroz87, method="ml", type=2
)
model.heckit <- selection( 
  selection = (lfp  ~ 1 + age + I(age^2) + faminc + kids + educ),
  outcome   = (wage ~ 1 + exper + I(exper^2) + educ + city),
  data=Mroz87, method="2step", type=2
)

summary(model.ml)
summary(model.heckit)
