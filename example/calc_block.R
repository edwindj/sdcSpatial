library(raster)
x <- enterprises
block <- calc_block(x, field="sens_cont", r = 500)

summary(block)

hist(block$risk)
hist(block$risk2)
risk <- getValues(block$risk)
risk2 <- getValues(block$risk2)
dat <- data.frame(risk,risk2)
dat <- tidyr::gather(dat, key = "variable")
dat
library(ggplot2)
ggplot(dat, aes(x = value, col=variable)) + geom_freqpoly(binwidth=0.02)

plot(block)

# hist(smooth_raster(risk$max)/smooth(risk$sum))
# hist(smooth_raster(risk$max, bw = 1000)/smooth(risk$sum, bw = 1000))
#
# col <- rev(viridis::magma(10))
# plot(risk$mean, col=col)
# plot(smooth(risk$sum)/smooth(risk$count), col=col)
# raster::mask()
# plot(smooth(risk$sum,1000)/smooth(risk$count,1000), col=col)
# plot(smooth(risk$mean), col=col)
