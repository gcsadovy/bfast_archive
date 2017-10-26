#THE PURPOSE: The purpose of this code is to facilatate automatic extraction of bands from hdf files using GDAL translation. 
##So far the code works on Linux

# CREATED BY:Jose and Kim

# set working directory
setwd(" ")

#Location of the HDF files
pth <- c(' ') 

# read and create list all hdf files available in the folder
fl <- list.files(pth, pattern=glob2rx("lndsr.*.hdf"), recursive=F)


# use this function to see which and how many bands are available in a HDF file 
HDfChecker <- function (x){
 if (!"MODIS" %in% installed.packages()) {install.packages("MODIS", repos="http://R-Forge.R-project.org")} 
 require(MODIS) 
 dfSds<- getSds(x)
 dtnam <- as.data.frame(dfSds$SDSnames)
 colnames(dtnam) <- c("band_name")
  cat(dtnam) 
}

# this function is for extracting the bands from a HDF file
# the inputs is one hdf file
#To extract all bands from the HDF file, the parameter  ALL should be set to TRUE
# To extract only specific bands, the parameter "bands", which is a vector of band numbers that should be extracted, should be provided
## use function "HDfChecker" to see names and numbers of bands available in the HDF and create a vector e.g bands <- c(2, 5, 8), to extract band 2, 5, 8

HDf_bExtrct <- function (x, ALL, bands){ 
  if (!"MODIS" %in% installed.packages()) {install.packages("MODIS", repos="http://R-Forge.R-project.org")} 
  require(MODIS)
  bands <- bands
  ALL = ALL
  df<- getSds(x)
  dt <- as.vector(df$SDS4gdal)
  dv <- as.vector(df$SDSnames)
  if (ALL == T){
   for (i in 1:length(dt)){
     ds <- dt[i]
     fnam<-substr(ds,19,49)  
     dh <- dv[i]
     dhx <- paste (dh, sep="")
     comx <- paste('gdal_translate -of GTiff  HDF4_EOS:EOS_GRID:"',fnam, '":Grid:',sep="")
     com <- paste (comx,dhx, " ", sep="")
     floutname <-ds
     flout<-substr(floutname,19,45)  
     command <-paste (com,flout,"_", dh, ".tiff",sep="")
     cat(command,"\n") #prints in the console which command is executing at each moment
     system(command)
  }
  } else if ( length (bands) > 0 && ALL == F){
    for (i in bands){
      ds <- dt[i]
      fnam<-substr(ds,19,49)  
      dh <- dv[i]
      dhx <- paste (dh, sep="")
      comx <- paste('gdal_translate -of GTiff  HDF4_EOS:EOS_GRID:"',fnam, '":Grid:',sep="")
      com <- paste (comx,dhx, " ", sep="")
      floutname <-ds
      flout<-substr(floutname,19,45)  
      command <-paste (com,flout,"_", dh, ".tiff",sep="")
      cat(command,"\n") #prints in the console which command is executing at each moment
      system(command)
    }
  }
}

# this function is for  processing many hdf automatically
# It calls "HDf_bExtrct" function and use sapply function to process all hdf files
# inputs are a list of hdf files
HDf_ALL_files <- function (y, ALL, bands){#  takes a list of hdf files. 
  bands <- bands
  ALL <- ALL
  y <- as.vector(y)
  sapply (y, FUN=HDf_bExtrct, bands = bands, ALL = ALL)
}

#################################################
#EXAMPLES
#################################################
#1. I want extract all bands in all HDF files
HDf_ALL_files(fl, ALL = T, bands) # do not run

#2. Only want band 3, Band 4 and band 17

HDfChecker(fl[1])

## output HDfChecker function
# > HDfChecker(fl[1])
#                band_name
# 1              band1
# 2              band2
# 3              band3
# 4              band4
# 5              band5
# 6              band7
# 7      atmos_opacity
# 8            fill_QA
# 9             DDV_QA
# 10          cloud_QA
# 11   cloud_shadow_QA
# 12           snow_QA
# 13     land_water_QA
# 14 adjacent_cloud_QA
# 15             band6
# 16     band6_fill_QA
# 17        fmask_band

# now create the vector of bands you want to extract
bands <- c(3, 4, 17)
#now call HDf_ALL_files, but ALL must be set to FALSE here
HDf_ALL_files(fl, ALL = F, bands)
