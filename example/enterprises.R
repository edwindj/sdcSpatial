library(sdcSpatial)

data("enterprises")

r <- create_raster(enterprises)
r_cont <- raster::rasterize(enterprises, r, field='sens_cont', fun = mean)
raster::plot(r_cont)

enterprises_df <- as.data.frame(enterprises)
summary(enterprises_df)
