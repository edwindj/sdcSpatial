#' remove sensitive cells from raster
#'
#' remove sensitive cells from raster
#' @inheritParams is_sensitive
#' @param ... passed on to [`is_sensitive`].
#' @return sdc_raster object with sensitive cells set to `NA`.
#' @family disclosed
#' @example ./example/remove_sensitive.R
#' @export
remove_sensitive <- function(x, max_risk = 0.95, min_count = 10, ...){
  sensitive <- is_sensitive(x, max_risk = max_risk, min_count = min_count, ...)
  r_removed <- x$value
  is.na(r_removed) <- raster::values(sensitive)
  x$value <- r_removed
  x
}
