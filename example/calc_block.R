library(raster)
x <- enterprises
block <- block_estimate(x, field = "production", r = 500)
