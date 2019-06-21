#' Protect a raster with the quadtree method.
#'
#' Protect a raster with the quadtree method.
#' @param x [`sdc_raster`] object
#' @inheritDotParams is_sensitive
#' @return a [`sdc_raster`] object, in which sensitive cells have been recursively aggregated until not sensitive.
#' @export
#' @example ./example/protect_quadtree.R
#' @family protection methods
protect_quadtree <- function(x, ...){
  sdc1 <- x

  zoom <- seq_len(floor(log(min(nrow(x$value), ncol(x$value)), 2)))

  # TODO optional restriction to max zoom
  for (fact in 2^zoom){
    # logical
    z1 <- sdc1$value

    #sdc1$value <- z1
    z1$sens <- is_sensitive(sdc1)

    # maybe use scale of sdc1?
    z1$scale <- 1
    # use scale to adjust count?
    #z1 <- subset(z1, c("sum", "count", "sens", "scale"))

    # not sure if we should do a rescaling of sum and count with scale (if that is sdc1$scale)
    z2 <- raster::aggregate(z1[[c("sum", "count", "sens", "scale")]], fact=fact, fun=sum) #

    # bigger area, so rescale
    z2$sum <- z2$sum/z2$scale
    z2$count <- z2$count/z2$scale

    if (sdc1$type == "numeric"){
      z2$max = raster::aggregate(sdc1$value$max, fact = fact, fun = max)
      # not correct, the max2 of max should be also used!
      z2$max2 = raster::aggregate(sdc1$value$max2, fact = fact, fun = max)
    }
    # reorder z1 to have same order as z2, implicitly dropping "mean'
    z1 <- z1[[names(z2)]]

    z2 <- raster::mask(z2, z2$sens, maskvalue=0)
    z2 <- raster::disaggregate(z2, fact=fact)
    z2 <- raster::crop(z2, z1)
    z2 <- raster::cover(z2, z1)
    sdc1$value <- z2[[c("sum", "count")]]
    sdc1$scale  <- sdc1$scale / z2$scale

    # not directly necessary to do here, but helps in debugging
    sdc1$value$mean <- mean(sdc1)

    if (sdc1$type == "numeric"){
      sdc1$value$max = z2$max
      sdc1$value$max2 = z2$max2
    }
  }
  #last check: if a lowest detail block is still sensitive, replace it with its highest detail.
  sens <- is_sensitive(sdc1, ...)
  value <- raster::mask(x$value, sens, maskvalue = 0)
  value <- raster::cover(value, sdc1$value)
  sdc1$value <- value
  # adjust scale
  sdc1
}

# N <- 4
# r <- raster(extent( 0, N, 0, N), nrow=N, ncol=N)
# l <- list()
# l$sum <- r
# l$sum[] <- 1
# l$sum[1] <- 10
# l$sum[14] <- 5
# l$count <- r
# values(l$count) <- 10
# l$mean <- l$sum/l$count
#
#
# b1 <- brick(l)
# as.matrix(b1$count)
#
# sdc <- new_sdc_raster(b1, "logical", max_risk = 0.95, min_count=10)
