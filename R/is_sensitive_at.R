#' Calculate sensitivity from  raster at x,y locations.
#'
#' Calculate sensitivity from  raster at x,y locations.
#' @param x [sdc_raster()]
#' @param xy matrix of x and y coordinates, or a SpatialPoints or
#' SpatialPointsDataFrame object
#' @inheritDotParams is_sensitive
#' @return `logical` vector with
#' @example ./example/is_sensitive_at.R
#' @export
is_sensitive_at <- function(x, xy, ...){
  sens <- is_sensitive(x, ...)
  as.logical(raster::extract(sens, xy))
  # cell <- raster::cellFromXY(sens, xy)
  # sens[cell]
}
