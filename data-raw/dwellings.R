library(sf)
library(data.table)

mun_2017 <- st_read("https://cartomap.github.io/nl/rd/gemeente_2017.geojson")
nl <- st_union(mun_2017)
buildings <- readRDS("data-raw/buildings.rds")

mun_amersfoort <- mun_2017[mun_2017$statnaam == "Amersfoort", ]
bbox <- st_bbox(mun_amersfoort)
amersfoort <- buildings[ x >= bbox[1] & x <= bbox[3]
                       & y >= bbox[2] & y <= bbox[4]
                       & woonfunctie == TRUE
                       , .(x,y)
                       ]

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

set.seed(21)
coords <- amersfoort[,c("x","y")]
values <- rlnorm(nrow(coords), meanlog = log(2000))
amersfoort <- generate_spatial_data(coords, values = values, value = "consumption", n_chunks = 200)

values <- runif(nrow(amersfoort))
amersfoort <- generate_spatial_data(amersfoort, values = values, value = "unemployed", n_chunks = 200)
amersfoort[, unemployed := unemployed < .08]
amersfoort[, x := as.integer(x)]
amersfoort[, y := as.integer(y)]

dwellings <- as.data.frame(amersfoort)
# coordinates(dwellings) <- ~ x+y
# proj4string(dwellings) <- "+init=epsg:28992"
use_data(dwellings, overwrite = TRUE)
