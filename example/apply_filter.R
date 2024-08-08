V <- volcano

system.time({
  V1 <- sdcSpatial:::apply_gaussian_filter(V, sigma = 10)
})
