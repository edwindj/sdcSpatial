b <- calc_block_logical(dwellings, "unemployed", r=500)

unsafe <- is_unsafe(b, max_risk = .9, min_count = 10, type="discrete")
colortable(unsafe) <- logical()
plot(unsafe)
