# version 0.6.1

* Fixed `max_zoom` level specification issue #12 for `protect_quadtree`. 
max_zoom = 2 resulted earlier in max_zoom = 1. Thanks to Martin Moehler (@mamoeh).
* Added earlier stopping criterion for `protect_quadtree`. Thanks to Martin Moehler (@mamoeh).
* fixed a bug in `protect_quadtree` that caused an invalid sensitive count (scale), issue #14. Thanks to Martin Mohler (@mamoeh).
* fixed a bug in `protect_quadtree` that was caused sometimes by raster::cover in which the names of the layers were dropped. Thanks to Michael Buchner
* fixed documentation links (to `raster`)

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

