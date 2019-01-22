#' Create kde density version of a raster
#'
#' @param x raster object
#' @param bw bandwidth
#' @param na.rm should the `NA` value be removed from the raster?
#' @param ... passed through to focal
#' @param threshold cells with a lower (weighted) value of this threshold will be removed.
#' @export
smooth <- function(x, bw = res(x), na.rm = TRUE, pad = TRUE, threshold = 10, ...){
  w <- focalWeight(x, bw)
  s <- threshold * max(w)
  x_s <- focal(x, w = w, na.rm = na.rm, pad = pad, ...)
  #print(sum(x_s[x_s < 10*s]))
  is.na(x_s) <- x_s < s
  x_s
}
