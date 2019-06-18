library(raster)

b <- block_estimate(dwellings, "unemployed", r=200)

# plot the normally rastered data
plot(b, zlim=c(0,1))

b_safe <- remove_unsafe(b, type="discrete")
plot(b_safe, zlim=c(0,1))

#plot(values(b$value), values(is_unsafe(b)))


b <- block_estimate(dwellings, "unemployed", r=200)

# plot the normally rastered data
plot(b, zlim=c(0,1))

b_safe <- remove_unsafe(b, type="discrete")
plot(b_safe, zlim=c(0,1))

#plot(values(b$value), values(is_unsafe(b)))
