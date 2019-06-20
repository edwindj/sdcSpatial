library(raster)

N <- 4
r <- raster(extent(0,N,0,N), nrow=N, ncol=N)
l <- list()
l$sum <- r
l$sum[] <- 1
l$sum[1] <- 10
l$sum[14] <- 5
l$count <- r
values(l$count) <- 10
l$mean <- l$sum/l$count


b1 <- brick(l)
sdc1 <- new_sdc_raster(b1, "logical", max_risk = 0.95, min_count=10)
plot(sdc1)
plot_sensitive(sdc1)

b2 <- subset(sdc1$value, 1:2)
b2$sens <- is_sensitive(sdc1)
b2$scale <- 1
b3 <- aggregate(b2, fact=2, fun=sum)
b3$sum <- b3$sum/4
b3$count <- b3$count/4

b3 <- mask(b3, b3$sens, maskvalue=0)
plot(b3)
b3

b3 <- disaggregate(b3, fact=2)
b3 <- crop(b3, b2)
plot(cover(b3, b2))
