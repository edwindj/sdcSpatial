library(sdcSpatial)
library(raster)

data("enterprises")

production <- sdc_raster(enterprises, "production", min_count = 3)
print(production)

# show the average production per cell
plot(mean(production))

# show the total production per cell
plot(sum(production))

plot_sensitive(production, min_count=2) # adjust sensitivity score

plot(disclosure_risk(production))
