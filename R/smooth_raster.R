#' Create kde density version of a raster
#'
#' Create kde density version of a raster
#' @param x raster object
#' @param bw bandwidth
#' @param smooth_fact `integer`, disaggregate factor to have a
#' better smoothing
#' @param keep_resolution `integer`, should the returned map have same
#' resolution as `x` or keep the disaggregated raster resulting from
#' `smooth_fact`?
#' @param na.rm should the `NA` value be removed from the raster?
#' @param pad should the data be padded?
#' @param padValue what should the padding value be?
#' @param type what is the type of smoothing (see `raster::focal()`)
#' @param ... passed through to [`focal`].
#' @param threshold cells with a lower (weighted) value of this threshold will be removed.
#' @export
smooth_raster <- function( x
                         , bw              = raster::res(x)
                         , smooth_fact     = 5
                         , keep_resolution = TRUE
                         , na.rm           = TRUE
                         , pad             = TRUE
                         , padValue        = NA
                         , threshold       = NULL
                         , type            = c("Gauss", "circle", "rectangle")
                         , ...
                         ){
  if (any(bw < raster::res(x))){
    warning("bandwidth 'bw' is smaller than resolution.")
    return(x)
  }

  x_s <- raster::disaggregate(x, smooth_fact)

  type <- match.arg(type)
  w <- raster::focalWeight(x_s, bw, type = type)
  x_s$scale <- w[1,1] * x_s$scale

  # loop through the layers in the brick
  for (n in names(x_s)){
    if (n %in% c("scale", "mean")){
      next
    }
    x_s[[n]] <- raster::focal(x_s[[n]], w = w, na.rm = na.rm, pad = pad, ...)
  }

  if (isTRUE(keep_resolution)){
    x_s <- raster::aggregate(x_s, fact = smooth_fact, fun=mean)
  }

  if (is.numeric(threshold)){
    is.na(x_s) <- x_s < threshold
  }
  x_s
}

smooth <- function(...){
  .Deprecated("smooth_raster")
  smooth_raster(...)
}
