library(sdcSpatial)
library(raster)

data("enterprises")

production <- calc_block(enterprises, "production")
plot(production)
plot(is_unsafe(production))
plot(disclosure_risk(production))

r <- create_raster(enterprises)
r_cont <- raster::rasterize(enterprises, r, field='production', fun = mean)
raster::plot(r_cont)

enterprises_df <- as.data.frame(enterprises)
summary(enterprises_df)
