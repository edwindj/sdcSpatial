library(sdcSpatial)
unemployed <- sdc_raster( dwellings[c("x", "y")] # realistic locations
                          , dwellings$unemployed # simulated data!
                          , r = 100 # raster resolution of 500m
                          , min_count = 10 # min support
)
x <- unemployed
wf <- "haar"
depth <- 3

U <- extract_matrix(unemployed$value$mean)
dim(U)
ux <- make_dyadic(U)
dim(ux)
u2 <- ux |> restore_from_dyadic()
dim(u2)

all(u2 == U, na.rm = TRUE)

p <- wavelet_process(unemployed, "haar", J = 4)
B <- U[]
B[] <- 10

u_dwt <-
  make_dyadic(U) |>
  make_mra(wf = "la8", J = 3) |>
  make_mra_layer()

ln <- u_dwt[[3]]
ln[ln < 0] <- 0

plot_image(ln)
attributes(ln) <- attributes(ux)
ln2 <- restore_from_dyadic(ln)

m <- x$value$mean
m[] <- ln2 |> to_cells()
x$value$mean <- m
plot(x, sensitive = FALSE)
plot_dwt2(u_dwt)

a <- make_dyadic(B) |>
  make_mra(wf = "haar") |>
  make_mra2()

dn <-
  U |>
  make_dyadic() |>
  waveslim::denoise.dwt.2d(J = 5)

dn <-
  U |>
  make_dyadic() |>
  make_mra(wf = "haar", J = 5) |>
  make_mra2()

plot_image(dn[[1]], div = T)
d$HL1

plot_image(a[[4]])
dwt.2d
ux <- make_dyadic(U)
ux

p <- wavelet_process(unemployed)
p$is_below[[4]]

p <- protect_wavelet(unemployed)
p$cnt
plot_image(ux)
plot_image(ux, div=TRUE)

#ux_dwt <- dwt.2d(ux, "la8")
ux_dwt <- waveslim::dwt.2d(ux, "haar")

ux_mra <- make_mra(ux_dwt)
u <- ux_mra[[1]]
for (i in 2:length(ux_mra)){
  u <- u + ux_mra[[i]]
}
plot_image(u)

protect_wavelet(unemployed)

pdf("test.pdf")
old_par <- par(mfrow = c(2,2))
mra2 <- make_mra2(ux_mra)
for (l in mra2){
  plot_image(l, div = TRUE)
}
par(old_par)
dev.off()

library(waveslim)


dwt_cnt <- dwt.2d(ux, wf = "la8")
x <- dwt_cnt


mra <- mra_dwt(x)

af <- farras()$af
dcnt[is.na(cnt)] <- 0
dcnt_a <- afb2D(dcnt, af)


plot_image(dcnt_a$hi[[1]], div=TRUE)

mra_cnt <- mra.2d(dcnt, wf = "la8", method="dwt")
dwt_cnt <- dwt.2d(dcnt, wf = "la8")

length(mra_cnt)

par(mfrow=c(4,4), mar=c(0,0,2,0))

for (n in names(mra_cnt)){
  plot_image(mra_cnt[[n]], div=TRUE, main=n)
}

d <- expand.grid(direction=c("LH", "HL", "HH"), depth=1:4) |>
  transform(layer = paste0(direction,depth))

l <- split(d$layer, paste0("L",d$depth))

par(mfrow=c(2,2), mar=c(0,0,2,0))

for (n in names(l)){
  M <- Reduce(`+`,mra_cnt[l[[n]]])
  plot_image(M, main = n, div=TRUE)
}

M_r <- lapply(l, function(n){
  Reduce(`+`, mra_cnt[n])
})

par(mfrow=c(1,1))

mra_haar <- mra.2d(dcnt, wf="haar")
for (n in names(l)){
  M <- Reduce(`+`,mra_haar[l[[n]]])
  plot_image(M, main = n, div=TRUE)
}


dn  <- denoise.modwt.2d(dcnt, wf = "haar")
# dn[dn < 0] <- 0
plot_image(dn, div=TRUE)
plot_image(dcnt, div=TRUE)
convolve()

plot_image(x)


