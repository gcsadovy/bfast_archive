#Description: It runs BFAST-monitor for the segment NDVI TS, and save the Breakpoint-date and magnitude parameters into an output csv file
#By Jan Verbesselt and Jose Gonzalez de Tanago. 2012. (jose.gonzalezdetanagomeaca@wur.nl)

require(raster)
require(bfast)

path<-'path_to_NDVI_TS_data/' #path to the NDVI data
setwd(path)

# Call the dates (yyyy-mm-dd) extracted from the file names
dates <- read.csv("dates.csv")$x
dates <- as.Date(dates,"%Y-%m-%d")

## call the Median NDVI Time Series table 
TS<-read.csv("TS_medSegm.csv") # reads the data frame (matrix) containing the NDVI median per segment per time step

xbfastmonitor <- function(x) {
  #ndvi <- timeser(x,dates)
	bfm <- bfastmonitor(formula = response ~ harmon, order=1, data=x,start=c(2007,1),history = c("all"))
	return(cbind(bfm$breakpoint,bfm$magnitude))
}

for (i in 1:nrows(TS)){ #iterates over all the segments-TS
  segmTS<- as.numeric(TS[i,4:88]) #read each segment-TS (i), and converts it from matrix to vector. "i" is the segment id number. "4:88" are the col num of first and last ndvi values of TS  
  ndviTS <- zoo(segmTS, dates) #creates the TS linking the ndvi values with the dates
  ndvi_reg <- bfastts(ndviTS,dates, type="irregular") #bfastts() creates a regular time series object from an irregular TS
  res<-tryCatch(xbfastmonitor(ndvi_reg), error = function(e) {res<-cbind("null","null")})#calls for the function xbfastmonitor with argument the TS reg(ular). Returns the breakpoint time (if exist) and the magnitude of break
  res_seg<-cbind(i,res) # appends the segment id(==i) to the pair of returned values 
  if (i==1){restab<-res_seg}else{restab<-rbind(restab,res_seg)}# creates a data frame with results for all the segment. Each row contains: the segment id (col 1), breakpoint time (col 2) and break magnitude (col 3)
}
write.csv(restab,file="bfastmonitor_Medseg.csv") # save output into a csv file