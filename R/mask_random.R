#' Mask coordinates using random pertubation
#'
#' Pertubates points with a uniform pertubation in a circle.
#' Note that `r` can either be one distance, or a distance per data point.
#' @param x coordinates, `matrix` or `data.frame` (first two columns)
#' @param r `numeric` pertubation distance (vectorized)
#' @param plot if `TRUE` points will be plotted.
#' @return adapted `x` with perturbed coordinates
#' @example ./example/mask.R
#' @export
#' @family point pertubation
mask_random <- function(x, r, plot = FALSE){
  N <- nrow(x)
  a <- stats::runif(N, max = 2*pi)

  px <- r*cos(a) + x[,1]
  py <- r*sin(a) + x[,2]

  if (isTRUE(plot)){
    x_r <- cbind(px,py)
    plot(rbind(x, x_r), type="n", axes = TRUE, xlab="", ylab="", las=1)
    graphics::points(x, col="black", pch=19)
    graphics::grid()
    graphics::points(x_r, col = "red")
  }

  x[,1] <- px
  x[,2] <- py
  x
}


pertubate_random <- mask_random
