#' Mask coordinates using random pertubation
#'
#' Pertubates points with a uniform pertubation in a circle.
#' Note that `r` can either be one distance, of a distance per data point.
#' @param x coordinates, `matrix` or `data.frame` (first two columns)
#' @param r `numeric` maximum pertubation distance (vectorized)
#' @return adapted `x` with perturbed coordinates
#' @export
#' @family point pertubation
mask_random <- function(x, r){
  N <- nrow(x)
  a <- runif(N, max = 2*pi)

  px <- r*cos(a) + x[,1]
  py <- r*sin(a) + x[,2]

  x[,1] <- px
  x[,2] <- py
  x
}


pertubate_random <- mask_random
