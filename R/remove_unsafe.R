#' remove unsafe cells from raster
#'
#' remove unsafe cells from raster
#' @inheritParams is_unsafe
#' @return [raster::RasterLayer] with unsafe cells set to `NA`.
#' @family disclosed
#' @example ./example/remove_unsafe.R
#' @export
remove_unsafe <- function(r, max_risk = 0.95, min_count = 10, ...){
  unsafe <- is_unsafe(r, max_risk = max_risk, min_count = min_count, ...)
  r_removed <- r$mean
  is.na(r_removed) <- raster::values(unsafe)
  r_removed
}
