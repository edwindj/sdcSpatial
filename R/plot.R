#' Plot a sdc_raster object
#'
#' Plot a sdc_raster object
#' @param x [sdc_raster] object to be plotted
#' @param value [character] which value layer to be used for values, e.g. "sum", "count", "mean" (default).
#' @param ... passed on to [raster::plot()]
#' @param main title of plot
#' @family plotting
#' @export
plot.sdc_raster <- function( x
                           , value = "mean"
                           , ...
                           , main = paste(substitute(x))
                           ){
  # TODO improve argument handling setting main etc.
  #main <- paste0(main)
  r <- x$value[[value]]
  raster::plot(r, ..., main=main)
}

plot_risk <- function(x, ...){
}

#' Plot the sensitive cells of the sdc_raster.
#'
#' Plot the sensitive cells of the sdc_raster.
#' @param x [sdc_raster] object
#' @param value [character] which value layer to be used for values, e.g. "sum", "count", "mean" (default).
#' @inheritDotParams is_sensitive
#' @export
#' @family plotting
plot_sensitive <- function(x, value = "mean", ...){
  assert_sdc_raster(x)
  plot.sdc_raster(x, value = value, main = paste(substitute(x), "/ sensitive"))
  sens <- is_sensitive(x, ...)
  raster::colortable(sens) <- c("transparent", "red")
  raster::plot(sens, add = TRUE)
  invisible(sens)
}
