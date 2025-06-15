library(sdcSpatial)

data("dwellings")

cons <- sdc_raster(
  dwellings[c("x","y")],
  variable = dwellings$"consumption",
  r = 500
)

plot(cons)
cons_smooth <- cons |> protect_smooth(bw=500)
plot(cons_smooth)

cons_quad <- cons |> protect_quadtree()
plot(cons_quad)

C <- cons$value$mean |> extract_matrix() |> make_dyadic()
oldpar <- par(mar=c(0,0,0,0))
plot_image(C)

cons_smooth$value$mean |>
  extract_matrix() |>
  make_dyadic() |>
  plot_image()

cons_quad$value$mean |>
  extract_matrix() |>
  make_dyadic() |>
  plot_image()

Cv <- C
Cv[is.na(C)] <- 0
wv <- waveslim::dwt.2d(Cv, wf="la8", J = 3)


C_sum <- cons$value$sum |>
  extract_matrix() |>
  make_dyadic() |>
  waveslim::dwt.2d(wf="la8", J = 3) |>
  waveslim::sure.thresh() |>
  waveslim::idwt.2d()

C_count <- cons$value$count |>
  extract_matrix() |>
  make_dyadic() |>
  waveslim::dwt.2d(wf="la8", J = 3) |>
  waveslim::sure.thresh() |>
  waveslim::idwt.2d()

plot_image(C_sum/C_count)

C_s <- wv |>
  waveslim::sure.thresh()|>
  waveslim::idwt.2d()

C_s[C_s < 0] <- 0
C_s <- sum(Cv)/sum(C_s) * C_s

png("./example/dwelling_%i.png", width=800, height=800)
plot_image(C)
plot_image(C_s)
dev.off()


compare_rast(C, C_s)
compare_rast(cons$value$mean, cons_quad$value$mean)
compare_rast(cons$value$mean, cons_smooth$value$mean)

compare_rast(cons$value$sum, cons_quad$value$sum)
compare_rast(cons$value$sum, cons_smooth$value$sum)

compare_rast(cons$value$count, cons_quad$value$count)
compare_rast(cons$value$count, cons_smooth$value$count)

