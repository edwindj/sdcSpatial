#' hellinger distance
#'
#' Hellinger distance calculates the difference between two
#' probability distributions.
#'
#'
#' @param x matrix
#' @param y matrix
#' @export
hellinger_distance <- function(x, y, ..., normalize = TRUE){
  if (dim(x) != dim(y)){
    stop("dimensions of x and y should be same", call. = FALSE)
  }

  # normalize
  if (isTRUE(normalize())){
    x <- x/sum(x)
    y <- y/sum(y)
  }

  # hellinger distance
  sqrt(sum((sqrt(x) - sqrt(y))^2))
}

get_diff <- function(x, y){

}
