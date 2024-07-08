library(sdcSpatial)

library(spatstat)
library(maptools)

# beginner()
# vignette('getstart')
data("enterprises")

p <- enterprises |> as.ppp()

rp <- Kest(p)

plot(p)


rounded_range <- function(r, eps = 100){
  rs <- r/eps
  eps * c(floor(rs[1]), ceiling(rs[2]))
}

rounded_window <- function(x, eps = 100){
  w <- Window(x)
  w$xrange <- rounded_range(w$xrange)
  w$yrange <- rounded_range(w$yrange)
  w
}

rounded_dummy <- function(p, eps = 100){
  b <- rounded_window(p, eps = eps)
  nx <- (b$xrange[2] - b$xrange[1])/eps
  ny <- (b$yrange[2] - b$yrange[1])/eps
  gridcenters(b, nx=nx, ny=ny)
}


density(p)

eps <- 100
sigma <- 8*eps

Window(p) <- rounded_window(p, eps = eps)



d <- density( p
            , sigma = sigma
            , eps   = eps
            )
plot(d)

normalize <- function(d, n = 1){
  d$v <- n * d$v / sum(d$v)
  d
}

d_n  <- normalize(d, n = p$n)
# is.na(d_n$v) <- d_n$v < 5
plot(d_n)

s <- Smooth(p, sigma = sigma, eps = eps, fractional = TRUE)
plot(s)

plot(s*d_n)
plot(s)
plot()
# j <- Jest(p)
# plot(j)
#

plot(pixellate(humberside))
plot(pixellate(humberside, fractional = T))

#
# f <- Fest(p)
# plot(f)
#
# g <- Gest(p)
# plot(g)
# summary(g$r)
# p
# ?Gest


data("dwellings")

W <- owin( xrange = range(dwellings$x)
         , yrange = range(dwellings$y)
         )

dw <- as.ppp(dwellings, W = W)

Window(dw) <- rounded_window(dw, eps = 100)

eps <- 100
sigma <- 200
d_dw <- density(dw, eps = eps, sigma = sigma)
d_dw$v

plot(d_dw)

library(KernSmooth)
d <- bkde2D( dwellings[,1:2]
           , bandwidth = 200
           , gridsize = c(124, 121)
           , range.x = list( range(dwellings$x)
                           , range(dwellings$y)
                           )
           )

image(x = d$x1, y = d$x2, z = d$fhat, col = hcl.colors(10, "plasma"), asp=1, axes=F)
plot(d_dw)
