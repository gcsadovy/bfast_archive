#--------------------------------------
# run BFM on one monitoring period
#--------------------------------------

setwd("/media/Elements/decuy002/04_LayerStack/MDD")

# save a copy of the sceneid character vector
# save(sceneid, file="layer_names.rda")
# load sceneid from file
load("layer_names.rda")


#rm(list=ls())
library(bfastSpatial)
path <- ("/media/Elements/decuy002/04_LayerStack/MDD")
# load in clipped rasterBrick
ndvibrick <- brick("/media/Elements/decuy002/04_LayerStack/MDD//NDVIst553_AOI.tif")
# rename the layers (this shouldn't be necessary!)
names(ndvibrick) <- sceneid

# note that names(timeseriesBrick) need to correspond to LS sceneID's
## OR: you have to supply that yourself as a parameter
s <- getSceneinfo(names(ndvibrick))

# look at a single pixel
plot(ndvibrick, 1)
bfm <- bfmPixel(ndvibrick, monperiod=c(2003, 1), interactive=TRUE)
# get the cell number from the previous run
cellno <- bfm$cell
#....re-run bfmPixel with cell=cellno using different parameters.....
bfm <- bfmPixel(ndvibrick, monperiod=c(2009, 1), cell=cellno, formula=response~harmon, order=1)
bfm <- bfmPixel(ndvibrick, monperiod=c(2003, 1), cell=cellno, formula=response~harmon)

# for post-processing, check out ?bfmSpatial

system.time(bfm05 <- bfmSpatial(ndvibrick, startperiod=c(2005, 1), cpus=8))
writeRaster(bfm05, filename="/media/Elements/decuy002/04_LayerStack/MDD/NDVIst553bfm.tif", format="GTiff", overwrite=TRUE)



# run bfm on the entire raster brick
# run bfm with a monitoring period starting at the beginning of 2005
# and a stable history period starting at the beginning of 1999
system.time(bfm05 <- run_bfm(chomecha, monperiod=c(2005, 1), history=c(1999, 1)))

# extract change raster
change <- bfm.change(bfm05)
plot(change)
magn <- bfm.magn(bfm05)
plot(magn)
magn.change <- bfm.magn(bfm05, change=change)
plot(magn.change)
magn.thresh <- bfm.magn(bfm05, change=change, thresh=-0.05)
plot(magn.thresh)