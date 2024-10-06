V <- volcano

pdf("output.pdf")
par(mfrow=c(2,2))

sigmas <- 0.5 * (1:20)

r <- sapply(sigmas, function(sigma){
  t <- system.time({
    V1 <- sdcSpatial:::apply_gaussian_filter(V, sigma = sigma)
  })
  image(V1, asp=1, zlim = c(90,200), main=sigma)
  t
})
dev.off()

t(r[1:3,])


r2 <- sapply(sigmas, function(sigma){
  t <- system.time({
    V1 <- sdcSpatial:::apply_gaussian_filter(V, sigma = sigma,  nthreads = 2L)
  })
  t
})

data(dau, package="waveslim")
pdf("dau.pdf")
par(mfrow=c(2,2))

sigmas <- 0.5 * (0:19)

r <- sapply(sigmas, function(sigma){
  t <- system.time({
    dau1 <- sdcSpatial:::apply_gaussian_filter(dau, sigma = sigma)
  })
  image(dau1, asp=1, zlim = c(0,202), main=sigma)
  t
})
dev.off()

t(r[1:3,])


library(microbenchmark)
microbenchmark::microbenchmark(
  sdcSpatial:::apply_gaussian_filter(V, sigma = 8),
  sdcSpatial:::apply_gaussian_filter(V, sigma = 8, nthreads = 4L),
  sdcSpatial:::apply_gaussian_filter(V, sigma = 8, nthreads = 2L),
  sdcSpatial:::apply_gaussian_filter(V, sigma = 8, nthreads = 1L),
  times = 10
)
