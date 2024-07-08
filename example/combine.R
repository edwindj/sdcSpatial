library(sdcSpatial)
unemployed_100m <- sdc_raster( dwellings[c("x","y")], dwellings$unemployed
                               , r = 100) # use a finer raster

library(waveslim)

plot_dwt <- function (x, cex.axis = 1, plot = TRUE, ...)
{
  J <- attributes(x)$J
  X <- x[[paste("LL", J, sep = "")]]
  for (j in J:1) {
    x.names <- sapply(c("LH", "HL", "HH"), paste, j, sep = "")
    X <- rbind(cbind(X, x[[x.names[2]]]), cbind(x[[x.names[1]]],
                                                x[[x.names[3]]]))
  }
  M <- dim(X)[1]
  N <- dim(X)[2]
  if (plot) {
    image(1:M, 1:N, X, col = gray(seq(1,0,length.out=128)), axes = FALSE,
          xlab = "", ylab = "", ...)
    x.label <- NULL
    lines(c(0, N, N, 0, 0) + 0.5, c(0, 0, M, M, 0) + 0.5)
    for (j in J:1) {
      lines(c(M/2^j, M/2^j) + 0.5, 2 * c(0, N/2^j) + 0.5)
      lines(2 * c(0, M/2^j) + 0.5, c(N/2^j, N/2^j) + 0.5)
    }
    at <- c((3 * N + 2)/2^(1:J + 1), (N + 2)/2^(J + 1))
    labs <- c(paste("H", 1:J, sep = ""), paste("L", J, sep = ""))
    axis(side = 1, at = at, labels = labs, tick = FALSE,
         cex.axis = cex.axis)
    axis(side = 2, at = at, labels = labs, tick = FALSE,
         cex.axis = cex.axis)
  }
  else return(X)
  invisible()
}



unemployed_100m |>
  protect_quadtree() |>
  plot()

mn <- extract_matrix(unemployed_100m$value$mean)

unemployed_100m |> plot(sensitive = FALSE)

dmn <- make_dyadic(mn)
dmn

# mra

dmn_mra <- mra.2d(dmn, wf = "haar", J = 4, method = "dwt")

plot_image(dmn_mra$LL1)
plot_image(dmn)

lapply(dmn_mra, range)

str(dmn_mra)
image(dmn_mra$LL1)

dmn_dwt <- dwt.2d(dmn, 'haar', J = 3)
plot_dwt(dmn_dwt)

plot_image(dmn)
plot_image(dmn, div=TRUE)
plot.dwt.2d(dmn_dwt)

af <- farras()$af
dmn[is.na(mn)] <- 0
dmn_a <- afb2D(dmn, af)

plot_image(dmn_a$lo)
plot_image(dmn_a$hi[[1]], div=TRUE)
plot_image(dmn_a$hi[[2]], div = TRUE)
plot_image(dmn_a$hi[[3]], div = TRUE)

str(dmn_a)
waveslim::plot.dwt.2d(dmn_a)

