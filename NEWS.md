# version 0.5.2

* Added a `protect_neighborhood` function
* Fixed a bug in `protect_smooth`, it now can return a higher resolution version
`keep_resolution=FALSE`.
* internal improvements with $scale.
* added `mask_grid`, `mask_random`, `mask_weighted_random` and `mask_voronoi` functions, for perturbating points before rasterization.


# sdcSpatial 0.2.0.9000

* Added a `NEWS.md` file to track changes to the package.
* Added `is_sensitive_at` function to calculate sensitivity for original locations.
* Added `protect_coarsen` function for aggregating the raster.
* Added `protect_neighborhood` function for alternative protection method
* Fixed a bug in `protect_smooth`: gaussian smooth was accidentally a uniform smooth.

