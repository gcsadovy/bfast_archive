#new coding layout for processing

dir1 <- "/media/chesterton/opdrive_2/REFLECTANCE/119062_hdf"
dir2 <- "/media/chesterton/opdrive_2/REFLECTANCE/119062_processing"
dir3 <- "/media/chesterton/opdrive_2/REFLECTANCE/119062_test"

f1 <- list.files(dir1, pattern=glob2rx("*.hdf"), recursive=F, full.names=T)
f2 <- list.files(dir2, pattern=glob2rx("*.gri"), recursive=F, full.names=T)
f2a <- list.files(dir2, pattern=glob2rx("*.gri"), recursive=F, full.names=F)

processLandsatBatch(x=dir1, pattern=glob2rx("*.hdf"), outdir=dir2, srdir=dir2, delete=F, vi="ndvi", mask="fmask", keep=0, overwrite=T, untar=F)

f3 <- list()
f4 <- list()

for (i in 1:length(f2)){
  x <- raster(f2[i])
  f3[i] <- x
}

plot(f3[[21]])
e <- saveExtent()
#extent(c(727774, 763434, -279659, -255012))

for (i in 1:length(f3)){
  y <- crop(f3[[i]], e, snap="in", dataType=NULL)
  z <- areaSieve(y, thresh=5000, keepZeroes=T, directions=8)
  f4[i] <- z
}

brick1 <- brick(f4)
obs <- countObs(brick1, navalues = c(NA), sensor="all", as.perc = F)
names <- getSceneinfo(f1)

writeRaster(brick1, filename = "brick1.tif", format = "GTiff", bylayer=F)

