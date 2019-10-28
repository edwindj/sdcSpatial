library(deldir)
library(sdcSpatial)

xy <- sp::coordinates(enterprises)
d <- deldir(xy[,1], xy[, 2])

idx <- sample(nrow(dwellings), size = 5e3)
d_p <- deldir(dwellings$x[idx], dwellings$y[idx])
plot(d_p)

x <- c(0,   0,   1, 1)
y <- c(0,   1, 0.5, 1)
z <- seq_along(x)

plot(x, y)
library(deldir)
d <- deldir(x, y, z = z, plotit = T)

plot(tile.list(d))
?deldir


f <- function(x){log(1/x)}
d$summary$z <- f(d$summary$del.area)

s <- scales::col_numeric( c("white", "blue")
                        , range(d$summary$z)
                        )

plot.tile.list( tile.list(d)
              , fillcol = s(d$summary$z)
              , showpoints = F
              , border = NA
              )

library(sdcSpatial)
prod <- sdc_raster(enterprises, enterprises$production)
library(raster)

a <- FNN::get.knnx(xy, xy, k = 3)
apply(a$nn.dist, 1, max)

plot(log(prod$value$count), col=sdcSpatial:::Blues10)

prod <- sdc_raster(enterprises, enterprises$production)
cell <- raster::xyFromCell(prod$value, 1:ncell(prod$value))

cell.knn <- FNN::knn.reg(xy, cell, enterprises$production)
r <- raster(prod$value)
r[] <- cell.knn$pred

d <- deldir(xy[,1], xy[,2])

hist(3/d$summary$del.area, breaks=100)

plot(r, col = sdcSpatial:::Blues10)
plot(prod$value$mean, col=sdcSpatial:::Blues10)
plot(protect_smooth(prod)$value$mean, col = sdcSpatial:::Blues10)

r <- sdc_raster(enterprises, enterprises$production)
r_c <- r$value$count

r_c_df <- as.data.frame(r_c, xy = TRUE, na.rm=TRUE)
C <- prod(res(r_c))

d <- deldir(r_c_df)
d$summary$z <- C * r_c_df$count / d$summary$del.area
hist(d$summary$z)
plot(r_c, col = sdcSpatial:::Blues10, asp = 1)

s <- scales::col_numeric( c("white", "blue")
                          , range(d$summary$z)
)

plot.tile.list( tile.list(d)
                , fillcol = s(d$summary$z)
                , showpoints = F
                , border = NA
                , asp = 1
)

tl <- tile.list(d)
tile <- tl[[1]]
pol <- lapply(tl, function(tile){
  st_polygon(
    list(cbind(
      c(tile$x,tile$x[1]),
      c(tile$y, tile$y[1])
      )))
})

pol <- st_as_sfc(pol)

tril <- triang.list(d)
pol <- lapply(tril, function(tri){
  st_polygon(
    list(cbind(
      c(tri$x,tri$x[1]),
      c(tri$y, tri$y[1])
    )))
})

pol <- st_as_sfc(pol)
plot(pol, col = "red", border=adjustcolor("white", 0.3))
