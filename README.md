## Overview
An edited version of the R package [psych](https://github.com/cran/psych).

The current version of psych supposedly allows users to perform EFA on data of "mixed" type. That is, data that contains continuous, dichotomous and/or ordered categorical variables.

`fa1 <- fac(data, nfactors=2, cor="mixed")`

To calculate the correlation matrix, fac calls [`mixedCor`](https://www.rdocumentation.org/packages/psych/versions/2.2.5/topics/mixedCor) behind the scenes. `mixedCor` handles mixed-type datasets by allowing users to identify which variables in the provided dataset are of what type. For example, we can specify that columns 1-4 are continuous, column 5 is polytomous (ordered categorical), and column 6 is dichotomous:

`cor1 <- mixedCor(data, c=1:4, p=5, d=6)`

However, `fac` (and by extension, functions which call `fac`) does not provide this functionality.

This package makes small tweaks to `fac`, as well as `fa` and `fa.pooled` (functions which call `fac`) to address this issue.
