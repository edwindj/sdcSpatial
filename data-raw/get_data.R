# retrieve adress list

if (!file.exists("data-raw/bagadres.csv")){
  if (!file.exists("data-raw/adressen.zip")){
    download.file( "https://data.nlextract.nl/bag/csv/bag-adressen-laatst.csv.zip"
                 , destfile = "data-raw/adressen.zip"
                 )
  }
  unzip("data-raw/adressen.zip", exdir = "data-raw")
}

d <- data.table::fread(
    "data-raw/bagadres-full.csv"
  , nrows = 1e4
  , select = c("verblijfsobjectgebruiksdoel", "x", "y")
)

e <- d[,.(doel = strsplit(verblijfsobjectgebruiksdoel,", ")
             , row = seq_len(.N))]
unnest(e)
library(tidyverse)
View(d)
