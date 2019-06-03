calc_risk <- function(x, r = create_raster(x, res = 200),  field, ...){
  l <- list()
  l$max <- raster::rasterize(x, r, fun=max, field = field)
  l$mean <- raster::rasterize(x, r, fun=mean, field = field)
  l$count <- raster::rasterize(x, r, fun="count", field=field)
  l$risk <- (l$max/l$count)/l$mean
  # TODO add max2
  raster::brick(l, ...)
}

# x <- enterprises
# sp::coordinates(x) <- ~ x+y
# sp::proj4string(x) <- "+init=epsg:28992"
# x
# risk <- calc_risk(x, field="sens_cont")
# risk
#
# library(raster)
# hist(risk$risk)
# plot(risk$risk, col=rev(viridis::magma(10)))
