consumption <- sdc_raster(dwellings[1:2], variable = dwellings$consumption, r = 500)

sensitivity_score(consumption)
# same as
print(consumption)

# change the rules! A higher norm generates more sensitive cells
sensitivity_score(consumption, min_count = 20)
