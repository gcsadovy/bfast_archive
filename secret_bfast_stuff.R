

#-----------------------------------

# BFM Training

# Ben DeVries

#-----------------------------------



library(raster)

library(rgdal)

library(bfast)

library(workflowBen)





#----------------------------------

# Tile the data

#----------------------------------



setwd('directory/with/ndvi/masked/etctect')



fl <- list.files()



r <- raster(fl[6])

plot(r)



# genGridUTM() generates a grid from which you can tile your data

plot(genGridUTM(1000, extent(r), res(r), polygon=TRUE, prj=projection(r))$poly,
     
     add=TRUE)



# subsetUTM() uses genGridUTM() to subset your data

dir.create('test')

subsetUTM(r, tilesize=1000, filename='test/test', fileext='tif', format="GTiff")







#-------------------------------------

# stack the data

#-------------------------------------









#--------------------------------------

# run BFM on one monitoring period

#--------------------------------------



rm(list=ls())



data(chomecha)



# note that names(timeseriesBrick) need to correspond to LS sceneID's

## OR: you have to supply that yourself as a parameter

names(chomecha)

get.sceneinfo(names(chomecha))



plot(chomecha)

plot(chomecha, 6)



# look at a single pixel

library(ggplot2)

bfm <- bfm.pixel(chomecha, monperiod=c(2009, 1), interactive=TRUE, plot=TRUE)

bcell <- bfm$cell

bfm <- bfm.pixel(chomecha, monperiod=c(2009, 1), cell=bcell, sensor="ETM+", plot=TRUE)





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



# apply an area filter (requires GDAL in Linux!)

magn.thresh.MMU <- areaSieve(magn.thresh, verbose=TRUE, progress="text")

plot(magn.thresh.MMU)