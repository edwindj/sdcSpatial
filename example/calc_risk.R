library(raster)
x <- enterprises
risk <- calc_risk(x, field="sens_cont", r = 500)
risk

hist(risk$risk)
plot(risk$risk, col=rev(viridis::magma(10)))
