#' kde estimate of relative frequency (direct quotient)
#' 
#' kde estimate of relative frequency (direct quotient)
#' @param spfd SpatialPointsDataFrame with "Nc"
#' @param width Spatial kernel density estimation band width
#' @param Nc name of column with classified property
#' @param resolution of resulting raster
#' @param max_freq maximum allowed frequency. Higher frequency will be cut off.
#' @param k0 minimum number of elements 
kde_rel_freq <- function(spdf, width=100, N = "N", Nc="c", max_freq = 0.9, resolution=50, k0=10){
  bb <- bbox(spdf)
  bb <- 
    cbind( floor(bb[,1]/resolution)
         , ceiling(bb[,2]/resolution)
         ) * resolution
  ext <- extent(bb)
  
  r_org <- raster(ext, resolution=resolution)
  
  r_N  <- rasterize(spdf, r_org, field = N, fun=sum)
  r_Nc  <- rasterize(spdf, r_org, field = Nc, fun=sum)
  
  r_rel <- r_Nc / r_N
  
  # we assume the rel_freq is a spatial probability and smooth it
  # smoothing r_Nc and r_N seperately and dividing does give a different result (see below!)
  # relative estimates (not numerically stable?)
  smooth <- max_freq >= 1
  
  if (smooth){
    r_rel <- smooth(r_rel, width = width)
  }
    
  # truncate group-sensitive locations
  r_rel[r_rel > max_freq] <- max_freq
  
  # remove rare-sensitive locations with a f_hat_N
  r_N_sm <- r_N
  if (smooth){
    r_N_sm <- smooth(r_N, width = width)
  }
  r_rel[r_N_sm < k0] <- NA

  r_rel
}


kde_mean <- function(spdf, width=100, resolution=50, p = 0.05){
  bb <- bbox(spdf)
  bb <- 
    cbind( floor(bb[,1]/resolution)
           , ceiling(bb[,2]/resolution)
    ) * resolution
  ext <- extent(bb)
  
  r_org <- raster(ext, resolution=resolution)
  
  r_N  <- rasterize(spdf, r_org, field = N, fun=sum)
  r_Nc  <- rasterize(spdf, r_org, field = Nc, fun=sum)
  
  r_rel <- r_Nc / r_N
  
  # we assume the rel_freq is a spatial probability and smooth it
  # smoothing r_Nc and r_N seperately and dividing does give a different result (see below!)
  # relative estimates (not numerically stable?)
  smooth <- max_freq >= 1
  
  if (smooth){
    r_rel <- smooth(r_rel, width = width)
  }
  
  # truncate group-sensitive locations
  r_rel[r_rel > max_freq] <- max_freq
  
  # remove rare-sensitive locations with a f_hat_N
  r_N_sm <- r_N
  if (smooth){
    r_N_sm <- smooth(r_N, width = width)
  }
  r_rel[r_N_sm < k0] <- NA
  
  r_rel
}


#' Utility function for smoothing
#' 
#' Approximates a kde by applying a gaussian blur and rescaling.
smooth <- function(r,  width=100){
  r[!is.finite(r)] <- 0 # otherwise focal is empty...
  m <- max(values(r), na.rm=T)
  r <- focal( r
            , focalWeight(r, width,"Gaus")
            )
  # rescale so estimate has same maximum. (may try something else?)
  #m <- m/max(values(r), na.rm=T)
  m <- 1
  m * r
}


# real kde!
kde_raster <- function(x, bandwidth, r){
  ext <- extent(r)
  kde <- KernSmooth::bkde2D( x
                           , bandwidth = bandwidth
                           , gridsize  = c(ncol(r), nrow(r)) # strangely enough the x and y are mixed up
                           , range.x   = list(c(ext[1], ext[2]), c(ext[3], ext[4]))
                           )
  
  # x and y are treated different in bkde2D then in raster, so next line tries to fix that.
  r_kde <- setValues(r, t(kde$fhat)[nrow(r):1,])
  r_N <- rasterize(x, r, fun="count")
  rescale(r_kde, r_N)
}

#' rescales raster r to same max value as r_org
rescale <- function(r, r_org){
  m <- max(values(r_org), na.rm=TRUE)
  m <- m/max(values(r), na.rm=TRUE)
  m*r
}


#' bkde2D estimate of relative frequency (indirect quotient)
#' 
#' Make kde plot of a spatial points data.frame
#' @param spfd SpatialPointsDataFrame with "Nc"
#' @param width Spatial kernel density estimation band width
#' @param Nc name of column with classified property
#' @param resolution of resulting raster
#' @param max_freq maximum allowed frequency. Higher frequency will be cut off.
#' @param k0 minimum number of elements 
kde2_rel_freq <- function(spdf, width=100, Nc="c", max_freq = 0.9, resolution=50, k0=10){
  bb <- bbox(spdf)
  bb <- 
   cbind( floor(bb[,1]/resolution)
          , ceiling(bb[,2]/resolution)
   ) * resolution
  ext <- extent(bb)
  
  r_org <- raster(ext, resolution=resolution)
  
  r_N <- kde_raster(coordinates(spdf), 100, r_org)
  r_N[r_N < k0] <- NA
  
  v_c <- spdf@data[[Nc]]
  r_c <- kde_raster(coordinates(spdf[v_c,]), 100, r_org)
  
  r_rel <- r_c/r_N
  r_rel[r_rel > max_freq] <- max_freq
  
  r_rel
}


#' Kde Estimate of relative frequency (indirect quotient)
#' 
#' Make kde plot of a spatial points data.frame
#' @param spfd SpatialPointsDataFrame with "Nc"
#' @param width Spatial kernel density estimation band width
#' @param Nc name of column with classified property
#' @param resolution of resulting raster
#' @param max_freq maximum allowed frequency. Higher frequency will be cut off.
#' @param k0 minimum number of elements 
kde3_rel_freq <- function(spdf, width=100, Nc="c", max_freq = 0.9, resolution=50, k0=10, use_smooth = TRUE){
  
  bb <- bbox(spdf)
  bb <- 
    cbind( floor(bb[,1]/resolution)
           , ceiling(bb[,2]/resolution)
    ) * resolution
  ext <- extent(bb)
  
  r_org <- raster(ext, resolution=resolution)
  
  r_N <- rasterize(spdf, r_org, field="N", fun="sum")
  r_N_sm <- r_N
  r_N_sm <- if (use_smooth) smooth(r_N, width=width) else r_N
  r_N_sm[r_N_sm < k0] <- NA
  
  r_c <- rasterize(spdf, r_org, field=Nc, fun="sum")
  r_c_sm <- if (use_smooth) smooth(r_c, width=width) else r_c
  
  r_rel <- r_c_sm/r_N_sm
  
  r_rel[r_rel > max_freq] <- max_freq
  r_rel
}


#' Kde Estimate of relative frequency (indirect quotient)
#' 
#' Make kde plot of a spatial points data.frame
#' @param spfd SpatialPointsDataFrame with "Nc"
#' @param width Spatial kernel density estimation band width
#' @param Nc name of column with classified property
#' @param resolution of resulting raster
#' @param max_freq maximum allowed frequency. Higher frequency will be cut off.
#' @param k0 minimum number of elements 
kde4_rel_freq <- function(spdf, width=100, Nc="c", max_freq = 0.9, resolution=100, k0=10, use_smooth = TRUE){
  
  bb <- bbox(spdf)
  bb <- 
    cbind( floor(bb[,1]/resolution)
           , ceiling(bb[,2]/resolution)
    ) * resolution
  ext <- extent(bb)
  
  r_org <- raster(ext, resolution=50)
  
  r_N <- rasterize(spdf, r_org, field="N", fun="sum")
  r_N_sm <- r_N
  r_N_sm <- if (use_smooth) smooth(r_N, width=width) else r_N
  r_N_sm[r_N_sm < k0] <- NA
  
  
  r_c <- rasterize(spdf, r_org, field=Nc, fun="sum")
  r_c_sm <- if (use_smooth) smooth(r_c, width=width) else r_c
  
  fact <- resolution/50
  r_agg <-   if (fact > 1) aggregate(r_c_sm, fact, fun=sum) else r_c_sm
  r_agg[is.na(r_agg)] <- 0
  r_rel <- r_agg / (if (fact > 1) aggregate(r_N_sm, fact, fun=sum) else r_N_sm)
  
  r_rel[r_rel > max_freq] <- max_freq
  r_rel
}