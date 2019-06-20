#' Calculate statistics needed for controling the disclosure
#'
#' Calculate statistics needed for controling the disclosure
#' @param x [sp::SpatialPointsDataFrame] or [sf::sf] object that is used to create a raster.
#' @param variable name of data column or numeric with same length as `x`
#' to be used for the data.
#' @param r either a desired resolution or a pre-existing [raster::raster] object.
#' @param ... passed through to [raster::rasterize()]
#' @param field synonym for `variable`. If both supplied, `field` has precedence.
#' @example ./example/sdc_raster.R
#' @export
#' @importFrom methods is
sdc_raster <- function(x,  variable, r = 200, ..., field = variable){
  if (!is(r, "Raster")){
    if (is.numeric(r) && length(r) < 3 ){
      r <- create_raster(x, res = r)
    } else{
      stop("'r' must be either a raster or the size of a raster")
    }
  }

  v <- if (is.character(field)) x[[field]] else field
  type <- if (is.numeric(v)) {
    "numeric"
  } else if (is.logical(v)){
    "logical"
  } else {
    stop("'variable' is not a numeric or logical.")
  }

  l <- list()

  # this is the value to be plotted
  l$mean <- raster::rasterize(x, r, fun = mean, field = field)

  # these are used in the smoothing and aggregation
  l$sum <- raster::rasterize(x, r, fun = sum, field = field)
  l$count <- raster::rasterize(x, r, fun = "count", field = field)

  if (type == "numeric"){
    l$max <- raster::rasterize(x, r, fun = max, field = field)
    l$max2 <- raster::rasterize(x, r, fun = max2, field = field)
  }

  info <- raster::brick(l, ...)

  new_sdc_raster(info, type = type)
}

# r is the result of sdc_raster
new_sdc_raster <- function(r, type = c("numeric", "logical")){
  structure(
    list(
      value = r$sum / r$count,
      resolution = raster::res(r),
      info = r,
      scale = 1, # needed for smoothing ops
      type = type
    ), class="sdc_raster")
}

is_sdc_raster <- function(x, ...){
  ("sdc_raster" %in% class(x))
}

assert_sdc_raster <- function(x, ...){
  if (!is_sdc_raster(x)){
    stop("an object of type sdc_raster was expected.")
  }
}
