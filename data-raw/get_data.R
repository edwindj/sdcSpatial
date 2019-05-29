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
doelen <- unique(unlist(e$doel))

for (dl in doelen){
  d[, c(dl) := grepl(dl, verblijfsobjectgebruiksdoel)]
}

dir.create("data", recursive = TRUE, showWarnings = FALSE)

saveRDS(d, "data-raw/buildings.rds")

# use_data(offices)

# TODO add simulated data for several cities.
# Idea, draw a value from a distribution for all population members.
# select at random 10% focal points
# assign 90% of the other values to nearby locations: thereby introducing the spatial
# component


