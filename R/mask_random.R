#' Mask coordinates using random pertubation
#' @param pts coordinates
#' @param r resolution
mask_random <- function(pts, r){
  N <- nrow(pts)
  a <- runif(N, max = 2*pi)
  px <- r*cos(a) + p[,1]
  py <- r*sin(a) + p[,2]
  cbind(x=px,y=py)
}


pertubate_random <- mask_random
