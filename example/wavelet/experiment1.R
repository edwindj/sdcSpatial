library(sdcSpatial)
library(waveslim)


make_mra <- function(x, wf = "la8", J = 4, ...){
  x_dwt <- waveslim::dwt.2d(x, wf, J = J, ...)
  zeros <- x_dwt
  zeros[] <- lapply(zeros, function(x){
    x[] <- 0
    x
  })

  mra <- lapply(names(x_dwt), function(n){
    zeros[[n]] <- x_dwt[[n]]
    waveslim::idwt.2d(zeros)
  })
  names(mra) <- names(x_dwt)
  mra
}

