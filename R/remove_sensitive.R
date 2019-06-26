#' Remove sensitive cells from raster
#'
#' `remove_sensitive` removes sensitive cells from a [`sdc_raster`].
#' The sensitive cells, as found by [is_sensitive()] are set to NA.
#'
#' Removing sensitive cells is a protection method, which often is useful to
#' finalize map protection after other protection methods have been applied.
#' `mask_sensitive` and `remove_sensitive` are synonyms, to accommodate both
#' experienced `raster` users as well as sdc users.
#' @inheritParams is_sensitive
#' @param ... passed on to [`is_sensitive`].
#' @return sdc_raster object with sensitive cells set to `NA`.
#' @example ./example/remove_sensitive.R
#' @rdname remove_sensitive
#' @export
#' @family sensitive
#' @family protection methods
remove_sensitive <- function( x
                            , max_risk = x$max_risk
                            , min_count = x$min_count, ...
                            ){
  # resetting the sensitivity settings
  x$max_risk <- max_risk
  x$min_count <- min_count

  # calculate sensitive stuff
  sensitive <- is_sensitive(x, ...)
  # removing/masking the data
  x$value <- raster::mask(x$value, sensitive, maskvalue = 1)
  x
}


#' @export
#' @rdname remove_sensitive
mask_sensitive <- remove_sensitive
