# r is the result of block_estimate
sdcmap <- function(r, type = c("numeric", "logical")){
  structure(
    list(
      value = r$mean,
      resolution = raster::res(r),
      info = r,
      scale = 1, # needed for smoothing ops
      type = type
  ), class="sdcmap")
}

#' @export
plot.sdcmap <- function(x, ...){
  raster::plot(x$value, ...)
}

plot_risk <- function(x, ...){
}

plot_unsafe <- function(x, ...){
}


is_sdcmap <- function(x, ...){
  ("sdcmap" %in% class(x))
}

assert_sdcmap <- function(x, ...){
  if (!is_sdcmap(x)){
    stop("an object of type sdcmap was expected.")
  }
}

