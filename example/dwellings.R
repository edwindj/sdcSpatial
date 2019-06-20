
b <- sdc_raster(dwellings, "unemployed", r=500)

sensitive <- is_sensitive(b, max_risk = .9, min_count = 10, type="discrete")
plot(sensitive)

#
# dw <- as.data.frame(dwellings)
# b <- sdc_raster(dw[c("x", "y")], dw$unemployed, r = 500)
# b
#
# sp::coordinates(dw) <- ~ x + y
