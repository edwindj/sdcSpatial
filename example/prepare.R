library(sdcSpatial)
unemployed <- sdc_raster( dwellings[c("x", "y")] # realistic locations
                          , dwellings$unemployed # simulated data!
                          , r = 100 # raster resolution of 500m
                          , min_count = 10 # min support
)

U <- extract_matrix(unemployed$value$mean)
ux <- make_dyadic(U)
ux

protect_wavelet(unemployed)

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
