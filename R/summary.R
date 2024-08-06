#' @export
summary.sdc_raster <- function(object, ...){
  x <- object
  r <- x$value

  summ <- cbind( summary(r$sum)
               , summary(r$count)
               )

  structure( list(
    sum = summary(r$sum)
  )
  , class="sdc_raster_summary"
  )
}

#' @export
print.sdc_raster_summary <- function(x, ...){
  x
}
