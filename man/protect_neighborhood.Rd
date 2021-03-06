% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/protect_neighborhood.R
\name{protect_neighborhood}
\alias{protect_neighborhood}
\title{protects raster by summing over the neighborhood}
\usage{
protect_neighborhood(x, radius = 10 * raster::res(x$value)[1], ...)
}
\arguments{
\item{x}{\code{sdc_raster()} object to be protected}

\item{radius}{of the neighborhood to take}

\item{...}{not used at the moment}
}
\value{
\code{sdc_raster} object
}
\description{
protects raster by summing over the neighborhood
}
