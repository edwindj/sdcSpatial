library(rpart)
library(raster)

ent <- as.data.frame(enterprises)

model <- rpart(sens_cont ~ x + y, ent, control = rpart.control(minbucket = 2))
model_rf <- randomForest::randomForest(sens_cont ~ x + y, data=ent, nodesize=2, ntree=25)
model_knn <- FNN::knn.reg(ent[,1:2], y = ent$sens_cont)

r <- create_raster(enterprises, res = 200)

xy <- xyFromCell(r, 1:ncell(r))

values <- predict(model, newdata=as.data.frame(xy))
value_rf <- predict(model_rf, newdata=as.data.frame(xy))
value_knn <- FNN::knn.reg(ent[,1:2], xy, y = ent$sens_cont, k=3)$pred

r_rpart <- setValues(r, values)
r_rf <- setValues(r, value_rf)
r_knn <- setValues(r, value_knn)

plot(r_rpart)
plot(r_rf)
plot(r_knn)

r_block <- raster::rasterize(enterprises, r, field="sens_cont", fun=mean)
r_count <- raster::rasterize(enterprises, r, field="sens_cont", fun="count")
plot(r_block)

#is.na(r_rf) <- is.na(r_block)
plot(r_rf, zlim=c(0,25000))
plot(r_block, zlim=c(0,25000))


r_rf
r_2 <- raster::mask(r_rf, nl)
r_knn2 <- raster::mask(r_knn, nl)

plot(r_2)
#plot(r_rf)
plot(r_knn2)
plot(r_block)

# masking stuff

mu <- exp(cellStats(log(r_block), mean))
mu <- cellStats(r_block, mean)
r_block[is.na(r_block)] <- mu

plot(r_block)
r_block_s <- smooth(r_block)
summary(r_block_s)
plot(r_block_s)
summary(getValues(r_block_s))
