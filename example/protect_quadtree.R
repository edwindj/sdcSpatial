library(raster)


r <- create_raster(enterprises)
r[] <- 1
r
a <- aggregate(r, fact = 2, fun = sum, expand=T)
a
plot(a)

extent(r)
extent(a)
r <- sdc_raster(enterprises, enterprises$fined)
r$info


N <- 4
r <- raster(extent(0,N,0,N), nrow=N, ncol=N)
l <- list()
l$sum <- r
l$sum[] <- 1
l$sum[1] <- 10
l$count <- r
values(l$count) <- 10

b <- brick(l)
sdc <- new_sdc_raster(b, "logical")
plot(sdc)
plot(is_sensitive(sdc))

a <- aggregate(b, fact=2, fun=sum)
sdc_a <- new_sdc_raster(a, "logical")
sdc_a
plot(sdc_a)

plot(is_sensitive(sdc_a))
plot(is_sensitive(sdc_a), zlim=c(0,1), col=c("white", "red"))

