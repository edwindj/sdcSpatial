library(sdcSpatial)
data(dwellings, package = "sdcSpatial")

nrow(dwellings)

r_c <- raster(extent(147000, 163000, 456000, 472000), res=2000)
r_c

r <- sdc_raster(
  dwellings[c("x","y")],
  variable = dwellings$consumption,
  r = r_c
)


plot(r)


d_s <- r$value$sum
d_c <- r$value$count
d_m <- d_s/d_c

get_mat(d_m)

col <- hcl.colors(20, rev=TRUE)

plot(d_m, col=col)

rs <- as.matrix(d_m)
rs <- t(rs[seq_len(nrow(rs)) |> rev(),])
image(rs, col = col, asp=1)

M <- get_mat(d_m)

C <- get_mat(d_c)

C[is.na(C)] <- 0
Cn <- denoise.dwt.2d(C, wf="la8", J=3)
Cn2 <- denoise.modwt.2d(C, wf="la8", J=3)

N <- sum(C)

Cn[Cn < 0] <- 0
Cn <- N * Cn/sum(Cn)


Cn2[Cn2 < 0] <- 0
Cn2 <- sum(C) * Cn2/sum(Cn2)

image(C, col = col, asp=1, main="C")
image(Cn, col = col, asp = 1, main="Cn")
image(Cn2, col = col, asp=1, main="Cn2")

Cn3 <- Cn2
Cn3[Cn2 < 10] <- 0
Cn3 <- Cn3/sum(Cn3) * sum(C)
image(Cn3, col = col, asp=1, main="Cn3")

Cx <- C
Cx[Cx < 10] <- 0
Cx <- Cx/sum(Cx) * sum(C)
image(Cx, col = col, asp=1, main="Cx")

sum(Cn)

library(waveslim)
i_mask <- is.na(rs)
rs[i_mask] <- 0

dwt <- dwt.2d(rs, wf="la8", J = 3)
r$value$count


r1 <- risk1(r, set_na_mean = F)
r1[is.na(r1)] <- 0

dwt <- dwt.2d(d_c, wf="haar")

mra <- mra.2d(r1, wf = "la8", J = 3)
tot <- Reduce(`+`, mra)

l <- group_layers(mra)
clg <- cum_group_layers(mra)

lapply(clg, plot_riskm)

plot_riskm(r1)
plot_riskm(tot)

old_par <- par(mfrow=c(2,3))
lapply(clg, plot_riskm)
par(old_par)
clg[[1]]

C <- r$value$count |>
  get_mat()
C[is.na(C)] <- 0

dwt <- dwt.2d(C, wf="haar", J = 2)
dwt

m <- mra.2d(C, wf = "haar", J = 2, method = "dwt")

c_dwt <-
  C |> modwt.2d(wf = "la8", J = 2)

c_mra <-
   C |>
  mra.2d(wf = "haar", J =2)

c_C <-
  c_mra |>
  cum_group_layers()

c_risk <- lapply(c_C, function(x){
  x[x < 1] <- NA
  r1 <- 1/x
  r1[is.na(r1)] <- 0
  round(r1,2)
  }
)


ab <- which(r1 < .1 & r1 > 0.001, arr.ind = T)

uplevel <- function(x){
  trunc((x - 1) / 2) + 1
}

ind <- uplevel(ab)

dwt2 <- dwt

sum(dwt2$LH1)
sum(dwt2$LH1[ind])

dwt2$LH1[ind] <- 0

dwt2$HL1[ind] <- 0
dwt2$HH1[ind] <- 0

idwt.2d(dwt2)
C

ind2 <- uplevel(ind)

dwt2$HL2[ind2] <- 0
dwt2$LH2[ind2] <- 0
dwt2$HH2[ind2] <- 0

idwt.2d(dwt2)
ab
