# use a data.frame to create a sdc_raster
unemployed <- sdc_raster(dwellings[c("x", "y")], dwellings$unemployed, r=200, max_risk = 0.9)

plot(unemployed)
sensitivity_score(unemployed)
plot_sensitive(unemployed)

unemployed_smoothed <- protect_smooth(b, bw = 1e3)
plot_sensitive(unemployed_smoothed)

# or change a data.frame into a sp object
sp::coordinates(dwellings) <- ~ x + y
consumption <- sdc_raster(dwellings, dwellings$consumption, r = 500)
consumption

plot(consumption, col = hcl.colors(256, rev = T, palette = "Purple-Blue"))
plot(consumption)

plot(is_sensitive(consumption), add = TRUE, col=c("transparent", "red"))
plot_sensitive(protect_smooth(consumption))
