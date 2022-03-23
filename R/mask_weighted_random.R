#' Mask coordinates using weighted random pertubation
#'
#' This method uses per point the distance to the `k`th neighbor as the maximum
#' pertubation distance. Parameter `r` can be used to restrict the maximum distance
#' of the `k`th neighbor.
#' @inheritParams mask_random
#' @param k `integer` number of neighbors to be used as the maximum distance
#' @references Spatial obfuscation methods for privacy protection of
#' household-level data
#' @export
#' @family point pertubation
mask_weighted_random <- function(x, k = 5, r = NULL){
  if (!requireNamespace("FNN", quietly = TRUE)){
    stop("This function needs package 'FNN' to be installed.", call. = FALSE)
  }

  nn <- FNN::get.knn(pts, k = k)
  d <- nn$nn.dist[,k]

  if (is.finite(r)){
    # restrict maximum distance to r
    d[d > r] <- r
  }
  mask_random(x = x, r = d)
}


pertubate_weighted_random <- mask_weighted_random
