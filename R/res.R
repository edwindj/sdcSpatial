#setOldClass("sdc_raster")

#' @exportS3Method terra::res
res.sdc_raster <- function(x){
  terra::res(x$value)
}
