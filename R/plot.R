#' Plot a sdc_raster object
#'
#' Plot a sdc_raster object
#' @param x [`sdc_raster``] object to be plotted
#' @param value `character` which value layer to be used for values, e.g. "sum", "count", "mean" (default).
#' @param sensitive `logical` show the sensitivity in the plot?
#' @param ... passed on to [raster::plot()]
#' @param main title of plot
#' @family plotting
#' @export
plot.sdc_raster <- function( x
                           , value = "mean"
                           , sensitive = TRUE
                           , ...
                           , main = paste(substitute(x))
                           ){
  # TODO improve argument handling setting main etc.
  #main <- paste0(main)
  if (isTRUE(sensitive)){
    old_par <- par(mfrow=c(1,2))
    on.exit(par(old_par))
  }

  r <- x$value[[value]]
  raster::plot(r, ..., main=main)

  if (isTRUE(sensitive)){
    plot_sensitive(x, value = value, ...)
  }
}

plot_risk <- function(x, ...){
}

#' Plot the sensitive cells of the sdc_raster.
#'
#' Plot the sensitive cells of the sdc_raster.
#' @param x [sdc_raster] object
#' @param value [character] which value layer to be used for values, e.g. "sum", "count", "mean" (default).
#' @param main [character] title of map.
#' @param col [character] title of map.
#' @param ... passed on to [raster::plot()].
#' @export
#' @family plotting
plot_sensitive <- function(x, value = "mean", main = "sensitive", ...){
  assert_sdc_raster(x)
  plot.sdc_raster(x, value = value, main = main, sensitive = FALSE, ...)
  sens <- is_sensitive(x)
  raster::colortable(sens) <- c("transparent", "red")
  raster::plot(sens, add = TRUE)
  invisible(sens)
}
