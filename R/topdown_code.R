#' Remove revealing high and low values
#'
#' Remove revealing high and low values
#'@keywords internal
topdown_code <- function( r, top = Inf, down = -Inf, ..., upper = top
                        , lower = down){
  clamped <- raster::clamp(r, upper = upper, lower = lower, ...)
  clamped
}
