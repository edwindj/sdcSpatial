#' @importFrom grDevices hcl.colors
#' @importFrom graphics image
plot_image <- function(x, div=FALSE, ...){

  if (isTRUE(div)){
    palette = "Purple-Green"
    zlim = max(abs(x), na.rm = TRUE) * c(-1,1)
  } else {
    palette = "Reds"
    zlim = max(x, na.rm = TRUE) * c(0,1)
  }
  # old_par <- par(omi = c(0,0,0,0), mar=c(0,0,2,0))
  # on.exit({
  #   par(old_par)
  # })
  image( x
         , col  = hcl.colors(n = 20, palette = palette, rev=!div)
         , zlim = zlim
         , asp  = 1
         , axes = FALSE
         , useRaster = TRUE
         , ...
  )
}
