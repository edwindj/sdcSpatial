test <- expand.grid(
  x = c(0.20, 0.45, 0.70, 0.95), y = c(0.20, 0.45, 0.70, 0.95))

test$value <- c(1,1,2,2,
                1,1,2,2,
                3,3,4,4,
                3,3,4,4) + 0.2 * rep(c(1,-1), each = 4) * (-1 + 2*(seq_len(16) %% 2))

t_rast <- sdc_raster(test[,1:2], variable = test$value, r = 0.25, min_count = 2)
#plot(t_rast)

qt <- protect_quadtree(t_rast)

  expect_equal(
    qt$value$sum[],
    c(3, 3, 4, 4,
      3, 3, 4, 4,
      1, 1, 2, 2,
      1, 1, 2, 2)
   )

#plot(qt)

t_rast <- sdc_raster(test[,1:2], variable = test$value, r = 0.25, min_count = 5)
#plot(t_rast)

qt <- protect_quadtree(t_rast)
#plot(qt)

expect_equal(qt$value$sum[],rep(2.5, 16))

t2 <-
  head(rbind(
  test, test
),
-1)

t_rast <- sdc_raster(t2[,1:2],variable = t2$value, r = 0.25, min_count = 2)


s_exp <- logical(16)
s_exp[4] <- TRUE

s <- is_sensitive(t_rast)[]
expect_equal(s, s_exp)

#plot(t_rast)

qt <- protect_quadtree(t_rast)

qt
qt$value$sum[]
#plot(qt)
