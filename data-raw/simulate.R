# create a simulation data set from a log normal distribution

data(am)
N <- nrow(am)

income <- rlnorm(N, meanlog = log(2000), sdlog = 0.4)

nn <- FNN::get.knn(am[,c("x","y")], k =3)

apply(income[t(nn$nn.index)] * prop.table(1/nn$nn.dist, 1), 1, sum)
