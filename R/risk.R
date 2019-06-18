#' Raster with unsafe locations
#'
#' Create a binary raster with unsafe locations.
#'
#' Different risk functions can be used:
#'
#' - external (numeric variable), calculates how much the largest value comprises the total sum
#' - internal (numeric variable), calculates how much the largest value comprises the sum without the second largest value
#' - discrete (logical variable), calculates the fraction of sensitive values.
#'
#' @param r [raster::brick] object created with [block_estimate()]
#' @param max_risk a risk value higher than `max_risk` will be unsafe.
#' @param min_count a count lower than `min_count` will be unsafe.
#' @param type what kind of measure should be used. (Details)
#' @export
#' @family disclosed
is_unsafe <- function(r, max_risk = 0.95, min_count = 10, type=c("external", "internal", "discrete")){
  risk <- disclosure_risk(r, type = type)
  unsafe <- risk > max_risk | r$count < min_count
  raster::colortable(unsafe) <- c("white", "red")
  unsafe
}

#' Calculate disclosure risk
#'
#' Calculate disclosure risk
#' @param r [raster::brick] object created with [block_estimate()]
#' @param type what kind of measure should be used.
#' @return [raster::RasterLayer] object with the disclosure risk.
#' @export
#' @family disclosed
disclosure_risk <- function(r, type=c("external", "internal", "discrete")){
  type = match.arg(type)
  risk <-
    switch( type
            , external = r$max / r$sum
            , internal = r$max / (r$sum - r$max2)
            , discrete = r$sum / r$count
  )
  risk
}
