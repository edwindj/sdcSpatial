#' protects raster by summing over the neighborhood
#'
#' protects raster by summing over the neighborhood
#' @param x `sdc_raster()` object to be protected
#' @param radius of the neighborhood to take
#' @param ... not used at the moment
#' @return `sdc_raster` object
#' @example ./example/protect_neighborhood.R
#' @export
protect_neighborhood <- function(x, radius = 10 * raster::res(x$value)[1], ...){
  assert_sdc_raster(x)

  r <- x$value
  # TODO adjust for keep_resolution
  r <- smooth_raster(r, bw = radius, type = "circle")
  r$mean <- r$sum / r$count
  x$value <- r
  x
}


## testing
# x <- sdc_raster(enterprises, "production")
# x_n <- protect_neighborhood(x, radius = 600)
# plot(x_n)
