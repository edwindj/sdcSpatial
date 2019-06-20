library(sdcSpatial)
library(raster)

# create a sdc_raster from point data with raster with resolution of 200m
production <- sdc_raster(enterprises, variable = "production", r = 200)

# plot the raster
zlim <- c(0, 3e4)
plot(production, zlim=zlim)

# which raster cells are sensitive?
sensitive <- is_sensitive(production, min_count = 3)
plot(sensitive, col = c('white', 'red'))
cellStats(sensitive, mean)

smoothed <- protect_smooth(production, bw = 400)
smoothed_sensitive <- is_sensitive(smoothed, min_count = 3)
cellStats(smoothed_sensitive, mean)

smoothed_safe <- remove_sensitive(smoothed, min_count = 3)
plot(smoothed_safe, zlim=zlim)
