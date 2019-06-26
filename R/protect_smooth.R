#' Protect a sdc_raster by smoothing
#'
#' `protect_smooth` reduces the sensitivity by applying a Gaussian smoother,
#' making the values less localized.
#'
#' The sensitivity of a raster can be decreased by applying a kernel density smoother as
#' argued by de Jonge et al. (2016) and de Wolf et al. (2018). Smoothing spatially spreads
#' localized values, reducing the risk for location disclosure. Note that
#' smoothing often visually enhances detection of spatial patterns.
#' The kernel applied is a Gaussian kernel with a bandwidth `bw` supplied by the user.
#' The smoother acts upon the `x$value$count` and `x$value$sum`
#' from which a new `x$value$mean` is derived.
#'
#' @inheritParams smooth_raster
#' @example ./example/protect_smooth.R
#' @export
#' @family protection methods
#' @references de Jonge, E., & de Wolf, P. P. (2016, September).
#' Spatial smoothing and statistical disclosure control.
#' In International Conference on Privacy in Statistical Databases
#' (pp. 107-117). Springer, Cham.
#' @references de Wolf, P. P., & de Jonge, E. (2018, September).
#' Safely Plotting Continuous Variables on a Map. In International Conference
#' on Privacy in Statistical Databases (pp. 347-359). Springer, Cham.
protect_smooth <- function( x
                          , bw = raster::res(x$value)
                          , ...
                          ){
  assert_sdc_raster(x)

  r <- x$value
  # check if this is copy or reference
  w <- raster::focalWeight(r$count, d = bw, type="Gaus")

  # currently choosing center: maybe off center is a better idea
  x$scale <- x$scale * w[ceiling(nrow(w)/4), ceiling(ncol(w)/4)]

  # TODO adjust for keep_resolution
  r$count <- smooth_raster(r$count, bw = bw, ...)
  r$sum <- smooth_raster(r$sum, bw = bw, ...)
  r$mean <- r$sum / r$count

  if (x$type == "numeric"){
    r$max <- smooth_raster(r$max, bw = bw, ...)
    r$max2 <- smooth_raster(r$max2, bw = bw, ...)
  }
  x$value <- r
  x
}
