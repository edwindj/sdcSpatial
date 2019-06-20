library(sdcSpatial)
library(raster)

data("enterprises")

production <- sdc_raster(enterprises, "production")
plot(production)
sensitive <- is_sensitive(production)
plot(sensitive)
plot(disclosure_risk(production))


enterprises_df <- as.data.frame(enterprises)
summary(enterprises_df)
