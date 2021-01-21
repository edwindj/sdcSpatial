# library(raster)
#
# fined <- sdc_raster(enterprises, enterprises$fined)
# plot(fined)
# fined_qt <- protect_quadtree(fined)
# plot(fined_qt)
#
# fined <- sdc_raster(enterprises, enterprises$fined, r=50)
# plot(fined)
# fined_qt <- protect_quadtree(fined)
# plot(fined_qt)
#
#
#
# library(sf)
# gemeente_2019 <- st_read("https://cartomap.github.io/nl/rd/gemeente_2019.geojson")
# st_crs(gemeente_2019) <- 28992
# nbl <- st_touches(gemeente_2019)
#
# coords <- st_coordinates(st_centroid(gemeente_2019))
# l <- lapply(seq_along(nbl), function(i){
#   nb <- nbl[[i]]
#   st_sfc(lapply(nb, function(j){
#     st_linestring(coords[c(i,j),])})
#   )
# })
# l2 <- do.call(c, l)
#
# edge_list <- as.data.frame(nbl)
# library(data.table)
# el <- as.data.table(edge_list)
# names(el) <- c("from", "to")
#
# edge_list$from <- gemeente_2019$id[edge_list$row.id]
# edge_list$to <- gemeente_2019$id[edge_list$col.id]
# edge_list <- subset(edge_list, row.id < col.id)
# edge_list <- edge_list[,c("from", "to")]
#
# g <- igraph::graph_from_data_frame(edge_list, directed = FALSE)
# plot(g)
# library(igraph)
# i <- match(names(V(g)), gemeente_2019$id)
#
# c2 <- igraph::layout_with_fr(g, coords[i,])
# plot(g, layout = c2)
#
# buurt_2019 <- st_read("https://cartomap.github.io/nl/rd/buurt_2019.geojson")
# st_crs(buurt_2019) <- 28992
# system.time({
#   nbl <- st_touches(buurt_2019)
# })
#
# coords <- st_coordinates(st_centroid(buurt_2019))
# l <- lapply(seq_along(nbl), function(i){
#   nb <- nbl[[i]]
#   st_sfc(lapply(nb, function(j){
#     st_linestring(coords[c(i,j),])})
#   )
# })
# l2 <- do.call(c, l)
#
# plot(l2)
