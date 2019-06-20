
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
production <- sdc_raster(enterprises, variable = "production", r = 200, min_count = 3)

print(production)
#> numeric sdc_raster object: 
#>    max_risk: 0.95 , min_count: 3 , resolution: 200 200 
#>    mean sensitivity [0,1]:  0.6328234

# plot the raster
zlim <- c(0, 3e4)
plot(production, zlim=zlim)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

# show which raster cells are sensitive
plot_sensitive(production)
```

<img src="man/figures/README-example-2.png" width="100%" />

``` r

# but we can also retrieve directly the raster
sensitive <- is_sensitive(production, min_count = 3)
plot(sensitive, col = c('white', 'red'))
```

<img src="man/figures/README-example-3.png" width="100%" />

``` r

# what is the sensitivy fraction?
sensitivity_score(production)
#> [1] 0.6328234
# or equally
cellStats(sensitive, mean)
#> [1] 0.6328234

# let's smooth to reduce the sensitivity
smoothed <- protect_smooth(production, bw = 400)
plot_sensitive(smoothed)
```

<img src="man/figures/README-example-4.png" width="100%" />

``` r

# what is the sensitivy fraction?
sensitivity_score(smoothed)
#> [1] 0.1779744

# let's remove the sensitive data.
smoothed_safe <- remove_sensitive(smoothed, min_count = 3)
plot(smoothed_safe, zlim=zlim)
```

<img src="man/figures/README-example-5.png" width="100%" />

``` r

# let's communicate!
production_mean <- mean(smoothed_safe)
production_total <- sum(smoothed_safe)

# and cread
filledContour(production_mean, nlevels = 6)
```

<img src="man/figures/README-example-6.png" width="100%" />

``` r
filledContour(production_total, nlevels = 10, col = hcl.colors(11))
```

<img src="man/figures/README-example-7.png" width="100%" />
