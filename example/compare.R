devtools::load_all()

compare_matrix <- function(r1, r2, use_na=FALSE){
  sqrt(mean((r1 - r2)^2, na.rm=TRUE))
}

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
  r = 200
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

resolutions <- (1:10) * 200
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

prot_wav <- function(r_dw, J = 4, plot = FALSE){
  m_s <- r_dw$value$count
  m_s[is_sensitive(r_dw)] <- 0
  m_s <- extract_matrix(m_s) |> make_dyadic()

  m <- r_dw$value$count |> extract_matrix() |> make_dyadic()
  idx <- m == 0
  #dim(m) |> min() |> log2()
  m1 <- waveslim::denoise.dwt.2d(m, wf = "la8", J = 4, rule="hard",H = .5)
  is.na(m) <- idx
  W <- sum(m, na.rm=TRUE)

  m1[m1 < 0] <- 0
  m1 <- m1 * (W/sum(m1))
  is.na(m1) <- m1 == 0
  m_s2 <- m1
  m_s2[m_s2 < 10] <- 0

  #m_s2 <- m_s2 * (W/sum(m_s2, na.rm=TRUE))

  if (plot){
    plot_image(m1)
    plot_image(m, main="original")

    png("example/img/dw_wav_smooth.png", width = 800, height = 600)
    plot_image(m_s2, main="wavelet smoothed")
    dev.off()
    plot_image(m_s)
  }

  compare_matrix(m, m1)
  compare_matrix(m, m_s)
  compare_matrix(m, m_s2)
}

#compare_rast(r$value$mean, r_smooth$value$mean, use_na=TRUE)

data("dwellings")
r_dw <- sdcSpatial::sdc_raster(
  dwellings[,1:2],
  variable = dwellings$unemployed,
  r = 200
)

png("example/img/dw_org.png", width = 800, height = 600)
plot_image(r_dw$value$count |> extract_matrix() |> make_dyadic(), main = "original")
dev.off()

r_no <- r_dw$value$count
r_no[is_sensitive(r_dw)] <- 0
compare_rast(r_dw$value$count, r_no)
png("example/img/dw_smooth.png", width = 800, height = 600)
plot_image(r_no |> extract_matrix() |> make_dyadic(), main = "no sensitive")
dev.off()

r_dw_sm <- protect_smooth(r_dw) |> remove_sensitive()
png("example/img/dw_smooth.png", width = 800, height = 600)
plot_image(r_dw_sm$value$count |> extract_matrix() |> make_dyadic(), main = "kde smoothed")
dev.off()

r_dw_quad <- protect_quadtree(r_dw) |> remove_sensitive()
png("example/img/dw_quadtree.png", width = 800, height = 600)
plot_image(r_dw_quad$value$count |> extract_matrix() |> make_dyadic(), main = "quadtree")
dev.off()

compare_rast(r_dw$value$count, r_dw_quad$value$count)
compare_rast(r_dw$value$count, r_dw_sm$value$count)
compare_rast()
