% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mask_voronoi.R
\name{mask_voronoi}
\alias{mask_voronoi}
\title{Mask coordinates using voronoi masking}
\usage{
mask_voronoi(x, r = 0, k = 10, plot = FALSE)
}
\arguments{
\item{x}{coordinates}

\item{r}{tolerance, nearest voronoi should be at least r away.}

\item{k}{number of neighbors to consider when determining nearest neighbors}

\item{plot}{if \code{TRUE} plots the voronoi tesselation, points (black), and
perturbated points (red), needs package \code{sf}.}
}
\value{
adapted \code{x} with perturbed coordinates
}
\description{
Pertubates points by using voronoi masking. Each point is moved at its nearest
voronoi boundary.
}
\examples{
x <- cbind(
  x = c(2.5, 3.5, 7.2, 1.5),
  y = c(6.2, 3.8, 4.4, 2.1)
)

# plotting is only useful from small datasets!

# grid masking
x_g <- mask_grid(x, r=1, plot=TRUE)

# random pertubation
set.seed(3)
x_r <- mask_random(x, r=1, plot=TRUE)

\donttest{
  if (requireNamespace("FNN", quietly = TRUE)){
    # weighted random pertubation
    x_wr <- mask_weighted_random(x, k = 2, r = 4, plot=TRUE)
  }

  if ( requireNamespace("FNN", quietly = TRUE)
    && requireNamespace("sf", quietly = TRUE)
     ){
    # voronoi masking, plotting needs package `sf`
    x_vor <- mask_voronoi(x, r = 1, plot=TRUE)
  }
}
}
\seealso{
Other point pertubation: 
\code{\link{mask_grid}()},
\code{\link{mask_random}()},
\code{\link{mask_weighted_random}()}
}
\concept{point pertubation}
