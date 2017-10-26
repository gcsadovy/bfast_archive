
##Script to read landsat GCP files, calculate accuracy stats, and output a summary table.
## Input: GCP.txt files are read from a common folder 
## Output: is a CSV file with each row: scene id, date, Mean RMSE, mean error on X, Y, their SD, and maximum RMSE among the GCP)
## By Jose Gonzalez de Tanago 2012, modified by Eliakim 2013

# set working directory
setwd("")

#Location of the GCP files
pth <- c('') 

outfile <- file("geometric_accuracy.csv", "at")
output<-cbind("scene_id","gcp_id","date","juliandate","Mean_RMSE","Mean_Residual_X","Stdev_X","Mean_Residual_Y","Stdev_Y","MaxRMSE")
fl <- list.files(pth, pattern=glob2rx("*_GCP.txt"), recursive=F)

  #pth<-paste(mainpth,fldr[i],sep="")
  #setwd(pth) 
for (i in 1:length(fl)){
    sid<-substr(fl[i],1,21)
    v <- fl[i]
    gcp<-v
    table <- as.data.frame(read.table (gcp, header=F,skip=5, sep="" ))
    colnames(table) <- c("Point_ID","Latitude", "Longitude", "Height", "Across", "Along","YResidual",  "XResidual")
    erx <- table$YResidual
    ery <- table$XResidual
    xmean<- mean(erx)
    xsd<-sd(erx)
    ysd<-sd(ery)
    ymean<- mean(ery)
    RMSE <- sqrt((erx^2)+(ery^2))
    maxRMSE<-max(RMSE)
    RMSEmean <-mean(RMSE)
    date<-substr(sid,10,16)
    juliandate<-substr(sid,14,16)
    outputi<- cbind(sid,gcp,date,juliandate,RMSEmean,xmean,xsd,ymean,ysd,maxRMSE)
    output <- rbind(output, outputi)
 }
write.csv(output,outfile )
close(outfile)
