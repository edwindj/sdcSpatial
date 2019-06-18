library(raster)

production <- sdc_raster(enterprises, "production")
zlim <- c(0, 3e4)

plot(production, zlim=zlim)

production_smoothed <- protect_smooth(production, bw = 400)
plot(production_smoothed, zlim=zlim)

production_smooth_safe  <- remove_unsafe(production_smoothed, min_count=2)
plot(production_smooth_safe, zlim=zlim)
