Making privacy protected density maps: sdcSpatial

R allows for creating beautiful maps and many examples can be found.
Cartography is an indispensable tool in analyzing spatial data and communicating
regional patterns to your target audience. Current data sources often contain location data making maps a natural choice in visualizing them. 
While these detailed location data are fine for analytic purposes, they have 
the
risk that derived statistiscs disclose information of an individual person. For example if one plots the spatial distribution of income or getting social welfare, sparsely populated areas may be very revealing. Statistical procedures to control disclosure have been readily available (sdcTable, sdcMicro), but those focus on protecting tabulated or microdata, not on protecting spatial data as such.
sdcSpatial allows for creating maps that show spatial patterns but at the same time protect the privacy of the target population. The package also contains methods for assessing the associated risk for a given data set.
