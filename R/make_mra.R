
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

make_mra_layer <- function(mra){
  layer <- gsub("[A-z]","", names(mra))
  mra2 <- lapply(split(mra, layer), function(l){
    u <- Reduce(`+`, l)
  })
  mra2
}

make_mra_cumsum <- function(mra){
  N <- length(mra)
  last <- mra[[N]]
  for (i in rev(seq_len(N - 1))){
    last <- last + mra[[i]]
    mra[[i]] <- last
  }
  last[last < 0] <- 0
  mra[[1]] <- round(last, digits = 2)
  mra
}


