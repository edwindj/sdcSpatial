

test <- expand.grid(
  x = c(0.20, 0.45, 0.70, 0.95), y = c(0.20, 0.45, 0.70, 0.95))

t_rast <- sdc_raster(test, variable = 1, r = 0.25, min_count = 17)
t_qt <- protect_quadtree(t_rast)


is_sensitive(t_qt) # should be 1
raster::values(t_qt$value$scale) # should be 1/16, not 1/64?
