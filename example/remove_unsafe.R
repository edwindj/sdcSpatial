library(raster)

b <- block_estimate_logical(dwellings, "unemployed", r=1e3)

# plot the normally rastered data
plot(b$mean, zlim=c(0,1))

r_s <- remove_unsafe(b, type="discrete")

hist(b$mean, xlim=c(0,1), ylim=c(0,150))
hist(r_s, xlim=c(0,1), ylim=c(0,150))

plot(r_s, zlim=c(0,1))
