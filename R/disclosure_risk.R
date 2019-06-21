#' Calculate disclosure risk
#'
#' Different risk functions can be used:
#'
#' - external (numeric variable), calculates how much the largest value comprises the total sum
#' - internal (numeric variable), calculates how much the largest value comprises the sum without the second largest value
#' - discrete (logical variable), calculates the fraction of sensitive values.
#'
#' @param x [sdc_raster] object created with [sdc_raster()]
#' @param risk_type what kind of measure should be used.
#' @return [raster::raster] object with the disclosure risk.
#' @export
#' @family sensitive
disclosure_risk <- function(x, risk_type = x$risk_type){
  assert_sdc_raster(x)
  risk_type <- match.arg(risk_type)

  if (x$type == "logical" && risk_type != "discrete"){
    risk_type <- "discrete"
    message("setting risk type to 'discrete'.")
  }

  r <- x$value
  risk <-
    switch( risk_type
            , external = r$max / r$sum
            , internal = r$max / (r$sum - r$max2)
            , discrete = r$sum / r$count
  )
  names(risk) <- "disclosure risk"
  risk
}
