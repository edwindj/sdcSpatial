#' Plot a sdc_raster object
#'
#' Plot a sdc_raster object together with its sensitivity.
#'
#' When `sensitive` is set to `TRUE`, a side-by-side plot will be made of
#' the `value` and its `sensitivity`.
#'
#' @param x [`sdc_raster`] object to be plotted
#' @param value `character` which value layer to be used for plotting, e.g. "sum", "count", "mean" (default).
#' @param sensitive `logical` show the sensitivity in the plot?
#' @param col color palette to be used, passed on to [raster::plot()].
#' @param ... passed on to [raster::plot()]
#' @param main title of plot
#' @family plotting
#' @export
#' @importFrom graphics par
plot.sdc_raster <- function( x
                           , value = "mean"
                           , sensitive = TRUE
                           , ...
                           , main = paste(substitute(x))
                           , col = hcl.colors(20, "Blues", rev = TRUE)
                           ){
  # TODO improve argument handling setting main etc.
  #main <- paste0(main)
  if (isTRUE(sensitive)){
    old_par <- par(mfrow=c(1,2))
    on.exit(par(old_par))
  }

  r <- x$value[[value]]
  raster::plot(r, ..., main=main, col = col)

  if (isTRUE(sensitive)){
    plot_sensitive(x, value = value, col = col, ...)
  }
}

plot_risk <- function(x, ...){
}

#' Plot the sensitive cells of the sdc_raster.
#'
#' Plots t the sensitive cells of the sdc_raster. The sensitive cells are
#' plotted in red. The sensitive cells are determined using [`is_sensitive`].
#'
#' @param x [sdc_raster] object
#' @param value [character] which value layer to be used for values,
#'  e.g. "sum", "count", "mean" (default).
#' @param main [character] title of map.
#' @param ... passed on to [`plot.sdc_raster`].
#' @export
#' @family plotting
#' @family sensitive
#' @importFrom grDevices hcl.colors
plot_sensitive <- function(x, value = "mean", main = "sensitive", ...){
  assert_sdc_raster(x)
  plot.sdc_raster( x, value = value, main = main, sensitive = FALSE
                 , ..., col.main="red"
                 )
  sens <- is_sensitive(x)
  raster::colortable(sens) <- c("transparent", "red")
  raster::plot(sens, add = TRUE)
  invisible(sens)
}
