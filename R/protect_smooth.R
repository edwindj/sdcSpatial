#' Protect a sdc_raster by smoothing
#'
#' Protect a sdc_raster by smoothing
#' @inheritParams smooth_raster
#' @example ./example/protect_smooth.R
#' @export
protect_smooth <- function( x
                          , bw = raster::res(x$value)
                          #, na.rm     = TRUE
                          , ...
                          ){
  assert_sdc_raster(x)

  r <- x$info
  # check if this is copy or reference
  w <- raster::focalWeight(r$count, d = bw, type="Gaus")
  x$scale <- w[nrow(w)/2, ncol(w)/2]

  r$count <- smooth_raster(r$count, bw = bw, ...)
  r$sum <- smooth_raster(r$sum, bw = bw, ...)
  # remove?
  r$mean <- r$sum / r$count
  if (x$type == "numeric"){
    r$max <- smooth_raster(r$max, bw = bw, ...)
    r$max2 <- smooth_raster(r$max2, bw = bw, ...)
  }
  x$info <- r
  x$value <- r$sum / r$count
  x
}
