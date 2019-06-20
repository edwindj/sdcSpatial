#' Plot a sdc_raster object
#'
#' Plot a sdc_raster object
#' @param x [sdc_raster] object to be plotted
#' @param fun function to be used to derive values, e.g. [sum] or [mean] (default).
#' @param ... passed on to [raster::plot()]
#' @param main title of plot
#' @export
#' @family plotting
plot.sdc_raster <- function( x
                           , fun = mean
                           , ...
                           , main = paste(substitute(x))
                           ){
  # TODO improve argument handling setting main etc.
  #main <- paste0(main)
  fun <- match.fun(fun)
  r <- fun(x)
  raster::plot(r, ..., main=main)
}

plot_risk <- function(x, ...){
}

#' Plot the sensitive cells of the sdc_raster
#'
#' Plot the sensitive cells of the sdc_raster
#' @param x [sdc_raster] object
#' @param fun function  used to create visualisation.
#' @inheritDotParams is_sensitive
#' @export
#' @family plotting
plot_sensitive <- function(x, fun = mean, ...){
  assert_sdc_raster(x)
  plot.sdc_raster(x, fun = fun, main = paste(substitute(x), "/ sensitive"))
  sens <- is_sensitive(x, ...)
  raster::colortable(sens) <- c("transparent", "red")
  raster::plot(sens, add = TRUE)
  invisible(sens)
}
