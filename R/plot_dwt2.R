
# based on plot.dwt.2d
plot_dwt2 <- function(x, cex.axis = 1, ...){
  J <- attributes(x)$J
  X <- x[[paste("LL", J, sep = "")]]
  for (j in J:1) {
    x.names <- sapply(c("LH", "HL", "HH"), paste, j, sep = "")
    X <- rbind(cbind(X, x[[x.names[2]]]), cbind(x[[x.names[1]]],
                                                x[[x.names[3]]]))
  }
  M <- dim(X)[1]
  N <- dim(X)[2]
    image(1:M, 1:N, X, col = hcl.colors(128, "Blues", rev = TRUE), axes = FALSE,
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
