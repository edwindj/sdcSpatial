#' protects raster by summing over the neighborhood
#' @param x `sdc_raster()`
#' @param radius of the neighborhood to take
protect_neighborhood <- function(x, radius = 10 * raster::res(x$value)[1], ...){
  assert_sdc_raster(x)

  r <- x$value
  # check if this is copy or reference

  w <- raster::focalWeight(r$count, d = radius, type="circle")

  #???
  x$scale <- x$scale * max(w)

  # TODO adjust for keep_resolution
  r$count <- smooth_raster(r$count, bw = radius, type = "circle")
  r$sum <- smooth_raster(r$sum, bw = radius, type = "circle")
  r$mean <- r$sum / r$count

  if (x$type == "numeric"){
    # TODO improve
    r$max <- smooth_raster(r$max, bw = radius, type = "circle")
    r$max2 <- smooth_raster(r$max2, bw = radius, type = "circle")
  }
  x$value <- r
  x
}


## testing
# x <- sdc_raster(enterprises, "production")
# x_n <- protect_neighborhood(x, radius = 600)
# plot(x_n)
