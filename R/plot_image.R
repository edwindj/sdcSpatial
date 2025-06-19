#' @importFrom grDevices hcl.colors
#' @importFrom graphics image
plot_image <- function(x, div=FALSE, ..., axes = FALSE, zlim=NULL){

  if (isTRUE(div)){
    palette = "Purple-Green"
    zlim = max(abs(x), na.rm = TRUE) * c(-1,1)
  } else {
    palette = "Blues"
    if (is.null(zlim)){
      zlim = max(x, na.rm = TRUE) * c(0,1)
    }
  }
  old_par <- par(omi = c(0,0,0,0), mar=c(0,0,2,0))
  on.exit({
    par(old_par)
  })
  is.na(x) <- x < .Machine$double.eps
  image( x
         , col = hcl.colors(n = 20, palette = palette, rev=!div)
         , zlim = zlim
         , asp = 1
         , axes = axes
         , useRaster = TRUE
         , ...
  )
}
