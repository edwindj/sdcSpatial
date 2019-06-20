#' Raster with sensitive locations
#'
#' Create a binary raster with sensitive locations.
#'
#' Different risk functions can be used:
#'
#' - external (numeric variable), calculates how much the largest value comprises the total sum
#' - internal (numeric variable), calculates how much the largest value comprises the sum without the second largest value
#' - discrete (logical variable), calculates the fraction of sensitive values.
#'
#' @param x [sdc_raster] object created with [sdc_raster()]
#' @param max_risk a risk value higher than `max_risk` will be sensitive.
#' @param min_count a count lower than `min_count` will be sensitive.
#' @param type what kind of measure should be used. (Details)
#' @export
#' @family disclosed
is_sensitive <- function(x, max_risk = 0.95, min_count = 10, type=c("external", "internal", "discrete")){
  r_risk <- disclosure_risk(x, type = type)

  r <- x$info
  sensitive <- r_risk > max_risk | r$count < (x$scale*min_count)
  #raster::colortable(sensitive) <- c("white", "red")
  sensitive
}
