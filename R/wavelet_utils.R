extract_matrix <- function(r){
  x <- raster::as.matrix(force(r))
  x <- x[nrow(x):1,]
  t(x)
}

to_cells <- function(x){
  x <- t(x)
  x <- x[nrow(x):1,]
  x
}

make_dyadic <- function(x){
  nr <- nrow(x)
  nc <- ncol(x)

  dnr <- 2^(ceiling(log2(nr)))
  dnc <- 2^(ceiling(log2(nc)))

  dx <- matrix(0, nrow=dnr, ncol=dnc)
  xr <- seq_len(nr) + (dnr - nr)/2
  xc <- seq_len(nc) + (dnc - nc)/2

  dx[xr, xc] <- x

  list(dx = dx, xr = xr, xc = xc)
  dx[is.na(dx)] <- 0
  dx
}


make_zero <- function(x){
  zero <- x
  zero[] <- lapply(zero, function(x){
    x[,] <- 0
    x
  })
  zero
}
