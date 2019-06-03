bb <- c( 68500
       , 440000
       , 82500
       , 449000
       )

westland <-
  bag %>%
  filter( x >= bb[1], x <= bb[3]
        , y <= bb[2], y <= bb[4]
        , verblijfsobjectgebruiksdoel != "woonfunctie"
        )


westland %>%
  filter(verblijfsobjectgebruiksdoel != "woonfunctie") %>%
  data.table::fwrite("data/westland_bedrijven.csv")
