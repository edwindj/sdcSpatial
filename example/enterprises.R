library(sdcSpatial)
library(raster)

data("enterprises")

production <- sdc_raster(enterprises, "production")
plot(production)
unsafe <- is_unsafe(production)
plot(unsafe)
plot(disclosure_risk(production))


enterprises_df <- as.data.frame(enterprises)
summary(enterprises_df)
