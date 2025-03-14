protect_coarsen <- function(x, fact = 2, ...){
  assert_sdc_raster(x)
  aggregate.sdc_raster(x, fact = fact, ...)
}

#' @export
#' @importFrom stats aggregate
aggregate.sdc_raster <- function(x, fact = 2, ...){
  # copy sdc_raster info
  x_agg <- x
  value <- raster::aggregate( x$value[[c("sum", "count")]]
                            , fact = fact, fun = "sum")
  value$mean <- value$sum / value$count
  if (x$type == "numeric"){
    value$max <- raster::aggregate(x$value$max, fact = fact, fun = "max")
    value$max2 <- raster::aggregate(x$value$max2, fact = fact, fun = "max2")
  }
  value$scale <- raster::aggregate(x$value$scale, fact = fact, fun = "mean")
  value <- value[[names(x$value)]]

  x_agg$value <- value
  #x_agg$scale <- 1 #TODO fix scale
  x_agg
}

# prod <- sdc_raster(enterprises, enterprises$production)
# x <- prod
# aggregate(prod)
# aggregate(x, fact = 4)
# fined <- sdc_raster(enterprises, enterprises$fined, min_count=5)
# x <- fined
# aggregate(x)
