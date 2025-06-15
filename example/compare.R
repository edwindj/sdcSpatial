devtools::load_all()

compare_rast <- function(r1, r2, use_na=FALSE){
  v1 <- r1[]
  v2 <- r2[]

  if (use_na){
    v1[is.na(v1)] <- 0
    v2[is.na(v2)] <- 0
  }

  sqrt(mean((v1[] - v2[])^2, na.rm=TRUE))
}

compare_rast_diff <- function(r1, r2, use_na=FALSE){
  v1 <- r1[]
  v2 <- r2[]

  if (use_na){
    v1[is.na(v1)] <- 0
    v2[is.na(v2)] <- 0
  }

  v1[] - v2[]
}




library(sdcSpatial)
data(enterprises)

r <- sdcSpatial::sdc_raster(
  enterprises,
  variable = "production",
  r = 100
)

# plot(r)
# plot_image(extract_matrix(r$value$mean))

# r$value$mean
#
r_no <- r
is_sens <- is_sensitive(r_no)[]
r_no$value$mean[is_sens] <- 0
#
# r_quad <- r |> protect_quadtree() |> remove_sensitive()
# r_smooth  <- r |> protect_smooth(bw=400) |> remove_sensitive()
# r_wav <- r |> protect_wavelet()

# r_quad |> plot()
# r_smooth |> plot()

# compare_rast(r$value$mean, r$value$mean)
# compare_rast(r$value$mean, r_no$value$mean)
# compare_rast(r$value$mean, r_quad$value$mean)

resolutions <- (1:10) * 100
a <- resolutions |> lapply(function(res){
  r_smooth <- r |> protect_smooth(bw=res) |> remove_sensitive()
  fn <- sprintf("example/img/smooth_bw%dm.png", res)
  message("Writing ", sQuote(fn))
  png(filename = fn)
  plot_image(extract_matrix(r_smooth$value$mean), main = sprintf("bw=%d", res))
  dev.off()
  rmse <- compare_rast(r$value$mean, r_smooth$value$mean)
  rmse_na <- compare_rast(r$value$mean, r_smooth$value$mean, use_na=TRUE)
  cat("res:", res, "diff:", rmse, "\n")
  list(rmse = rmse, rmse_na = rmse_na, res = res)
})

rmse <-  compare_rast(r$value$mean, r_no$value$mean)
rmse_na <-  compare_rast(r$value$mean, r_no$value$mean, use_na=TRUE)

a <- append(list(
  list(rmse = rmse, rmse_na = rmse_na, res = 0)
), a)

saveRDS(a, file = "example/smooth_diff.rds")
d <- data.table::rbindlist(a)
d
data.table::fwrite(d, "example/smooth_diff.csv")

d_art <-
  data.frame( resolutions = 0, diff = 0) |>
  rbind(d[1,])

library(ggplot2)
ggplot(d, aes(x = resolutions, y = diff)) +
  geom_line() +
  geom_line(data=d_art, linetype="dashed") +
  labs(title = "Difference in smoothing", x = "Smoothing resolution", y = "Difference") +
  theme_minimal()

ggsave("example/img/smooth_diff.png", width = 8, height = 6)
#compare_rast(r$value$mean, r_smooth$value$mean, use_na=TRUE)

