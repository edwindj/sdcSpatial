#' Get a raster at a certain resolution
#'
#' Get a raster at a certain resolution (with rounded coordinates)
#' @export
get_raster_at <- function(x, res = 100){
    ext <- extent(x)[] / res
    ext[c(1,3)] <- floor(ext[c(1,3)])
    ext[c(2,4)] <- ceiling(ext[c(2,4)])
    raster(extent(res*ext), res = res)
}
