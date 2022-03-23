#' Mask coordinates using voronoi masking
#'
#' Pertubates points by using voronoi masking. Each point is moved at its nearest
#' voronoi boundary.
#'
#' @param x coordinates
#' @param r tolerance, nearest voronoi should be at least r away.
#' @param k number of neighbors to consider when determining nearest neighbors
#' @param plot if `TRUE` plots the voronoi tesselation, points (black), and
#' perturbated points (red), needs package `sf`.
#' @return adapted `x` with perturbed coordinates
#' @family point pertubation
#' @example ./example/mask.R
#' @export
mask_voronoi <- function(x, r = 0, k = 10, plot = FALSE){
  if (!requireNamespace("FNN", quietly = TRUE)){
    stop("This function needs package 'FNN' to be installed.", call. = FALSE)
  }

  k <- min(k, nrow(x)-1)
  nn <- FNN::get.knn(x, k = k)
  w_d <- apply(nn$nn.dist >= r, 1, which.max)
  w_i <- nn$nn.index[cbind(seq_len(nrow(x)), w_d)]
  x_vm <- x
  x_vm[,1] <- 0.5 * (x[,1] + x[w_i, 1])
  x_vm[,2] <- 0.5 * (x[,2] + x[w_i, 2])

  if (isTRUE(plot)){
    if (!requireNamespace("sf", quietly = TRUE)){
      stop("If `plot=TRUE` package 'sf' needs to be installed.", call. = FALSE)
    }
    vor <- sf::st_voronoi(sf::st_union(
                            sf::st_as_sf(as.data.frame(x), coords=1:2)
                         )
                         , dTolerance = 0
                         , bOnlyEdges = TRUE
                         )
    plot(vor, col = "black", lty=3, axes=TRUE)
    graphics::points(x, col="black", pch=19)
    graphics::points(x_vm, col="red")
  }
  x_vm
}
