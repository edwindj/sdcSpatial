library(sdcSpatial)
library(raster)

data("enterprises")

production <- sdc_raster(enterprises, "production", min_count = 3)
print(production)

# show the average production per cell
plot(production, "mean")
plot_sensitive(production, min_count=2) # adjust sensitivity score

production_safe <- remove_sensitive(production)
plot_sensitive(production_safe)
