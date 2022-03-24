#' Simulated dwellings data set
#'
#' The data are generated with residence/household locations from the Dutch open
#' data [BAG register](https://www.kadaster.nl/zakelijk/registraties/basisregistraties/bag/bag-producten).
#' The locations are realistic, but the associated data is simulated.
#'
#' @format a `data.frame` with 90603 rows and 4 columns.
#'
#'  \describe{
#'  \item{x}{integer, x coordinate of dwelling (crs 28992)}
#'  \item{y}{integer, y coordinate of dwelling (crs 28992)}
#'  \item{consumption}{numeric, simulated continuous value}
#'  \item{unemployed}{logical, simulated discrete value}
#' }
#' @source Basisregistratie Adressen en Gebouwen
#' <https://www.kadaster.nl/zakelijk/registraties/basisregistraties/bag/bag-producten>
#' @example ./example/dwellings.R
"dwellings"
