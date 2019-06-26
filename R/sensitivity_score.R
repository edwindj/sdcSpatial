#' Mean sensitivity for raster
#'
#' `sensitivity_score` calculates the fraction of cells (with a value)
#' that are considered sensitive according to the used [`disclosure_risk`]
#' @inheritParams is_sensitive
#' @param ... passed on to [`is_sensitive`]
#' @export
#' @example ./example/sensitivity_score.R
#' @family sensitive
sensitivity_score <- function(x, max_risk = x$max_risk, min_count = x$min_count, ...){
  x$max_risk <- max_risk
  x$min_count <- min_count
  sensitive <- is_sensitive(x, ...)
  raster::cellStats(sensitive, "mean")
}
