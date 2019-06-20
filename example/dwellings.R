unemployed <- sdc_raster(dwellings, "unemployed", r=500)

plot(unemployed)
sensitivity_score(unemployed)
plot_sensitive(unemployed)

unemployed_smoothed <- protect_smooth(b, bw = 1e3)
plot(unemployed_smoothed)
plot_sensitive(unemployed_smoothed)
