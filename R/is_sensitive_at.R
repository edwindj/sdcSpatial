#' Calculate sensitivity from  a sdc_raster at x,y locations.
#'
#' Calculate sensitivity from  a sdc_raster at x,y locations.
#' A typical use is to calculate the sensitivity for each of the locations `x`
#' was created with (see example).
#' @param x [sdc_raster()]
#' @param xy matrix of x and y coordinates, or a SpatialPoints or
#' SpatialPointsDataFrame object
#' @inheritDotParams is_sensitive
#' @return `logical` vector with
#' @example ./example/is_sensitive_at.R
#' @family sensitive
#' @export
is_sensitive_at <- function(x, xy, ...){
  assert_sdc_raster(x)
  sens <- is_sensitive(x, ...)
  as.logical(raster::extract(sens, xy))
  # cell <- raster::cellFromXY(sens, xy)
  # sens[cell]
}
