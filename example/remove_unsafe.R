library(raster)
library(magrittr)

b <- block_estimate(dwellings, "unemployed", r=1e3)

# plot the normally rastered data
b %>%
  plot(zlim=c(0,1))

b %>%
  remove_unsafe() %>%
  plot(zlim=c(0,1))

