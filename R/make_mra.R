
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

make_mra2 <- function(mra){
  layer <- gsub("[A-z]","", names(mra))
  mra2 <- lapply(split(mra, layer), function(l){
    u <- Reduce(`+`, l)
  })
  mra2
}

make_mra3 <- function(mra2){
  a <- 0
  mra3 <- lapply(rev(mra2), function(x){
    a <<- x + a
    a
  })
  rev(mra3)
}
