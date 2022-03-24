#' Simulated data set with enterprise locations.
#'
#' `enterprises` is generated from the dutch open data
#' [BAG register](https://www.kadaster.nl/zakelijk/registraties/basisregistraties/bag/bag-producten).
#' The locations are realistic, but the associated data is simulated.
#' @format An object of class `SpatialPointsDataFrame` with 8348 rows and 2 columns.
#'
#' \describe{
#'  \item{production}{`numeric` simulated production (lognormal).}
#'  \item{fined}{logical simulated variable if an enterprise is fined or not.}
#' }
#' @source Basisregistratie Adressen en Gebouwen: <https://www.kadaster.nl/zakelijk/registraties/basisregistraties/bag/bag-producten>
#' @example ./example/enterprises.R
"enterprises"
