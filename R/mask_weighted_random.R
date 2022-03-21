#' Mask coordinates using weighted random pertubation
#'
#' @param pts coordinates
#' @param r resolution / raster
#' @references Spatial obfuscation methods for privacy protection of
#' household-level data
mask_weighted_random <- function(pts, k = 5, r){
  nn <- FNN::get.knn(pts, k = k)

  # dependent pertubaion
  d <- nn$nn.dist[,k]

}


pertubate_weighted_random <- mask_weighted_random
