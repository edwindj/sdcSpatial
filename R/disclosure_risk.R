#' Calculate disclosure risk
#'
#' Calculate disclosure risk
#' @param x [sdcmap] object created with [block_estimate()]
#' @param type what kind of measure should be used.
#' @return [raster::RasterLayer] object with the disclosure risk.
#' @export
#' @family disclosed
disclosure_risk <- function(x, type=c("external", "internal", "discrete")){
  assert_sdcmap(x)
  if (x$type == "logical" && type != "discrete"){
    type <- "discrete"
    message("setting risk type to 'discrete'.")
  }

  type = match.arg(type)

  r <- x$info
  risk <-
    switch( type
            , external = r$max / r$sum
            , internal = r$max / (r$sum - r$max2)
            , discrete = r$sum / r$count
  )
  names(risk) <- "disclosure risk"
  risk
}
