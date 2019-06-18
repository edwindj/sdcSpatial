#' remove unsafe cells from raster
#'
#' remove unsafe cells from raster
#' @inheritParams is_unsafe
#' @return [raster::RasterLayer] with unsafe cells set to `NA`.
#' @family disclosed
#' @example ./example/remove_unsafe.R
#' @export
remove_unsafe <- function(x, max_risk = 0.95, min_count = 10, ...){
  unsafe <- is_unsafe(x, max_risk = max_risk, min_count = min_count, ...)
  r_removed <- x$value
  is.na(r_removed) <- raster::values(unsafe)
  x$value <- r_removed
  x
}
