#' Simulated dwellings data set
#'
#' The data are generated with residence/household locations from the Dutch open
#' data [BAG register](https://zakelijk.kadaster.nl/bag-producten).
#' The locations are realistic, but the associated data is simulated.
#'
#'  * `x`, `integer`, x coordinate of dwelling (crs 28992)
#'  * `y`, `integer`, y coordinate of dwelling (crs 28992)
#'  * `consumption`, `numeric`, simulated continuous value
#'  * `unemployed`, `logical`, simulated discrete value
#'
#' @example ./example/dwellings.R
#' @references Basisregistratie Adressen en Gebouwen
#' <https://zakelijk.kadaster.nl/bag-producten>
"dwellings"
