# Development
library(devtools)
use_r("fa.pooled.r")

# Mucking around with mixedCor
library(psych)

data(bfi)
r1 <- mixedCor(bfi, p=1:5, c=28, d=26)
r1$rho
r2 <- mixedCor(bfi, p=NULL, c=NULL, d=NULL)
r2$rho
