#' quadtree method
#'
#' quadtree method
#' @param x [`sdc_raster`] object
#' @return a [`sdc_raster`] object, which has been
#' @keywords internal
protect_quadtree <- function(r, ...){
  #UseMethod("quadtree")

  # while unsafe or max resolution
  # - 1 aggregate with factor 2^count, count and sum, max
  # - 2 disaggregate with factor 2^count, scale to 2^-count
  # - 3 apply mask to unsafe areas (setting rest to NA)
  # - 4 crop
  # - 5 cover from low detail to high detail
}
