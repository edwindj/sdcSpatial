#source("./R/cbs_colors.R")
#' Plot a relative freq
#'
#' Utility function that plots
#' @param r \code{\link{raster}} created with \code{\link{knn_rel_freq}} or \code{\link{kde_rel_freq}}.
#' @param streets overlay that plots the streets on top.
plot_rel_freq <- function(r, streets = NULL, ...){

  old_par <- par(mar=c(1,1,4,5))
  on.exit({
    par(old_par)
  })

  m <- maxValue(r)
  zlim <- c(m/50, m)
  plot( r
      , col   = rev(viridis::viridis(5))
      , xlab  = ""
      , ylab  = ""
      , zlim  = zlim
      , asp   = 1
      , axes  = FALSE
      , legend = FALSE
      , ...
  )

  if (!is.null(streets)){
    ext <- extent(r)
    streets <- crop(streets, ext)
    plot(streets, bg="transparent", add=TRUE, col="#4d4d4d4d")
  }
}
