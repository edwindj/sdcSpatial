library(raster)

b <- sdc_raster(dwellings, "unemployed", r=200)

# plot the normally rastered data
plot(b, zlim=c(0,1))
plot_sensitive(b)

b_safe <- remove_sensitive(b, risk_type="discrete")
plot(b_safe, zlim=c(0,1))
