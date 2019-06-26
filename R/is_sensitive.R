#' Return raster with sensitive locations.
#'
#' Create a binary raster with sensitive locations.
#'
#' By default the risk settings are taken from `x`, but they can be overriden.
#'
#' Different risk functions can be used:
#'
#' - external (numeric variable), calculates how much the largest value comprises the total sum
#' - internal (numeric variable), calculates how much the largest value comprises the sum without the second largest value
#' - discrete (logical variable), calculates the fraction of sensitive values.
#'
#' @param x [`sdc_raster`] object.
#' @param max_risk a risk value higher than `max_risk` will be sensitive.
#' @param min_count a count lower than `min_count` will be sensitive.
#' @param risk_type what kind of measure should be used (see details).
#' @export
#' @family sensitive
#' @example ./example/is_sensitive.R
is_sensitive <- function( x
                        , max_risk = x$max_risk
                        , min_count = x$min_count
                        , risk_type= x$risk_type
                        ){
  r_risk <- disclosure_risk(x, risk_type = risk_type)

  r <- x$value
  sensitive <- r_risk > max_risk | r$count < (x$scale*min_count)
  names(sensitive) <- "sensitive"
  #raster::colortable(sensitive) <- c("white", "red")
  sensitive
}
