#' returns one but highest contribution
#' @keywords internal
max2 <- function(x, default_value = 0, na.rm=TRUE){
  if (length(x) > 1){
    x[order(x, decreasing = TRUE)][2]
  } else {
    default_value
  }
}
