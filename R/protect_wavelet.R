#' @export
#' @param x [sdc_raster()]
#' @param wf wavelet function, see [wavelet::dwt.2d()]
#' @param depth the depth for the wavelet resolution
#' @param ... passed through to [wavelet::dwt.2d()]
protect_wavelet <- function(
    x,
    wf = "la8",
    depth = 4,
    ...
    ){

  assert_sdc_raster(x)
  r <- x$value

  x_cnt <-
    extract_matrix(x$value$count) |>
    make_dyadic()

  x_mra <- x_cnt |>
    make_mra(wf = wf, J = depth) |>
    make_mra_layer()

  cs <- x_mra |> make_mra_cumsum()
  plot_image(cs[[1]])
  a <- cs[[1]]
  a[a <= 0] <- NA
  plot_image(x_mra[[1]])

  n_l <- length(x_mra)

  x_mra_cs <- x_mra

  last <- NULL

  for (i in (n_l-1):1){
    last <- x_mra[[i]] + last
    x_mra_cs[[i]] <- last
  }

  for (i in 1:(n_l-1)){
    l <- x_mra[[i]]
    a <- which(l < risk & l > 0, arr.ind=TRUE)
    f <- 2^i
    a_c <- 2^i * ceiling(a / f)

    a_c1 <- a_c
    a_c1[, 1] <- a_c[, 1] -  1

    a_c2 <- a_c
    a_c2[, 1] <- a_c[, 2] -  1

    a_d <- rbind( a_c, a_c1,a_c2, a_c - 1)
  }

  list(cnt = x_cnt, sum = x_sum)
}


# workhorse...
wavelet_process <- function(r, wf = "haar", J = 4, ...){
  x_cnt <-
    r$value$count |>
    extract_matrix() |>
    make_dyadic()

  x_sum <-
    r$value$sum |>
    extract_matrix() |>
    make_dyadic()

  mra_cnt <- x_cnt |>
    make_mra(wf = wf, J = J, ...) |>
    make_mra2()

  is_below <- lapply(mra_cnt, function(l){
    which(l < 10, arr.ind = TRUE)
  })

  mra_sum <- x_sum |>
    make_mra(wf = wf, J = J, ...) |>
    make_mra2()

  list(mra_cnt = mra_cnt, mra_sum = mra_sum, is_below = is_below)
}
