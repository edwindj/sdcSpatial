#' ---
#' title: "Looking at disclosure risk"
#' output:
#'   pdf_document: default
#'   html_notebook: default
#' ---
#' 
#' First reading in the data, we use westland with slightly randomized locations of westland.
#' 
## ------------------------------------------------------------------------
library(sp)
library(raster)
library(magrittr)
library(ggplot2)
library(dplyr)

meters <- function(x){paste0(x, "m")}
source("kde_rel_freq.R")
source("plot_rel_freq.R")

#mun <- readRDS("./data/dh.rds")
#bb <- extent(mun)
bedrijven <- data.table::fread("bedrijven_westland.csv") %>% 
  filter(x,y)

coordinates(bedrijven) <- c("x", "y")

# plot(bedrijven)
# 
# library(tmap)
# png("bubble.png")
# tm_shape(bedrijven) +  tm_bubbles("Elek", col="red", border.lwd=0, border.col="red")
# dev.off()

bb <- bbox(bedrijven)
# strangely enough this is needed for raster
bb <- extent(bb[c(1,3,2,4)])
westland_overlay <- readRDS("lines.Rds")

r_plot <- function(x, zmin=0, zmax = 1, ...){
  plot(x = x
      , col = rev(viridis::viridis(256))
      , zlim = c(zmin,zmax)
      , axes = F
      , ...
      )
}

r_plot_heat <- function(x, ..., col = rev(viridis::magma(256)), cex.main=2){
  old_par <- par(mar = c(1,1,2,1))
  
  on.exit({
    par(old_par)
  })
  
  plot(x = x
       , col = col
       , axes = F
       , ...
       , legend = FALSE
       , cex.main = cex.main
  )
  #return(invisible())
  ext <- extent(x)
  ov <- crop(westland_overlay, ext)
  plot(ov, bg = "transparent", col="#4d4d4d4d", add=TRUE)
}

r_hist <- function(x, ...){
  hist(x, breaks=20, las=1, ...)
}

max2 <- function(x, na.rm=TRUE){
  if (length(x) > 1){
    x[order(x, decreasing = TRUE)][2]
  } else {
    0
  }
}


block_estimate <- function(res = 1000, region = bedrijven, variable = "Elek"){
  r <- raster(bb, res = res) # needed for rasterization
  # sum the values in each block
  r_sum <- rasterize(region, r, variable, fun = "sum")
  r_count <- rasterize(region, r, variable, fun="count")
  r_mean <- rasterize(region, r, variable, fun=mean)
  r_max <- rasterize(region, r, variable, fun = "max")
  r_max2 <- rasterize(region, r, variable, fun = max2)
  r_pp <- (r_sum/r_max) - 1
  r_pp2 <- (r_sum - r_max2)/(r_max) - 1
  b <- brick(list(sum = r_sum, count = r_count, mean = r_mean, max = r_max, pp = r_pp, max2 = r_max2, pp2 = r_pp2))
  #r2[is.na(r2)] <- 0
  b
}

#' 
# res <- 200
# b <- block_estimate(res)
# r_plot(b$pp < 0.05)
# r_plot(b$pp < 0.1)

#' # Kijken naar PC6

pc6  <- 
  bedrijven@data %>% 
  group_by(PC6) %>% 
  summarize( Elek_tot = sum(Elek, na.rm=TRUE)
             , n = n()
             , m = max(Elek, na.rm=TRUE)
             , m2 = max2(Elek)
             , external = Elek_tot/m - 1
             , internal = (Elek_tot-m2)/m - 1
  ) %>% 
  filter(Elek_tot > 0) %>% 
  glimpse()

pc6_safe <- 
  pc6 %>% 
  summarize( ext_unsafe = sum(external < 0.05)/n()
             , int_unsafe = sum(internal < 0.05, na.rm=T)/n()
             , ext_unsafe_mass = sum(n*(external < 0.05))/sum(n)
             , int_unsafe_mass = sum(n*(internal < 0.05), na.rm=T)/sum(n)
             , n_pc6 = n()
             , n_enterprises = sum(n)
  ) %>% 
  glimpse()

#' 
#' Let's look at certain resolutions:
#' 
#' ## 1km$^2$
#' 
## ------------------------------------------------------------------------
unsafe <- 
  lapply(c(0.05, 0.10, 0.15), function(p){
    sapply(100*(1:10), function(res){
      b <- block_estimate(res)
      c( p = p
       , res = res
       , unsafe = mean(values(b$pp) < p, na.rm=TRUE)
       )
    }) %>% 
      t() %>% 
      as.data.frame()
}) %>% 
  data.table::rbindlist()


library(ggplot2)
unsafe %>% 
  mutate(p = factor(p)) %>% 
  ggplot(aes(x = res, y = unsafe, col=p, linetype=p)) + 
  geom_line(size=1) + 
  scale_y_continuous(labels=scales::percent, limits=c(0,1)) +
  scale_colour_discrete(labels=function(x){scales::percent(as.numeric(x))}) +
  scale_linetype_discrete(labels=function(x){scales::percent(as.numeric(x))}) +
  scale_x_continuous(labels=function(x){paste0(x, "m")}) +
  labs(title= "% unsafe cells, external attacker"
      , x = "resolution", y = "", col = "p% criterium", linetype="p% criterium") +
  theme_bw() + theme(text=element_text(size=16))

ggsave('unsafe_grid_cells_external.pdf')

unsafe_internal <- 
  lapply(c(0.05, 0.10, 0.15), function(p){
    sapply(100*(1:10), function(res){
      b <- block_estimate(res)
      c( p = p
         , res = res
         , unsafe = mean(values(b$pp2) < p, na.rm=TRUE)
      )
    }) %>% 
      t() %>% 
      as.data.frame()
  }) %>% 
  data.table::rbindlist()

unsafe_internal %>% 
  mutate(p = factor(p)) %>% 
  ggplot(aes(x = res, y = unsafe, col=p, linetype=p)) + 
  geom_line(size=1) + 
  scale_y_continuous(labels=scales::percent, limits=c(0,1)) +
  scale_colour_discrete(labels=function(x){scales::percent(as.numeric(x))}) +
  scale_linetype_discrete(labels=function(x){scales::percent(as.numeric(x))}) +
  scale_x_continuous(labels=function(x){paste0(x, "m")}) +
  labs(title= "% unsafe cells, internal attacker"
       , x = "resolution", y = "", col = "p% criterium", linetype="p% criterium") + 
  theme_bw() + theme(text=element_text(size=16))

ggsave('unsafe_grid_cells_internal.pdf')

p = 0.05
unsafe_kde_external <- 
  lapply(100*(1:5), function(res){
    sapply(50*(1:30), function(width){
      b <- block_estimate(res)
      b_sum <- smooth(b$sum, width = width)
      b_max <- smooth(b$max, width = width)
      b_pp <- b_sum/b_max - 1
      c( p = p
       , res = res
       , width = width
       , unsafe = mean(values(b_pp) < p, na.rm=TRUE)
       )
    }) %>% 
      t() %>% 
      as.data.frame()
}) %>% 
  data.table::rbindlist()

unsafe_kde_external %>% 
  mutate(res = factor(res)) %>% 
  ggplot(aes(x = width, y = unsafe, col = res, shape=res)) + 
  geom_line(size=1) + 
  geom_point() + 
  scale_y_continuous(labels=scales::percent, limits=c(0,1)) +
  scale_colour_discrete(labels=meters) +
  scale_shape_discrete(labels=meters) +
  scale_x_continuous(labels=meters, limits=c(0, 1500)) +
  labs( title= "% unsafe cells, external attacker"
      , x = "kde bandwidth"
      , y = ""
      , col = "resolution", shape="resolution"
      ) + 
  geom_hline( aes(yintercept = ext_unsafe)
              , data = pc6_safe
              , linetype=2
              , size=1
  ) + 
  annotate('text', x = 1500, y = pc6_safe$ext_unsafe+0.04, label='PC6 / zip code') +
  theme_bw() + theme(text=element_text(size=16))

ggsave('unsafe_kde_external.pdf')

p = 0.05
unsafe_kde_internal <- 
  lapply(100*(1:5), function(res){
    sapply(50*(1:30), function(width){
      b <- block_estimate(res)
      b_sum <- smooth(b$sum, width = width)
      b_max <- smooth(b$max, width = width)
      b_max2 <- smooth(b$max2, width = width)
      b_pp <- (b_sum-b_max2)/b_max - 1
      c( p = p
         , res = res
         , width = width
         , unsafe = mean(values(b_pp) < p, na.rm=TRUE)
      )
    }) %>% 
      t() %>% 
      as.data.frame()
  }) %>% 
  data.table::rbindlist()

unsafe_kde_internal %>% 
  mutate(res = factor(res)) %>% 
  ggplot(aes(x = width, y = unsafe, col = res, shape=res)) + 
  geom_line(size=1) + 
  geom_point() +
  scale_y_continuous(labels=scales::percent, limits=c(0,1)) +
  scale_colour_discrete(labels=meters) +
  scale_shape_discrete(labels=meters) +
  scale_x_continuous(labels=meters, limits=c(0, 1500)) +
  labs( title= "% unsafe cells, internal attacker"
       , x = "kde bandwidth"
       , y = ""
       , col = "resolution"
       , shape="resolution"
  ) + 
  geom_hline( aes(yintercept = int_unsafe)
              , data = pc6_safe
              , size=1
              , linetype=2
  ) + 
  annotate('text', x = 1500, y = pc6_safe$int_unsafe+0.04, label='PC6 / zip code') +
  theme_bw() + theme(text=element_text(size=16))

ggsave('unsafe_kde_internal.pdf')

# r_hist(b$pp)
# r_plot(b$pp)
# 
# r_hist(log10(b$mean))
# r_plot_heat(log10(b$mean))
# 
# r_mean <- b$mean
# r_mean[b$pp > 0.6] <- NA
# r_plot_heat(r_mean)
# 
# b <- block_estimate(2e3)
# a <- r_hist(b$pp)
# r_plot(log10(b[["mean"]]), zmin=0, zmax=log10(cellStats(b[["mean"]], "max")))
# 
# 
# b <- block_estimate(5e3)
# r_hist(b[["pp"]])
# r_plot(log10(b[["mean"]]), zmin=0, zmax=log10(cellStats(b[["mean"]], "max")))
# 
# b <- block_estimate(5e2)
# 
# r_hist(b[["pp"]])
# r_plot(log10(b[["mean"]]), zmin=0, zmax=log10(cellStats(b[["mean"]], "max")))

for (res in c(200, 300, 500, 1e3)){
  b <- block_estimate(res)$mean
  png(paste0("png/block_", res, ".png"))
  r_plot_heat(log10(b), main=paste0("Resolution ",res,'m'), zlim=c(3,9))
  dev.off()
}

for (res in c(100, 200, 300, 500, 1e3)){
  b <- block_estimate(res)$pp
  png(paste0("png/blockp_", res, ".png"))
  r_plot(b, main=paste0("block, res=",res), zlim=c(3,9))
  dev.off()
}

#' 
#' 
#' 
#' # KDE
#' 
#' Smoothing in it self does reduce the risk: levels of the attribute risk are lower, when the band width is increased.
#' However it can be argued that without legend, the relative risk may be disclosing.
#' 
#' ## No disclosure control, only smoothing 
## ------------------------------------------------------------------------
# make a kde of bedrijven

# r_plot_heat(log10(b$mean))
# 
# b <- block_estimate(res = 1e2)

# block_estimate(res=1e2, variable="Elek") %>% 
#   .$mean %>% 
#   smooth(width=2e2) %>% 
#   log10() %>% 
#   r_plot_heat(zlim=c(2,9), col = rev(viridis::magma(8)))
# 
# 
# block_estimate(res=1e2) %>% 
#   .$sum %>% 
#   smooth(width=2e2) %>% 
#   log10() %>% 
#   r_plot_heat(zlim=c(3,9))


kde_direct <- function(res = 1e3, width = 1e3, variable = "Elek"){
  b <- block_estimate(res, variable = variable)
  be <- smooth(b$sum, width = width)
  bc <- smooth(b$count, width = width)
  estimate <- be/bc
  estimate
}

kde_mean <- function(res = 1e3, width = 1e3, variable = "Elek"){
  b <- block_estimate(res, variable = variable)
  estimate <- smooth(b$mean, width = width)
  estimate
}

kde_unsafe <- function(res = 1e3, width = 1e3, variable = "Elek", p = 0.05){
  b <- block_estimate(res)
  b_sum <- smooth(b$sum, width = width)
  b_max <- smooth(b$max, width = width)
  b_pp <- b_sum/b_max - 1
  b_pp
}

res <- 2e2
width <- 5e2
zlim <- c(3,9)
for (res in c(2e2)){
    d <- block_estimate(res = res)$mean
    png(paste0("png/", "direct_", res,"x", ".png"))
    r_plot_heat(log10(d), main=paste0("resolution: ", res,"m"), zlim=zlim)
    dev.off()
  for (width in res * c(0.5, 1, 2, 3)) {
    d <- kde_direct(res = res, width = width)
    png(paste0("png/", "direct_", res,"x", width, ".png"))
    r_plot_heat(log10(d), main=paste0("res = ", res,", bandwidth = ", width, "m"), zlim=zlim)
    dev.off()

    u <- kde_unsafe(res = res, width = width)
    png(paste0("png/", "unsafe_", res,"x", width, ".png"))
    r_plot(u, main=paste0("res = ", res,", bandwidth = ", width, "m"))
    dev.off()
    
    d <- kde_mean(res = res, width = width)
    png(paste0("png/", "mean_", res,"x", width, ".png"))
    r_plot_heat(log10(d), main=paste0("resolution: ", res,"m, bandwidth = ", width, "m"), zlim=zlim)
    dev.off()
  }
}

# use clipped pc6 format from pc6.R

w_pc6 <- readRDS("westland_pc6.Rds")
r_pc6 <- readRDS("r_pc6.Rds")

library(raster)

res <- 2e2
width <- 5e2
for (res in c(2e2)){
  for (width in res * c(0.5, 1, 2, 3)) {f
    d <- kde_direct(res = res, width = width)
    dat <- data.frame( Elek_kde =  raster::extract(d, w_pc6, fun=sum, na.rm=TRUE)
                     , w_pc6$PC6
                     )
    pc6 %>% 
      inner_join(dat) %>% 
      View()
    # m <- kde_mean(res = res, width = width)
    # m_pc6 <- raster::extract(d, pc6, fun=mean, na.rm=TRUE)
  }
}


bedrijven$PC6


# width = 1e2
# r_plot_heat(be)
# r_plot_heat(log10(be / bc), zlim = c(2,9), col = rev(viridis::magma(8)))
# unsafe_kde_external %>% 
#   filter(p == 0.05) %>% 
#   ggplot(aes(x=width, y = unsafe, col=factor(res))) +
#   geom_line() + 
#   geom_hline( aes(yintercept = ext_unsafe)
#             , data = pc6_safe
#             , linetype=2
#             ) + 
#   annotate('text', x = 1500, y = pc6_safe$ext_unsafe-0.03, label='PC6 / zip code')
# 
# count(pc6, ext_unsafe = external < 0.05)
# count(pc6, ext_unsafe = internal < 0.05)

