library(sdcSpatial)
library(raster)

# create a sdc_raster from point data with raster with resolution of 200m
production <- sdc_raster(enterprises, variable = "production", r = 200, min_count = 3)

print(production)

# plot the raster
zlim <- c(0, 3e4)
plot(production, zlim=zlim)

# show which raster cells are sensitive
plot_sensitive(production)

# but we can also retrieve directly the raster
sensitive <- is_sensitive(production, min_count = 3)
plot(sensitive, col = c('white', 'red'))

# what is the sensitivy fraction?
sensitivity_score(production)
# or equally
cellStats(sensitive, mean)

# let's smooth to reduce the sensitivity
smoothed <- protect_smooth(production, bw = 400)
plot_sensitive(smoothed)

# what is the sensitivy fraction?
sensitivity_score(smoothed)

# let's remove the sensitive data.
smoothed_safe <- remove_sensitive(smoothed, min_count = 3)
plot(smoothed_safe, zlim=zlim)

# let's communicate!
production_mean <- mean(smoothed_safe)
production_total <- sum(smoothed_safe)

# and cread
filledContour(production_mean, nlevels = 6)
filledContour(production_total, nlevels = 10, col = hcl.colors(11))
