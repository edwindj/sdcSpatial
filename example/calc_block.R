library(raster)
x <- enterprises
block <- calc_block(x, field = "production", r = 500)
