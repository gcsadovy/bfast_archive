#read in a list of .hdf files
#NOTE: these work hdf files do not have the dates associated with their:
#filenames, only the tile id, the year, ad the sequential take #
#Need to make a script that will pull the aquisition date from the associated GCP files to produce the date

library(gdalUtils)


pth <- getwd()
f1 <- list.files(pth, pattern=glob2rx("*.hdf"), recursive = F, full.name = T)
count = 0

for (i in 1:length(f1)){
  count = count+1
  flnam <- substr(f1[i],0, 76)
  flnam_sat <- substr(f1[i],56, 58)
  flnam_tile <- substr(f1[i], 59, 64)
  flnam_year <- substr(f1[i], 65, 68)
  flnam_count <- substr(f1[i], 69, 71)
  flnam_spiffy <- paste(flnam_sat, "Tile:", flnam_tile, "Year:", flnam_year, "Count:", flnam_count, sep=" ")
  
  outfile1 <- paste(flnam, "_B1_Masked", sep="")
  outfile3 <- paste(flnam, "_B3_Masked", sep="")
  outfile4 <- paste(flnam, "_B4_Masked", sep="")
  
  sd <- get_subdatasets(f1[i])
  Band1 <- raster(sd[1])
  Band3 <- raster(sd[3])
  Band4 <- raster(sd[4])
  f_mask <- raster(sd[17])
  
  Mask1 <- mask(Band1, f_mask, outfile1, maskvalue=0, overwrite=T)
  Mask3 <- mask(Band3, f_mask, outfile3, maskvalue=0, overwrite=T) 
  Mask4 <- mask(Band4, f_mask, outfile4, maskvalue=0, overwrite=T)
  
  #plot(flnam_spiffy, colNA='black')
  #title(main=flnam, sub="Band1")
  #plot(flnam_spiffy, colNA='black') #plot the masked layers - consider adding some functionality to show the NA in black, and then the rest of the plot scaling up from 0, so you can clearly tell how the edges of the F_mask align with 0 value returns
  #title(main=flnam, sub="Band3")
  #plot(flnam_spiffy, colNA='black')
  #title(main=flnam, sub="Band4")
  #print(count)
  #print(f1[i])

  
}

click(Mask4, n=Inf, type="n", show=T, xy = T, cell = T) #can visually inspect each of the plots generate by the function and click on the map to look at values
