library(sdcSpatial)
prod <- sdc_raster(enterprises
                  , field = "production"
                  , r = 500
                  , min_count = 5
                  )
print(prod)

plot(prod, value="count")

plot(prod, value="count", sensitive = FALSE)

library(raster)
plot(prod$value)
image(prod$value$count)

extract_matrix <- function(r){
  x <- raster::as.matrix(force(r))
  x <- x[nrow(x):1,]
  t(x)
}

to_cells <- function(x){
  x <- t(x)
  x <- x[nrow(x):1,]
  x
}

raster::image

make_dyadic <- function(x){
  nr <- nrow(x)
  nc <- ncol(x)

  dnr <- 2^(ceiling(log2(nr)))
  dnc <- 2^(ceiling(log2(nc)))

  dx <- matrix(0, nrow=dnr, ncol=dnc)
  xr <- seq_len(nr) + (dnr - nr)/2
  xc <- seq_len(nc) + (dnc - nc)/2

  dx[xr, xc] <- x

  list(dx = dx, xr = xr, xc = xc)
  dx[is.na(dx)] <- 0
  dx
}


cnt <- extract_matrix(prod$value$count)

saveRDS(cnt, "data/count.rds")

plot_image <- function(x, div=FALSE, ...){

  if (isTRUE(div)){
    palette = "Purple-Green"
    zlim = max(abs(x), na.rm = TRUE) * c(-1,1)
  } else {
    palette = "Reds"
    zlim = max(x, na.rm = TRUE) * c(0,1)
  }
  # old_par <- par(omi = c(0,0,0,0), mar=c(0,0,2,0))
  # on.exit({
  #   par(old_par)
  # })
  image( x
       , col = hcl.colors(n = 20, palette = palette, rev=!div)
       , zlim = zlim
       , asp = 1
       , axes = FALSE
       , useRaster = TRUE
       , ...
       )
}

dcnt <- cnt |> make_dyadic()

plot_image(dcnt, main="test")

plot_image(cnt, main = "test")
plot_image(cnt, div=TRUE)

library(waveslim)

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
