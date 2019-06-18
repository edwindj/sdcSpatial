#' Calculate statistics needed for controling the disclosure
#'
#' Calculate statistics needed for controling the disclosure
#' @param x [sp::SpatialPointsDataFrame] or [sf::sf] object that is used to create a raster.
#' @param variable name of data column or numeric with same length as `x`
#' to be used for the data.
#' @param r either a desired resolution or a pre-existing [raster::raster] object.
#' @param ... passed through to [raster::rasterize()]
#' @param field synonym for `variable`. If both supplied, `field` has precedence.
#' @export
#' @importFrom methods is
block_estimate <- function(x,  variable, r = 200, ..., field = variable){
  if (!is(r, "Raster")){
    if (is.numeric(r) && length(r) < 3 ){
      r <- create_raster(x, res = r)
    } else{
      stop("'r' must be either a raster or the size of a raster")
    }
  }
  l <- list()

  # this is the value to be plotted
  l$mean <- raster::rasterize(x, r, fun = mean, field = field)

  # these are used in the smoothing and aggregation
  l$sum <- raster::rasterize(x, r, fun = sum, field = field)
  l$count <- raster::rasterize(x, r, fun = "count", field = field)
  l$max <- raster::rasterize(x, r, fun = max, field = field)
  l$max2 <- raster::rasterize(x, r, fun = max2, field = field)

  raster::brick(l, ...)
}

#' Calculate statistics needed for controling the disclosure
#'
#' Calculate statistics needed for controling the disclosure
#' @param x [sp::SpatialPointsDataFrame] or [sf::sf] object that is used to create a raster.
#' @param variable name of data column to be used for the data.
#' @param r either a desired resolution or a pre-existing [raster::Raster] object.
#' @param ... passed through to [raster::rasterize()]
#' @param field synonym for `variable`. If both supplied, `field` has precedence.
#' @export
#' @importFrom methods is
block_estimate_logical <- function(x,  variable, r = 200, ..., field = variable){
  if (!is(r, "Raster")){
    if (is.numeric(r) && length(r) < 3 ){
      r <- create_raster(x, res = r)
    } else{
      stop("'r' must be either a raster or the size of a raster")
    }
  }
  l <- list()

  # this is the value to be plotted
  l$mean <- raster::rasterize(x, r, fun = mean, field = field)

  # these are used in the smoothing and aggregation
  l$sum <- raster::rasterize(x, r, fun = sum, field = field)
  l$count <- raster::rasterize(x, r, fun = "count", field = field)

  raster::brick(l, ...)
}
