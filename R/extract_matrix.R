#' extracts the matrix from a raster, so that it conforms to geospatial data
extract_matrix <- function(x){
  M <- matrix(
    values(x),
    # x and y coordinates are switched
    nrow=ncol(x),
  )
  # and y coordinates are reversed
  M[,ncol(M):1]
}

# reverts a matrix to a raster layout.
revert_matrix <- function(x){
  t(x[,ncol(x):1])
}

# x <- r$value$mean
#
# M <- extract_matrix(r$value$mean)
# M[is.na(M)] <- 0
# M1 <- apply_gaussian_filter(M, sigma = 0.5)
# is.na(M1) <- (M1 < 0.1)
# plot_image(M1)
#
# plot(protect_smooth(r, bw=250))
#
# values(r$value$mean) <- revert_matrix(M)
# #
# plot(r, sensitive= FALSE)
# image(r$value$mean, asp=1)
