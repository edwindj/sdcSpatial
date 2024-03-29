% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mask_random.R
\name{mask_random}
\alias{mask_random}
\title{Mask coordinates using random pertubation}
\usage{
mask_random(x, r, plot = FALSE)
}
\arguments{
\item{x}{coordinates, \code{matrix} or \code{data.frame} (first two columns)}

\item{r}{\code{numeric} pertubation distance (vectorized)}

\item{plot}{if \code{TRUE} points will be plotted.}
}
\value{
adapted \code{x} with perturbed coordinates
}
\description{
Pertubates points with a uniform pertubation in a circle.
Note that \code{r} can either be one distance, or a distance per data point.
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
\seealso{
Other point pertubation: 
\code{\link{mask_grid}()},
\code{\link{mask_voronoi}()},
\code{\link{mask_weighted_random}()}
}
\concept{point pertubation}
