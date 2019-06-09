library(raster)

data("enterprises")

r <- create_raster(enterprises)
r_cont <- rasterize(enterprises, r, field='sens_cont', fun = mean)
plot(r_cont)

enterprises_df <- as.data.frame(enterprises)
summary(enterprises_df)
