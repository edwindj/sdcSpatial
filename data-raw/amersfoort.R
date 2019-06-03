library(sf)
library(data.table)

mun_2017 <- st_read("https://cartomap.github.io/nl/rd/gemeente_2017.geojson")
buildings <- readRDS("data-raw/buildings.rds")

mun_amersfoort <- mun_2017[mun_2017$statnaam == "Amersfoort", ]
bbox <- st_bbox(mun_amersfoort)
amersfoort <- buildings[ x >= bbox[1] & x <= bbox[3]
                       & y >= bbox[2] & y <= bbox[4]
                       , -c(1,4)
                       ]
dwellings <- as.data.frame(
  amersfoort[woonfunctie==TRUE,.(x = as.integer(x),y = as.integer(y))]
)
use_data(dwellings, overwrite = TRUE)

# am_sf <- st_as_sf(am, coords = c("x", "y"), crs = 28992)
# use_data(am_sf, overwrite = TRUE)
#
# am_sf
