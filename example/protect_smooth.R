library(raster)
library(magrittr)

production <- block_estimate(enterprises, "production")
plot(production)


production %>%
  protect_smooth(bw = 400) %>%
  plot(zlim=c(0,2e4))

production %>%
  protect_smooth(bw = 400) %>%
  remove_unsafe(min_count=2) %>%
  plot(zlim=c(0,2e4))

production %>%
  is_unsafe(min_count=2) %>%
  hist()

production %>%
  protect_smooth(bw=400) %>%
  disclosure_risk(min_count=2) %>%
  hist()
