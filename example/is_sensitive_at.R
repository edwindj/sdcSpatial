production <- sdc_raster(enterprises, "production")

# add the sensitive variable to original data set.
enterprises$sensitive <- is_sensitive_at(production, enterprises)
