#' Mask coordinates using a grid
#'
#' Pertubates coordinates by rounding coordinates to grid coordinates
#' @param x coordinates
#' @param r grid resolution
#' @param plot if `TRUE` the points (black) and the pertubation (red) will be plotted
#' @family point pertubation
#' @example ./example/mask.R
#' @export
mask_grid <- function(x, r, plot=FALSE){
  if (is.numeric(r)){
    if (length(r) == 1){
      r <- c(r,r)
    }
    stopifnot(length(r) == 2)
  } else if (is(r, "raster")){
    r <- raster::res(r)
  } else {
    stop("invalid input", call. = FALSE)
  }
  gx <- r[1]*floor(x[,1]/r[1])
  gy <- r[2]*floor(x[,2]/r[2])

  if (isTRUE(plot)){
    x_g <- cbind(gx,gy)
    plot(rbind(x, x_g), type="n", axes = TRUE, xlab="", ylab="", las=1)
    graphics::points(x, col="black", pch=19)
    graphics::grid()
    graphics::points(x_g, col = "red")
  }

  x[,1] <- gx
  x[,2] <- gy
  x
}
