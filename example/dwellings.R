b <- sdc_raster(dwellings, "unemployed", r=500)

unsafe <- is_unsafe(b, max_risk = .9, min_count = 10, type="discrete")
plot(unsafe)
