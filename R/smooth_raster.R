#' Create kde density version of a raster
#'
#' Create kde density version of a raster
#' @param x raster object
#' @param bw bandwidth
#' @param na.rm should the `NA` value be removed from the raster?
#' @param pad should the data be padded?
#' @param ... passed through to [`focal`].
#' @param threshold cells with a lower (weighted) value of this threshold will be removed.
#' @export
smooth_raster <- function(x, bw = raster::res(x), na.rm = TRUE, pad = TRUE, threshold = 10, ...){
  w <- raster::focalWeight(x, bw)
  #s <- threshold * max(w)
  x_s <- raster::focal(x, w = w, na.rm = na.rm, pad = pad, ...)
  #is.na(x_s) <- x_s < s
  x_s
}


smooth <- function(...){
  .Deprecated("smooth_raster")
  smooth_raster(...)
}
