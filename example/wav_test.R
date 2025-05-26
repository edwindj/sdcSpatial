library(raster)
library(data.table)

pts <-
"x,y,value
1,1,6
1,2,4
4,4,20
" |> fread()

r <- raster(extent(0,4,0,4), res=1)
r_v <- rasterize(pts[,1:2], r, pts$value, fun="sum")

plot(r_v, col = hcl.colors(20, palette = "Reds", rev=TRUE))


r_v |>
  extract_matrix() |>
  make_dyadic() |>
  sdcSpatial:::make_mra(J=2)
