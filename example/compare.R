compare_rast <- function(r1, r2, use_na=FALSE){
  v1 <- r1[]
  v2 <- r2[]

  if (use_na){
    v1[is.na(v1)] <- 0
    v2[is.na(v2)] <- 0
  }

  sqrt(mean((v1[] - v2[])^2, na.rm=TRUE))
}

library(sdcSpatial)
data(enterprises)

r <- sdcSpatial::sdc_raster(
  enterprises,
  variable = "production"
)

plot(r)

r$value$mean
r_quad <- r |> protect_quadtree()
r_smooth  <- r |> protect_smooth(bw=400)
r_wav <- r |> protect_wavelet()

r_quad |> plot()
r_smooth |> plot()

r1 <- r$value$mean
r2 <- r$value$mean

compare_rast(r$value$mean, r$value$mean)
compare_rast(r$value$mean, r_quad$value$mean)
compare_rast(r$value$mean, r_quad$value$mean, use_na=TRUE)
compare_rast(r_quad$value$mean, r_smooth$value$mean)
compare_rast(r$value$mean, r_smooth$value$mean, use_na=TRUE)

