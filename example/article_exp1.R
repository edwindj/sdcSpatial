N <- 100000

n1 <- round(0.9*N)
n2 <- N - n1

set.seed(1234)
x1 <- rnorm(n1, mean = 0, sd = 1000)
y1 <- rnorm(n1, mean = 0, sd = 1000)
x2 <- rnorm(n2, mean = 1e4, sd = 5000)
y2 <- rnorm(n2, mean = 1e4, sd = 5000)

d <-
  rbind(
    data.frame(x = x1, y = y1, label = "n1"),
    data.frame(x = x2, y = y2, label = "n2")
  )

r <- sdc_raster(d[,1:2], variable = seq_len(nrow(d)), r = 500)

plot(r, value="count")

library(ggplot2)

ggplot(d, aes(x = x, y = y, color = label)) +
  geom_point(show.legend = FALSE) +
  coord_fixed() +
  theme_minimal() +
  labs(title = "Scatter plot of two distributions", x = "", y = "") +
  theme(legend.position = "top")


ggplot(d, aes(x = x, y = y, color = label)) +
  geom_point(show.legend = FALSE, alpha=0.4) +
  coord_fixed() +
  theme_minimal() +
  labs(title = "Locations n1 and n2", x = "", y = "")

ggsave("example/img/exp1scatter.png", width = 8, height = 6)

ggplot(d, aes(x = x, y = y)) +
  geom_bin2d(binwidth=c(200,200)) +
  scale_fill_gradient(low = "white", high = "blue", transform="log10") +
  coord_fixed() +
  theme_minimal() +
  labs(title = "Density of n1 and n2", x = "", y = "", fill = "n")

ggsave("example/img/exp1density.png", width = 8, height = 6)

r <- sdc_raster(d[,1:2], variable = seq_len(nrow(d)), r = 500)
r
plot(r, value = "count")

r_count <- r$value$count
r_no <- r_count
r_no[is_sensitive(r)] <- 0

r_quad <- (protect_quadtree(r) |> remove_sensitive())$value$count
r_quad[is_sensitive(r)] <- 0

r_smooth <- (protect_smooth(r) |> remove_sensitive())$value$count
r_smooth[is_sensitive(r)] <- 0

compare_rast(r_count, r_no)
compare_rast(r_count, r_quad)
compare_rast(r_count, r_smooth)

prot_wav(r)
