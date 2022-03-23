#' Mask coordinates using a grid
#'
#' Pertubates coordinates by rounding coordinates to grid coordinates
#' @family point pertubation
mask_grid <- function(x, r){
  if (is.numeric(r)){
    if (length(r) == 1){
      r <- c(r,r)
    }
    stopifnot(length(r) == 2)
  } else if (is(r, "raster")){
    r <- raster::res(r)
  } else {
    stop("invalid input", call. = FALSE)
  }
  gx <- r*floor(x[,1]/r[1])
  gy <- r*floor(x[,2]/r[2])
  x[,1] <- gx
  x[,2] <- gy
  x
}
