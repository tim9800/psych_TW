# Open files
use_r("fa.r")

load_all()




# Function testing zone
fac(bfi, nfactors = 2, fm = "pa", rotate = "oblimin", cor = "mixed")

# Mucking around with mixedCor
library(psych)

data(bfi)

  # Testing whether identifying variable types changes the correlations
  r1_id <- mixedCor(bfi, p=1:5, c=28, d=26)
  r1_id$rho
  r1_blank <- mixedCor(bfi, ncat = 4)
  r1_blank$rho

# Mucking around with switch()
funct <- function(a, b=NULL, c=NULL){
  d <- "I haven't been changed yet"
  switch (a,
          mixed = {d <- "call to mixed"},
          cor = {d <- "call to cor"}
  )
  pass_fwd <- list()
  if (a == "mixed" & !(is.null(b) & is.null(c))){
    
    if (!is.null(b)){
      pass_fwd['b'] = b
    }
    if (!is.null(c)){
      pass_fwd['c'] = c
    }
    
    d <- paste0(d, " with b = ", ifelse(!is.null(b), b, "NULL"),
                " and c = ", ifelse(!is.null(c), c, "NULL"))
    
    
  }
  
  return(d)
}

funct("mixed", b = 2)

params <- list(min=0, max=1)
str(c(n=100, min=0, max=1))
str(list(n=100, min=0, max=1))
str(c(list(n=100),params))
str(c(n=100,params))
str(list(n=100, params))
