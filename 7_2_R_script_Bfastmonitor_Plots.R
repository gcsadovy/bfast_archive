#Description: It run BFAST-monitor for the segment NDVI TS, and save the Plots into seaparate folders if there are Breaks detected or not
#By Jan Verbesselt and Jose Gonzalez de Tanago. 2012. (jose.gonzalezdetanagomeaca@wur.nl)

require(raster)
require(bfast)
require(gdata)
require(graphics)

path<-'path_to_NDVI_TS_data/' #path to the NDVI data
setwd(path)
plpath<-paste(path,"FINALOutputsBFAST/TSplot_bfastmon/",sep="")

# extract dates (yyyy-mm-dd) from file (scene) names (create a vector with the dates of each NDVI scene)
dates <- read.csv("dates.csv")$x
dates <- as.Date(dates,"%Y-%m-%d")

## read the time series and convert from irregular to regular
TS<-read.csv("TS_medSegm.csv") # reads the data frame (matrix) containing the NDVI median per segment per time step

for (i in 1:nrow(TS)){#procces one by one all the segments TS, apply BFASTmonitor and plot the result, saving in different folder if found a break or not
  segmTS<- as.numeric(TS[i,4:88]) #read each row (i) containing segment median TS, and converts it to a vector. "2:86" are the col. numb. of first and last ndvi values of TS  
  ndviTS <- zoo(segmTS, dates) #creates the TS linking the ndvi values with the dates
  ndvi_reg <- bfastts(ndviTS,dates, type="irregular") #bfastts() creates a regular time series object from an irregular TS
  bfm<-as.data.frame(cbind("null","null"))#create a dummy object bfm to handle the cases when Bfastmonitor give error bcs is not able to fit model (too litle observations)
  colnames(bfm)[1]<-"breakpoint"
  colnames(bfm)[2]<-"magnitude"
  bfm <-tryCatch(bfastmonitor(formula = response ~ harmon, order=1, data=ndvi_reg,start=c(2007,1),history = c("all")), error = function(e) {bfm<-bfm})#apply the function bfastmonitor with argument the TS reg(ular). Returns the breakpoint time (if exist) and the magnitude of break 
  seg_id<-i
  if (!bfm$magnitude=="null"){
    plot(bfm, na.rm=TRUE, ylim=c(0.3,0.9))
    if(!is.na(bfm$breakpoint)==TRUE){plotpath<-paste(plpath,"break/",sep="")}else{plotpath<-paste(plpath,"NObreak/",sep="")} #file name for saving the plots
    plotfilenam<-paste(plotpath,"Bfastmonitor-Seg_id",seg_id,".jpg", sep="")
    dev.copy(jpeg,width=850, height=450,filename=plotfilenam)#to create the jpeg object to save the plots
    dev.off()#to save into a jpeg file the plots of the bfastpp with the breakpoints and mixed and linear trends
    }else{}
  rm(bfm) 
  }
