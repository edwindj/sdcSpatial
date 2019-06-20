
b <- sdc_raster(dwellings, "unemployed", r=500)

unsafe <- is_unsafe(b, max_risk = .9, min_count = 10, type="discrete")
plot(unsafe)

#
# dw <- as.data.frame(dwellings)
# b <- sdc_raster(dw[c("x", "y")], dw$unemployed, r = 500)
# b
#
# sp::coordinates(dw) <- ~ x + y
