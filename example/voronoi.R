data("dwellings")

r <- sdc_raster(dwellings[1:2], dwellings$consumption)
r_sm <- protect_smooth(r, bw= 100)

plot(r_sm)


protect_knn <- function()

a <- distance(r$value$count)
plot(a)

plot(a, col = hcl.colors(256, rev=TRUE))
plot(r$value$count, col=hcl.colors(256, palette = "Plasma", rev=TRUE))

plot(r_sm)
