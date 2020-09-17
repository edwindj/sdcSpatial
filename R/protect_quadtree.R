#' Protect a raster with  a quadtree method.
#'
#' `protect_quadtree` reduces sensitivy by aggregating sensisitve cells with its
#'  three neighbors, and does this recursively until no sensitive cells are
#'  left or when the maximum zoom levels has been reached.
#'
#' This implementation generalizes the method as described by Suñé et al., in
#' which there is no
#' risk function, and only a  `min_count` to determine sensitivity.
#' Furthermore the method the article
#' only handles count data (`x$value$count`), not mean or summed values.
#' Currently the translation feature of the article is not (yet) implemented,
#' for the original method does not take the `disclosure_risk` into account.
#'
#' @param x [`sdc_raster`] object to be protected.
#' @param max_zoom `numeric`, restricts the number of zoom steps and thereby the max resolution for the
#' blocks. Each step will zoom with a factor of 2 in x and y so the max resolution = resolution * 2^max_zoom.
#' @inheritDotParams is_sensitive
#' @return a [`sdc_raster`] object, in which sensitive cells have been recursively aggregated until not sensitive or
#' when max_zoom has been reached.
#' @export
#' @example ./example/protect_quadtree.R
#' @family protection methods
#' @references Suñé, E., Rovira, C., Ibáñez, D., Farré, M. (2017).
#' Statistical disclosure control on visualising geocoded population data using
#' a structure in quadtrees, NTTS 2017
protect_quadtree <- function(x, max_zoom = Inf, ...){
  # copy the object
  sdc <- x

  zoom <- seq_len(floor(log(min(nrow(x$value), ncol(x$value)), 2)))
  zoom <- zoom[zoom < max_zoom]

  for (fact in 2^zoom){
    # logical
    z1 <- sdc$value

    #sdc1$value <- z1
    z1$sens <- is_sensitive(sdc)

    #
    z1$area <- 1
    # use scale to adjust count?
    #z1 <- subset(z1, c("sum", "count", "sens", "scale"))

    # not sure if we should do a rescaling of sum and count with scale (if that is sdc$scale)
    z2 <- raster::aggregate(z1[[c("sum", "count", "sens", "area")]], fact=fact, fun=sum) #

    # bigger area, so rescale
    z2$sum <- z2$sum/z2$area
    z2$count <- z2$count/z2$area

    if (sdc$type == "numeric"){
      z2$max = raster::aggregate(sdc$value$max, fact = fact, fun = max)
      z2$max <- z2$max / z2$area
      # not correct, the max2 of max should be also used!
      z2$max2 = raster::aggregate(sdc$value$max2, fact = fact, fun = max)
      z2$max2 <- z2$max2 / z2$area
    }
    # reorder z1 to have same order as z2, implicitly dropping "mean'
    z1 <- z1[[names(z2)]]

    #only take value that were sensitive
    z2 <- raster::mask(z2, z2$sens, maskvalue=0)
    z2 <- raster::disaggregate(z2, fact=fact)

    # crop needed because aggregate might have changed the raster size
    z2 <- raster::crop(z2, z1)
    z2 <- raster::cover(z2, z1)

    sdc$value$sum <- z2$sum
    sdc$value$count <- z2$count
    sdc$value$scale <- sdc$value$scale / z2$area

    # not directly necessary to do here, but helps in debugging
    sdc$value$mean <- mean(sdc)

    if (sdc$type == "numeric"){
      sdc$value$max = z2$max
      sdc$value$max2 = z2$max2
    }
  }

  # last check: if a lowest detail block is still sensitive, replace it with its highest detail.
  # sens <- is_sensitive(sdc, ...)
  # value <- raster::mask(x$value, sens, maskvalue = 0)
  # value <- raster::cover(value, sdc$value)
  # sdc$value <- value

  # adjust scale
  sdc
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
# sdc <- new_sdc_raster(b1, "logical", max_risk = 0.95, min_count=10, risk_type = "discrete")
# plot(sdc)
# plot(protect_quadtree(sdc))
