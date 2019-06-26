#' Create kde density version of a raster
#'
#' Create kde density version of a raster
#' @param x raster object
#' @param bw bandwidth
#' @param smooth_fact `integer`, disaggregates the raster to have a
#' better smoothing
#' @param keep_resolution `integer`, should the returned map have same
#' resolution as `x`?
#' @param na.rm should the `NA` value be removed from the raster?
#' @param pad should the data be padded?
#' @param ... passed through to [`focal`].
#' @param threshold cells with a lower (weighted) value of this threshold will be removed.
#' @export
smooth_raster <- function( x
                         , bw              = raster::res(x)
                         , smooth_fact     = 5
                         , keep_resolution = TRUE
                         , na.rm           = TRUE
                         , pad             = TRUE
                         , threshold       = NULL
                         , ...
                         ){
  if (any(bw < raster::res(x))){
    warning("bandwidth 'bw' is smaller than resolution.")
    return(x)
  }

  x <- raster::disaggregate(x, 5)

  w <- raster::focalWeight(x, bw)
  x_s <- raster::focal(x, w = w, na.rm = na.rm, pad = pad, type="Gaus", ...)

  x_s <- raster::aggregate(x_s, fact = 5, fun=mean)

  if (is.numeric(threshold)){
    is.na(x_s) <- x_s < threshold
  }
  x_s
}

smooth <- function(...){
  .Deprecated("smooth_raster")
  smooth_raster(...)
}
