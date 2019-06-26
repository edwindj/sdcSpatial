#' Privacy Protected maps
#'
#' `sdcSpatial` contains  functions to create spatial distribution maps,
#' assess the risk of disclosure on a location and to suppress or adjust
#' revealing values at certain locations.
#'
#' `sdcSpatial` working horse is the [sdc_raster()] object upon which the
#' following methods can be applied:
#'
#' @section Sensitivity assessment:
#'
#' - [`plot.sdc_raster()`], [plot_sensitive()]
#' - `print`
#' - [is_sensitive()]
#'
#' @section Protection methods:
#'
#'  - [remove_sensitive()]
#'  - [protect_smooth()]
#'  - [protect_quadtree()]
#'
#' @section Extraction:
#'
#'  - `sum`, extract the `sum` layer from a `sdc_raster` object
#'  - `mean`, extract the `mean` layer from a `sdc_raster` object
#'
#' @references de Jonge, E., & de Wolf, P. P. (2016, September).
#' Spatial smoothing and statistical disclosure control.
#' In International Conference on Privacy in Statistical Databases (pp. 107-117). Springer, Cham.
#' @references de Wolf, P. P., & de Jonge, E. (2018, September).
#' Safely Plotting Continuous Variables on a Map. In International Conference
#'  on Privacy in Statistical Databases (pp. 347-359). Springer, Cham.
#' @references Suñé, E., Rovira, C., Ibáñez, D., Farré, M. (2017). Statistical
#'  disclosure control on visualising geocoded population data using
#' a structure in quadtrees, NTTS 2017
"_PACKAGE"
