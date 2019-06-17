library(data.table)
library(sf)

bb <- c( 68500
       , 440000
       , 82500
       , 449000
       )

buildings <- readRDS("data-raw/buildings.rds")
westland <- buildings[ x >= bb[1] & x <= bb[3]
                     & y >= bb[2] & y <= bb[4]
                     & !woonfunctie
                     , .(x = as.integer(x), y = as.integer(y))
                     ]

westland
# continuous var for non-residence
N <- nrow(westland)
set.seed(2019)
sens_dist <- rlnorm(N, meanlog = log(3000))
hist(sens_dist)

library(raster)
w_sf <- st_as_sf(westland, crs=28992, coords=c("x", "y"))
r <- raster(ext = extent(w_sf), res=c(500))
#r
r_d <- rasterize(w_sf, r, fun="count")
#r_d
col <- rev(viridis::magma(5))
plot(r_d, col= col, axes=F, interpolate=F)

coords <- westland[,c("x","y")]
values <- sens_dist

generate_spatial_data <- function(coords, values, value = "value", n_chunks = 20L){
  data <- as.data.table(coords)
  N <- nrow(data)
  n <- trunc(N / n_chunks)
  pts <- sample(N)
  data[, (value) := NA_real_]
  while(length(values) > 0){
    values_h <- head(values, n)
    values <- tail(values, -n)

    pts_h <- head(pts, n)
    pts <- tail(pts, -n)

    idx <- !is.na(data[[value]])

    train <- data[idx,]
    test <- data[pts_h, .(x,y)]
    if (nrow(train)){
      pred <- FNN::knn.reg(train[,.(x,y)], test=test, y = train[[value]])
      o <- order(pred$pred)
      pts_h <- pts_h[o]
      values_h <- sort(values_h)
    }

    data[pts_h, (value) := values_h]
  }
  data
}

coords <- westland[,c("x","y")]
values <- rlnorm(nrow(coords), meanlog = log(2000))
westland <- generate_spatial_data(coords, values = values, value = "production")
values <- runif(nrow(westland))
westland <- generate_spatial_data(westland, values = values, value = "fined")
print(westland)
#discretize with 0.05 score
westland[, fined := fined < 0.05]

# testing
r_v <- rasterize(st_as_sf(westland, coords=c("x", "y")), r, field= "fined", fun=mean)
plot(r_v, col=col, interpolate=F, axes=F, frame=F)
mean(getValues(r_d > 2), na.rm=T)
is.na(r_v) <- getValues(r_d <= 2)
plot(r_v, col=col)

enterprises <- as.data.frame(westland)
coordinates(enterprises) <- ~x+y
proj4string(enterprises) <- "+init=epsg:28992"

use_data(enterprises, overwrite = TRUE)
