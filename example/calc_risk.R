library(raster)
x <- enterprises
risk <- calc_risk(x, field="production", r = 500)
risk

hist(risk$risk)
hist(risk$max/risk$sum)
hist(smooth(risk$max)/smooth(risk$sum))
hist(smooth(risk$max, bw = 1000)/smooth(risk$sum, bw = 1000))

col <- rev(viridis::magma(10))
plot(risk$mean, col=col)
plot(smooth(risk$sum)/smooth(risk$count), col=col)
raster::mask()
plot(smooth(risk$sum,1000)/smooth(risk$count,1000), col=col)
plot(smooth(risk$mean), col=col)
