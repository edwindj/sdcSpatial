library(sdcSpatial)
library(leaflet)
library(raster)

library(cbsodataR)
gemeente_2018 <- cbsodataR::cbs_get_sf("gemeente", 2018)

data("enterprises")
RES <- 100
SCALE <- 0.7

r <- sdc_raster( enterprises
                 , variable = "production"
                 , r = RES
)


bb <- sf::st_bbox(r$value)  |>
  as.numeric() |>
  setNames(c("xmin", "ymin", "xmax", "ymax"))

gem <-
  gemeente_2018 |>
  sf::st_crop(bb)

library(ggplot2)
library(dplyr)


l <- list()

for (i in RES*(0:10)){
  message("bw: ", i)
  r2 <- r |>
    protect_smooth(bw = i)

  v <- r2$value$mean
  names(v) <- "value"

  # v |>
  #   as.data.frame(xy = TRUE) |>
  #   ggplot() +
  #   geom_raster(aes(x = x , y = y, fill = value)) +
  #   scale_fill_viridis_c(na.value = "transparent", direction = -1) +
  #   geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
  #   geom_sf_text(data = gem, mapping=aes(label = statnaam)) +
  #   labs(fill="", title=sprintf(" bandwith = %im", i)) +
  #   theme_void()
  #
  # ggsave("example/figures/smooth_%i.png" |> sprintf(i), width = 7, height = 5)


  v |>
    as.data.frame(xy = TRUE) |>
    ggplot() +
    geom_raster(aes(x = x , y = y, fill = value)) +
    scale_fill_viridis_c(na.value = "transparent", direction = -1, limits = c(0, 50000)) +
    geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
    geom_sf_text(data = gem, mapping=aes(label = statnaam), alpha = 0.5, size = 3, check_overlap = TRUE) +
    labs(fill="", title=sprintf(" band width = %im", i)) +
    theme_void()

  ggsave(
    "example/figures/fixed_smooth_%i.png" |> sprintf(i),
    width = 7,
    height = 5,
    scale = SCALE
  )

  # v |>
  #   as.data.frame(xy = TRUE) |>
  #   ggplot() +
  #   geom_raster(aes(x = x , y = y, fill = value)) +
  #   scale_fill_viridis_c(na.value = "transparent", direction = -1, limits = c(59, 21000), transform = "log10") +
  #   geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
  #   geom_sf_text(data = gem, mapping=aes(label = statnaam)) +
  #   labs(fill="", title=sprintf(" band width = %im", i)) +
  #   theme_void()
  #
  # ggsave("example/figures/fixed_log_smooth_%i.png" |> sprintf(i), width = 7, height = 5)
  s <- sdcSpatial::sensitivity_score(r2)
  l <- append(l, list(data.frame(bw = i, sensitive = s)))
}

library(data.table)
d <- rbindlist(l)
fwrite(d, "example/figures/sensitive_dep.csv")
d <- fread("example/figures/sensitive_dep.csv")
d |>
  ggplot(aes(x = bw, y = sensitive)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(labels=function(x){paste0(x,"m")}) +
  labs(x = "bandwidth", y = "", title="% disclosed cells per smoothing bandwidth")

ggsave("example/figures/sensitive_dep.png", width = 7, height = 5)


sens <- r |> is_sensitive() |>
  as.data.frame(xy = TRUE) |>
  subset(sensitive == TRUE)

r$value$mean |>
  as.data.frame(xy = TRUE) |>
  ggplot() +
  geom_raster(aes(x = x , y = y, fill = mean)) +
  scale_fill_viridis_c(na.value = "transparent", direction = -1, limits = c(0, 50000)) +
  geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
  geom_sf_text(data = gem, mapping=aes(label = statnaam), alpha = 0.5, size = 3, check_overlap = TRUE) +
  labs(fill="", title="Mean production density") +
  theme_void()
ggsave("example/figures/mean_production_density.png", width = 7, height = 5)

r$value$count |>
  as.data.frame(xy = TRUE) |>
  ggplot() +
  geom_raster(aes(x = x , y = y, fill = count)) +
  scale_fill_viridis_c(na.value = "transparent", direction = -1, option="G") +
  geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
  geom_sf_text(data = gem, mapping=aes(label = statnaam), alpha = 0.5, size = 3, check_overlap = TRUE) +
  labs(fill="", title="Enterprise density") +
  theme_void()

ggsave("example/figures/enterprise_density.png", width = 7, height = 5)


r$value$mean |>
  as.data.frame(xy = TRUE) |>
  ggplot() +
  geom_raster(aes(x = x , y = y, fill = mean)) +
  scale_fill_viridis_c(na.value = "transparent", direction = -1, limits = c(0, 50000)) +
  geom_tile(data = sens, aes(x = x, y = y), fill = "red")+
  geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
  geom_sf_text(data = gem, mapping=aes(label = statnaam), alpha = 0.5, size = 3, check_overlap = TRUE) +
  labs(fill="", title="sensitive") +
  theme_void()

ggsave("example/figures/sensitive.png", width = 7, height = 5)


l2 <- list()
for (i in RES*(1:10)){
  message("res: ", i)
  r3 <- sdc_raster( enterprises
                  , variable = "production"
                  , r = i
  )

  v <- r3$value$mean
  names(v) <- "value"

  v |>
    as.data.frame(xy = TRUE) |>
    ggplot() +
    geom_raster(aes(x = x , y = y, fill = value)) +
    scale_fill_viridis_c(na.value = "transparent", direction = -1, limits = c(0, 50000)) +
    geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
    geom_sf_text(data = gem, mapping=aes(label = statnaam), alpha = 0.5, size = 3, check_overlap = TRUE) +
    labs(fill="", title=sprintf(" resolution = %im", i)) +
    theme_void()

  ggsave("example/figures/res_%i.png" |> sprintf(i), width = 7, height = 5, scale = SCALE)

  # v |>
  #   as.data.frame(xy = TRUE) |>
  #   ggplot() +
  #   geom_raster(aes(x = x , y = y, fill = value)) +
  #   scale_fill_viridis_c(na.value = "transparent", direction = -1, limits = c(59, 21000), transform = "log10") +
  #   geom_sf(data=gem, mapping=aes(), fill = "transparent", linewidth=0.5) +
  #   geom_sf_text(data = gem, mapping=aes(label = statnaam)) +
  #   labs(fill="", title=sprintf(" bandwith = %im", i)) +
  #   theme_void()
  #
  # ggsave("example/figures/fixed_log_smooth_%i.png" |> sprintf(i), width = 7, height = 5)
  s <- sdcSpatial::sensitivity_score(r3)
  l2 <- append(l2, list(data.frame(res = i, sensitive = s)))
}

d2 <- rbindlist(l2)
fwrite(d2, "example/figures/sensitive_res.csv")

d2 |>
  ggplot(aes(x = res, y = sensitive)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(labels=function(x){paste0(x,"m")}) +
  labs(x = "resolution", y = "", title="% disclosed cells")

ggsave("example/figures/sensitive_res.png", width = 7, height = 5)
