#' Mask coordinates using random pertubation
#'
#' Pertubates points with a uniform pertubation in a circle.
#' Note that `r` can either be one distance, of a distance per data point.
#' @param x coordinates, `matrix` or `data.frame` (first two columns)
#' @param r [sdc_raster()] used to generate a value for the observation at hand
#' @return data.frame `x` with (added) masked_value column
#' @example ./example/mask.R
#' @export
masked_values <- function(x, r, plot = FALSE){
  m <- mean(r)
  masked_values <- raster::extract(m, x)
  x$masked_values <- masked_values
  x
}
