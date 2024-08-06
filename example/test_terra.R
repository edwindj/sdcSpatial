

system.time({
  r <- sdc_raster(
    dwellings[,c("x","y")],
    variable = dwellings$consumption,
    min_count = 10,
    r = 500
  )
})


system.time({
  gf <- lapply(1:10, function(i){
    M <- matrix(r$value$mean[], nrow=ncol(r$value$mean), ncol=nrow(r$value$mean))
    M[is.na(M)] <- 0
    M2 <- apply_gaussian_filter(M, sigma = 1)
    r2 <- raster(M2, crs = raster::crs(r$value$mean))
    r2
  })
})

system.time({
  p <- protect_smooth(r)
})

plot(r)

M1 <- matrix(as.vector(r$value$mean), nrow=nrow(r$value$mean), byrow=TRUE)
image(t(M1), asp=1)

library(waveslim)
waveslim::
is_sensitive_at(r, matrix( c(150000,460000
                            ,150000,460500
                            )
                         , ncol = 2
                         , byrow = TRUE
                         )
                )
r$value

r |>
  protect_smooth()
