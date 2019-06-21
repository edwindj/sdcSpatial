library(raster)

fined <- sdc_raster(enterprises, enterprises$fined)
plot_sensitive(fined)
fined_qt <- protect_quadtree(fined)
plot_sensitive(fined_qt)

fined <- sdc_raster(enterprises, enterprises$fined, r=50)
plot_sensitive(fined)
fined_qt <- protect_quadtree(fined)
plot_sensitive(fined_qt)

