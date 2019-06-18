
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN
status](https://www.r-pkg.org/badges/version/sdcSpatial)](https://cran.r-project.org/package=sdcSpatial)
[![Travis build
status](https://travis-ci.org/edwindj/sdcSpatial.svg?branch=master)](https://travis-ci.org/edwindj/sdcSpatial)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/edwindj/sdcSpatial?branch=master&svg=true)](https://ci.appveyor.com/project/edwindj/sdcSpatial)

# sdcSpatial

`sdcSpatial` is a R package to create spatial raster maps from point
data with the restriction that it tries protect the privacy of the
individuals within the original data set.

## Installation

Currently `sdcSpatial` can only be installed with `devtools`

``` r
remotes::install_github("edwindj/sdcSpatial")
```

## Example

``` r
library(sdcSpatial)
library(raster)
#> Loading required package: sp

# create a sdc_raster from point data with raster with resolution of 200m
production <- sdc_raster(enterprises, variable = "production", r = 200)

# plot the raster
zlim <- c(0, 3e4)
plot(production, zlim=zlim)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

# which raster cells are unsafe?
unsafe <- is_unsafe(production, min_count = 3)
plot(unsafe, col = c('white', 'red'))
```

<img src="man/figures/README-example-2.png" width="100%" />

``` r
cellStats(unsafe, mean)
#> [1] 0.6328234

smoothed <- protect_smooth(production, bw = 400)
smoothed_unsafe <- is_unsafe(smoothed, min_count = 3)
cellStats(smoothed_unsafe, mean)
#> [1] 0.1779744

smoothed_safe <- remove_unsafe(smoothed, min_count = 3)
plot(smoothed_safe, zlim=zlim)
```

<img src="man/figures/README-example-3.png" width="100%" />
