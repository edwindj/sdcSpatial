#' Create a raster at a certain resolution
#'
#' Utility function to generate a raster at a certain resolution (with rounded coordinates).
#' @param x geographical object (that supports extent).
#' @param res desired resolution (default 200).
#' @param ... passed through to [raster::raster()] function.
#' @return [raster::raster()] object
#' @keywords internal
create_raster <- function(x, res = 200, ...){
  stopifnot(length(res) == 1)
  ext <- raster::extent(x)[] / res
  ext[c(1,3)] <- floor(ext[c(1,3)])
  ext[c(2,4)] <- ceiling(ext[c(2,4)])
  raster::raster( raster::extent(res*ext)
                , res = res
                , crs = raster::crs(x)
                , ...
                )
}
