
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN
status](https://www.r-pkg.org/badges/version/sdcSpatial)](https://cran.r-project.org/package=sdcSpatial)
[![Travis build
status](https://travis-ci.org/edwindj/sdcSpatial.svg?branch=master)](https://travis-ci.org/edwindj/sdcSpatial)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/edwindj/sdcSpatial?branch=master&svg=true)](https://ci.appveyor.com/project/edwindj/sdcSpatial)

**PACKAGE IS IN DEVELOPMENT (HIGH FLUX), AT THE MOMENT DO NOT USE FOR
PRODUCTION**

# sdcSpatial

`sdcSpatial` is a R package to create smoothed spatial maps with the
extra restriction that it tries protect the privacy of the individuals
within the original data set.

## Installation

Currently `sdcSpatial` can only be installed with `devtools`

``` r
remotes::install_github("edwindj/sdcSpatial")
```

## Example

``` r
library(sdcSpatial)
#> 
#> Attaching package: 'sdcSpatial'
#> The following object is masked from 'package:stats':
#> 
#>     smooth

data("enterprises")

r <- create_raster(enterprises)
r_cont <- raster::rasterize(enterprises, r, field='sens_cont', fun = mean)
raster::plot(r_cont)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

enterprises_df <- as.data.frame(enterprises)
summary(enterprises_df)
#>        x               y            sens_cont         sens_discrete  
#>  Min.   :68508   Min.   :440024   Min.   :    59.46   Mode :logical  
#>  1st Qu.:71613   1st Qu.:444007   1st Qu.:  1019.98   FALSE:7931     
#>  Median :74296   Median :446297   Median :  1954.32   TRUE :417      
#>  Mean   :74649   Mean   :445821   Mean   :  3249.59                  
#>  3rd Qu.:77227   3rd Qu.:447798   3rd Qu.:  3901.44                  
#>  Max.   :82499   Max.   :449000   Max.   :114467.56
```
