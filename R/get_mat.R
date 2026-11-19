get_mat <- function(r){
  A <- raster::as.matrix(r)
  rws <- seq_len(nrow(A)) |> rev()
  A <- A[rws,] |> t()
  A
}

to_mat <- function(A){
  rws <- seq_len(ncols(A)) |> rev()
  t(A)[rws,]
}

plot_mat <- function(A){
  image(A, col = hcl.colors(10, rev = TRUE), asp=1)
}

plot_riskm <- function(A, to_zero=T, main = ""){
  # oldpar <- par(oma=c(1,1,1,1), mar=c(0,0,0,0))
  # on.exit(par(oldpar))

  if (to_zero){
    A[A < 0] <- 0
  }
  image(
    A,
    col = hcl.colors(10, rev = TRUE),
    asp=1,
    zlim=c(0,1),
    main=main,
    axes=F,
    xlab="",
    ylab="",
    oma=c(1,1,1,1),
    mar=c(0,0,0,0)
  )
  A
}



risk1 <- function(r, set_na_mean = TRUE){
  r1 <- 1/r$value$count
  r1 <- get_mat(r1)
  if (set_na_mean){
    r1[is.na(r1)] <- mean(r1, na.rm = TRUE)
  }
  r1
}

risk2 <- function(r, set_na = c("NA","mean","zero")){
  r2 <- r$value$max/r$value$sum
  r2 <- get_mat(r2)
  set_na <- match.arg(set_na)

  switch(
    set_na,
    "mean" = r2[is.na(r2)] <- mean(r2, na.rm = TRUE),
    "zero" = r2[is.na(r2)] <- 0
  )
  r2
}


group_layers <- function(mra){
  N <- length(mra)
  m <- mra[[N]]
  lrs <- mra[-N]

  nms <- names(lrs) |> sub("[HL][HL]", "", x = _)
  l <- split(lrs, nms) |>
    lapply(function(l){
      r <- l[[1]]
      for (l2 in l[-1]){
        r <- r + l2
      }
      r
    })
  c(list("0"=m), rev(l))
}

cum_group_layers <- function(mra){
  l <- group_layers(mra)
  res <- l
  for (i in (seq_along(l)[-1])){
    res[[i]] <- res[[i-1]] + l[[i]]
  }
  res
}

cs <- function(mra){
  l <- list(LL1=mra$LL1)

  res <- l[[1]]
  l2 <- mra[-length(mra)]

  l3 <- lapply(l2, function(l){
    res <<- res + l
    res
  })

  c(l,l3)
}

