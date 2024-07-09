#' @export
protect_wavelet <- function(
    x,
    wf = "la8",
    depth = 4,
    ...
    ){
  x_cnt <-
    extract_matrix(x$value$count) |>
    make_dyadic() |>
    make_mra(wf = wf, J = depth) |>
    make_mra2()

  x_sum <-
    extract_matrix(x$value$sum) |>
    make_dyadic() |>
    make_mra(wf = wf, J = depth) |>
    make_mra2()

  list(cnt = x_cnt, sum = x_sum)
}
