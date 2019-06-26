#' Create kde density version of a raster
#'
#' Create kde density version of a raster
#' @param x raster object
#' @param bw bandwidth
#' @param smooth_fact `integer`, disaggregate factor to have a
#' better smoothing
#' @param keep_resolution `integer`, should the returned map have same
#' resolution as `x` or keep the disaggregated raster resulting from
#' `smooth_fact`?
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

  x <- raster::disaggregate(x, smooth_fact)

  w <- raster::focalWeight(x, bw)
  x_s <- raster::focal(x, w = w, na.rm = na.rm, pad = pad, type="Gaus", ...)

  if (isTRUE(keep_resolution)){
    x_s <- raster::aggregate(x_s, fact = smooth_fact, fun=mean)
  }

  if (is.numeric(threshold)){
    is.na(x_s) <- x_s < threshold
  }
  x_s
}

smooth <- function(...){
  .Deprecated("smooth_raster")
  smooth_raster(...)
}
