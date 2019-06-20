#' mean sensitivity score for raster
#'
#' The mean sensitity score calculates the fraction of cells (with a value)
#' that are considered sensitive according to the used [`disclosure_risk`]
#' @inheritParams is_sensitive
#' @param ... passed on to [`is_sensitive`]
#' @export
sensitivity_score <- function(x, max_risk = x$max_risk, min_count = x$min_count, ...){
  sensitive <- is_sensitive(x, ...)
  raster::cellStats(sensitive, "mean")
}
