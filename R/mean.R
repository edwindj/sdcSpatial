#' @export
mean.sdc_raster <- function(x, ...){
  r <- x$value
  r$sum/r$count
}

#' @export
sum.sdc_raster <- function(..., na.rm = TRUE){
  x <- list(...)[[1]]
  x$value$sum
}
