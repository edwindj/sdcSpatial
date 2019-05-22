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
  #, nrows = 1e5
  , select = c("verblijfsobjectgebruiksdoel", "x", "y")
)

e <- d[, doel := strsplit(verblijfsobjectgebruiksdoel,", ")]
#e <- e[, .(doel = unlist(doel), x = x, y = y)]

doelen <- unique(unlist(e$doel))

for (doel in doelen){
  d[, c(doel) := grepl(doel, verblijfsobjectgebruiksdoel)]
}

dir.create("data", recursive = TRUE, showWarnings = FALSE)

offices <- d[kantoorfunctie==TRUE,.(x,y)]
residences <- d[woonfunctie==TRUE, .(x,y)]

use_data(offices)
use_data(residences)

# TODO add simulated data for several cities.
# Idea, draw a value from a distribution for all population members.
# select at random 10% focal points
# assign 90% of the other values to nearby locations: thereby introducing the spatial
# component


