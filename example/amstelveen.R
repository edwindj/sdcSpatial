amstelveen <- read.csv("https://data.nlextract.nl/bag/csv/amstelveen-full.csv", nrows = -1, stringsAsFactors = FALSE, sep=";")

is.na(amstelveen$pandbouwjaar) <- amstelveen$pandbouwjaar > 2018

#View(amstelveen)

library(sf)
library(raster)
library(fasterize)

#rd <- st_as_sf(amstelveen, coords=c("x","y"), crs = 28992)
# m <- st_as_sf(amstelveen, coords=c("lon", "lat"), crs = 4326)
# m

get_raster <- function(x, res = 100){
  ext <- extent(x)[] / res
  ext[c(1,3)] <- floor(ext[c(1,3)])
  ext[c(2,4)] <- ceiling(ext[c(2,4)])
  raster(extent(res*ext), res = res)
}

r100m <- get_raster(amstelveen, res=100)

raster_a <- rasterize(amstelveen[c("x","y")], r100m, fun="count")
raster_year <- rasterize(amstelveen[c("x","y")], r100m, field = amstelveen$pandbouwjaar, fun=mean)
raster_year2 <- rasterize(amstelveen[c("x","y")], r100m, field = amstelveen$pandbouwjaar, fun=sum)

crs(raster_a) <- CRS("+init=epsg:28992")

smooth <- function(x, bw = res(x), na.rm = TRUE, pad = TRUE, threshold = 10, ...){
  w <- focalWeight(x, bw)
  s <- threshold * max(w)
  x_s <- focal(x, w = w, na.rm = na.rm, pad = pad, ...)
  #print(sum(x_s[x_s < 10*s]))
  is.na(x_s) <- x_s < s
  x_s
}

a <- smooth(raster_a, bw = 300, threshold = 20)
plot(a, col = rev(viridis::inferno(10)))

library(leaflet)
inferno <- colorNumeric("inferno", domain = NULL, reverse = T, na.color = "#00000000")

leaflet(options = ) %>%
  addTiles("//geodata.nationaalgeoregister.nl/tiles/service/wmts/brtachtergrondkaartgrijs/EPSG:3857/{z}/{x}/{y}.png", group="pdok") %>% 
  addRasterImage(a, colors = inferno, opacity = 0.8, group="raster") %>% 
  addLayersControl(overlayGroups = "raster")
