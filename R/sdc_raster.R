#' Create a raster map with privacy awareness
#'
#' `sdc_raster` creates multiple [`raster::raster`] objects
#' ("count", "mean", "sum") from supplied point data `x` and calculates
#' the sensitivity to privacy disclosure for each raster location.
#'
#' A `sdc_raster` object is the vehicle that does the book keeping for calculating
#' sensitivity. Protection methods work upon a `sdc_raster` and return a new
#' `sdc_raster` in which the sensitivity is reduced.
#' The sensitivity of the map can be assessed with [sensitivity_score],
#' [plot.sdc_raster()], [plot_sensitive()] or `print`.
#' Reducing the sensitivity can be done with [protect_smooth()],
#' [protect_quadtree()] and [remove_sensitive()]. Raster maps for `mean`,
#' `sum` and `count` data can be extracted from the `$value` ([raster::brick()]).
#'
#' @param x [sp::SpatialPointsDataFrame], [sf::sf] or a two column matrix or [data.frame]
#' that is used to create a raster map.
#' @param variable name of data column or `numeric` with same length as `x`
#' to be used for the data in the raster map.
#' @param r either a desired resolution or a pre-existing [raster::raster()] object.
#' In the first case, the crs of `x` (if present) will be used, in the latter
#' the properties of the `r` will be kept.
#' @param max_risk `numeric`, the maximum_risk score ([`disclosure_risk`])
#' before a cell in the map is considered sensitive.
#' @param min_count `numeric`, a raster cell with less then `min_count`
#' observations is considered sensitived.
#' @param risk_type passed on to [disclosure_risk()].
#' @param ... passed through to [raster::rasterize()]
#' @param field synonym for `variable`. If both supplied, `field` has precedence.
#' @return object of `class` "sdc_raster":
#' - `$value`: [raster::brick()] object with different layers e.g. `count`, `sum`, `mean`, `scale`.
#' - `$max_risk`: see above.
#' - `$min_count`: see above.
#' of protection operation [protect_smooth()] or [protect_quadtree()].
#' - `$type`: data type of `variable`, either `numeric` or `logical`
#' - `$risk_type`, "external", "internal" or "discrete" (see [disclosure_risk()])
#' @example ./example/sdc_raster.R
#' @export
#' @importFrom methods is
#' @family sensitive
sdc_raster <- function( x
                      , variable
                      , r = 200
                      , max_risk = 0.95
                      , min_count = 10
                      , risk_type = c("external", "internal", "discrete")
                      , ...
                      , field = variable
                      ){
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
  risk_type <- if (type == "logical") "discrete" else match.arg(risk_type)

  l <- list()

  # these are used in the smoothing and aggregation
  l$sum <- raster::rasterize(x, r, fun = sum, field = field)
  l$count <- raster::rasterize(x, r, fun = "count", field = field)
  l$mean <- l$sum / l$count

  if (type == "numeric"){
    # needed for disclosure risk
    l$max <- raster::rasterize(x, r, fun = max, field = field)
    l$max2 <- raster::rasterize(x, r, fun = max2, field = field)
  }

  value <- raster::brick(l, ...)
  value$scale <- 1

  new_sdc_raster( value, type = type
                , max_risk = max_risk, min_count = min_count
                , risk_type = risk_type
                )
}

# r is the result of sdc_raster
new_sdc_raster <- function( r
                          , type = c("numeric", "logical")
                          , max_risk
                          , min_count
                          , risk_type
                          ){
  structure(
    list(
      #resolution = raster::res(r),
      value = r,
      max_risk = max_risk,
      min_count = min_count,
      risk_type = risk_type,
      scale = scale, # needed for protecting operations
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

#' @export
print.sdc_raster <- function(x, ...){
  cat(x$type, "sdc_raster object: \n"
      , "  resolution:", raster::res(x$value)
      , ",  max_risk:", x$max_risk
      , ", min_count:", x$min_count
      , "\n   mean sensitivity score [0,1]: ", sensitivity_score(x)
  )
}
