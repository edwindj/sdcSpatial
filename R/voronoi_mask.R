
voronoi_mask <- function(coords, tolerance = 20, k = 10){
  neighbors <- FNN::get.knn(coords, k = 10)
  i <- apply(neighbors$nn.dist > tolerance, 1, which.max)
  nn_index <- neighbors$nn.index[cbind(seq_along(i), i)]
  nn <- coords[nn_index, ]

  coords_vm <- data.frame(
    x = (coords$x + nn$x) / 2,
    y = (coords$y + nn$y) / 2
  )
  coords_vm
}


# testing
# tolerance <- 20
# data("dwellings")
# coords <- dwellings[,1:2]
# coords_vm <- voronoi_mask(coords, tolerance = tolerance)
#
# plot(coords, col=adjustcolor("black", 0.1), pch=19)
# plot(coords_vm, col=adjustcolor("black", 0.1), pch=19)
