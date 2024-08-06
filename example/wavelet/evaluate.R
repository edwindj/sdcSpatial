library(waveslim)
library(sdcSpatial)
library(data.table)

d <-
'x,y,value
100,100,2
101,101,4
201,101,1
202,102,1
203,102,1
101,201,3
102,202,3
103,202,3
201,201,4
202,202,4
203,202,4
203,203,4
' |> fread()

r <- sdc_raster(d[, .(x, y)], variable = d$value, r = 100, min_count = 5)
data("enterprises")
r <- sdc_raster(enterprises, "production", r = 500, min_count = 3)
plot(r)

r |> protect_quadtree() |> plot()

p_c <- extract_matrix(r$value$count) |> make_dyadic()
p_s <- extract_matrix(r$value$sum) |> make_dyadic()

mra_c <- make_mra(p_c, J = 2, wf="haar")
mra_c2 <- make_mra2(mra_c)
mra_c3 <- make_mra3(mra_c2)

wv_c <- waveslim::dwt.2d(p_c, J=2, wf="haar")
wv_c$LL2[] <- 0
edges <-  waveslim::idwt.2d(wv_c)
plot_image(edges)

plot_image(mra_c$LL2)

plot_image(p_c)
plot_image(p_s)


# plot_image(p_c / p_s)
