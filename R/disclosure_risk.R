#' Calculate disclosure risk for raster cells
#'
#' The disclosure risk function is used by [is_sensitive()] to determine the risk of
#' a `raster` cell. It returns a score between 0 and 1 for cells that have a finite
#' value (otherwise `NA`).
#'
#' Different risk functions include:
#'
#' - external (numeric variable), calculates how much the largest value
#' comprises the total sum within a cell
#' - internal (numeric variable), calculates how much the largest value
#' comprises the sum without the second largest value
#' - discrete (logical variable), calculates the fraction of `TRUE` vs `FALSE`
#'
#' @param x [`sdc_raster`] object.
#' @param risk_type `character`: "external", "internal", "discrete".
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
