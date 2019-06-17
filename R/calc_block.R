#' @importFrom methods is
calc_block <- function(x,  variable, r = 200, ..., field = variable){
  if (!is(r, "Raster")){
    if (is.numeric(r) && length(r) < 3 ){
      r <- create_raster(x, res = r)
    } else{
      stop("'r' must be either a raster or the size of a raster")
    }
  }
  l <- list()
  l$max <- raster::rasterize(x, r, fun = max, field = field)
  l$max2 <- raster::rasterize(x, r, fun = max2, field = field)

  l$mean <- raster::rasterize(x, r, fun = mean, field = field)
  l$sum <- raster::rasterize(x, r, fun = sum, field = field)
  l$count <- raster::rasterize(x, r, fun = "count", field = field)

  l$risk <- l$max/l$sum
  l$risk2 <- l$max/(l$sum - l$max2)
  # TODO add risk2
  raster::brick(l, ...)
}
