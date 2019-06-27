library(raster)

fined <- sdc_raster(enterprises, enterprises$fined)
plot(fined)
fined_qt <- protect_quadtree(fined)
plot(fined_qt)

fined <- sdc_raster(enterprises, enterprises$fined, r=50)
plot(fined)
fined_qt <- protect_quadtree(fined)
plot(fined_qt)

