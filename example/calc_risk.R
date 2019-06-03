data("westland")
# create raster with 250 meter blocks
coordinates(westland) <- ~x + y

r_risk <- calc_risk(westland, res = 250)
