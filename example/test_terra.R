
sdc_raster(enterprises, variable = "production",k = 5, r = 400)

r <- sdc_raster(dwellings, variable = "consumption",k = 10, r = 500)
plot(r)
plot(r, "mean")
plot(r, "count")
plot(r, "sum")
disclosure_risk(r)

is_sensitive_at(r, matrix( c(150000,460000
                            ,150000,460500
                            )
                         , ncol = 2
                         , byrow = TRUE
                         )
                )
r$value

r |>
  protect_smooth()
