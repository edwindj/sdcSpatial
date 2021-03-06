% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/smooth_raster.R
\name{smooth_raster}
\alias{smooth_raster}
\title{Create kde density version of a raster}
\usage{
smooth_raster(
  x,
  bw = raster::res(x),
  smooth_fact = 5,
  keep_resolution = TRUE,
  na.rm = TRUE,
  pad = TRUE,
  padValue = NA,
  threshold = NULL,
  type = c("Gauss", "circle", "rectangle"),
  ...
)
}
\arguments{
\item{x}{raster object}

\item{bw}{bandwidth}

\item{smooth_fact}{\code{integer}, disaggregate factor to have a
better smoothing}

\item{keep_resolution}{\code{integer}, should the returned map have same
resolution as \code{x} or keep the disaggregated raster resulting from
\code{smooth_fact}?}

\item{na.rm}{should the \code{NA} value be removed from the raster?}

\item{pad}{should the data be padded?}

\item{padValue}{what should the padding value be?}

\item{threshold}{cells with a lower (weighted) value of this threshold will be removed.}

\item{type}{what is the type of smoothing (see \code{raster::focal()})}

\item{...}{passed through to \code{\link{focal}}.}
}
\description{
Create kde density version of a raster
}
