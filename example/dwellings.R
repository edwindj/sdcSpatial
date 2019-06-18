b <- block_estimate(dwellings, "unemployed", r=500)

unsafe <- is_unsafe(b, max_risk = .9, min_count = 10, type="discrete")
plot(unsafe)
