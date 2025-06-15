library(raster)
library(data.table)

pts <-
"x,y,value,count
1,1,36,6
1,2,16,4
4,4,40,40
" |> fread()

r <- raster(extent(0,4,0,4), res=1)
r_c <- rasterize(pts[,1:2], r, pts$count, fun="sum")
r_v <- rasterize(pts[,1:2], r, pts$value, fun="sum")

r_m <- r_v/r_c

plot(r_c, col = hcl.colors(20, palette = "Reds", rev=TRUE))
plot(r_v, col = hcl.colors(20, palette = "Blues", rev=TRUE))
plot(r_m, col = hcl.colors(20, palette = "Greens", rev=TRUE))

A_c <- r_c |>
  extract_matrix() |>
  make_dyadic()

A_m <- r_m |>
  extract_matrix() |>
  make_dyadic()

A_v <- r_v |>
  extract_matrix() |>
  make_dyadic()

library(waveslim)
wc <- dwt.2d(A_c, wf = "haar", J = 2)
wv <- dwt.2d(A_v, wf="haar", J = 2)
wv

wv$LH1
# those coeficients are unprotected
wv$HL1[1,1] <- 0
wv$HH1[1,1] <- 0
# and now are the same :-)
idwt.2d(wv)

wv <- dwt.2d(A_v, wf="d4", J = 2, boundary = "reflection")
wc <- dwt.2d(A_c, wf="d4", J = 2, boundary ="reflection")
wca <- wc

mra <- waveslim::mra.2d(A_c, wf = "d4", J = 2, method="dwt")
mra
wv$HL1[1,1] <- 0
idwt.2d(wv)

sdcSpatial:::plot_image(A)
sdcSpatial:::plot_dwt2(wv)
pts2 <- pts
pts2$x <- pts2$x - 0.5
pts2$y <- pts2$y - 0.5

pts2 <- pts2[rep(seq_len(nrow(pts2)), pts2$value),]
pts2$value <- seq_len(nrow(pts2))

qc <- sdcSpatial:::quadcount(pts2, resolution = 1, J=2)
qc

wv$HH1[1,1] <- 0
wv$LH1[1,1] <- 0
wv$HL1[1,1] <- 0
wv

B <- waveslim::idwt.2d(wv)
B[B < 0] <- 0
sdcSpatial:::plot_image(B)
sdcSpatial:::plot_image(A)

B_org <- waveslim::idwt.2d(wv_org)
B_org

wv_s <- waveslim::sure.thresh(wv_org)
B_s <- waveslim::idwt.2d(wv_s)
plot_image(B_s)

sum(B_s)
wv_s
