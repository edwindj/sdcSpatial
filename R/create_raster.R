#' Create a raster at a certain resolution
#'
#' Utility function to generate a raster at a certain resolution (with rounded coordinates).
#' @param x geographical object (that supports extent).
#' @param res desired resolution (default 200).
#' @param ... passed through to \code{\link{raster}} function.
#' @return [`raster::raster`] object
#' @export
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

#' Create a quad raster at a certain resolution
#'
#' Utility function to generate a raster at a certain resolution.
#' @param x geographical object (that supports extent).
#' @param res desired resolution (default 200).
#' @param ... passed through to \code{\link{raster}} function.
create_quad_raster <- function(x, res = 100, ...){
  ext <- raster::extent(x)[] / res
  dx <- ext[2] - ext[1]
  midx <- ext[1] +  dx/2
  2^ceiling(log(dx, 2))
  ext[c(1,3)] <- floor(ext[c(1,3)])
  ext[c(2,4)] <- ceiling(ext[c(2,4)])
  raster::raster( raster::extent(res*ext)
                  , res = res
                  , crs = raster::crs(x)
                  , ...
  )
}
