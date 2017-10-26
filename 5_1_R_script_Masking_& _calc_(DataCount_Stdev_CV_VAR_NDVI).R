#Description: Mask the raster images (ledaps_lndsr with f-mask outputs) saving them into GeoTiff files
#and calc the Standard Deviation, CV and Variance of each pixel along the TS (saving each of them into a raster per spectral band)
#it also retrieves a raster with the counting of available observations (not NA nor masked) per pixel along the TS 
#By Jose Gonzalez de Tanago. 2012. (jose.gonzalezdetanagomeaca@wur.nl)

require("raster")

inpath <- 'path_to_input_data/' #  
outpath<-'path_to_output/'

flmask <- list.files(path=p1, pattern=glob2rx("*_fmask_*"), recursive=F, full.names=T)#this for getting the data of fmask files (include full path)
flmasknam <- list.files(path=p1, pattern=glob2rx("*_fmask_*"), recursive=F, full.names=F)#this only for naming 


B4ls<- list.files(path=inpath, pattern=glob2rx("*band5.tiff"), recursive = F, full.names=T) #create a list to process the Band 4 TS data

#function to mask a band (according to the mask value, in this case the masked values were previously converted to = "0")
funmask<-function(c){
  a<-c[1]
  b<-c[2]
  ifelse(is.na(a)==T | b==0, NA, a)
}# Gives a NA to the pixel if the value of a (spectral band) is already NA or the value of the b(mask) is = 0

#creating a layerstack with each band masked and saving it to file)
for (i in 1:length(flmask)){
  img<- raster (B4ls[i])
    
  mask<- raster (flmask[i])
  imask_stk<-stack(img, mask)
    
  imgdate<-substr(flmasknam[i],1,8) # getting the imagery date for naming by parsing from file name
  imgid<-substr(flmasknam[i],10,18) 
  
  outnam<-paste(imgdate,imgid,"B5_masked.tif",sep="_")
  outname<-paste(outpath,outnam,sep="")
    
  imasked<-calc(imask_stk, fun=funmask, filename = outname, format = "GTiff", overwrite = T)
  cat("outname: ", outname,"\n")
    
}  

#creating a list with all the B4 bands masked files
setwd(outpath)

B4mskls<-list.files(path=outpath, pattern=glob2rx("*B4_masked.tif"), recursive = F, full.names=T) 

####################
#####FUNCTIONS
####################

#function for calculating the standard dev of each pixel across all the layers of the TS stack
funsd<- function(x){
  y<-sd(x, na.rm = T)
  return(y)
}

#function for calculating the coeficient of variation of each pixel across all the layers of the stack
funcv<- function(x){
  y<-(sd(x, na.rm = T)/mean(x,na.rm=T))
  return(y)
}

#function for calculating the var of each pixel across all the layers of the stack
funvar<- function(x){
  y<-var(x, na.rm = T)
  return(y)
}

#function to count the number of available observations for each pixel in the TS stack for a band
fundatacount<- function(x){
  y<-apply(x, 1, FUN=function(x) sum(is.na(x)==F))
  return(y)
}

##########################################################################
##cALCULATIONS of sumary statistics (one band) ###########################
##########################################################################

#creating a stack with all the B4 masked files, and applying the stdev, CV, VAR and count functions  
for (j in 1:length(B4mskls)){
  if (j==1) {B4stk<-raster(B4mskls[j])} else {B4stk<-stack(B4stk, raster(B4mskls[j]))}
}

B4maskedstk<- writeRaster(B4stk, filename ="B4maskedstk.tif", format = "GTiff",dataType="INT2S", overwrite = T)

##
errormesage<-paste(" Error procesing")

#calculate the number of available data (is.na(x)==F) for each pixel in the TS stack
tryCatch(B4stkDataCount<-calc(B4stk, fun=fundatacount, filename ="DataCount_B4stk.tif", format = "GTiff", overwrite = T), error=function(e) print(errormesage), warning=function(w) print(errormesage))

#calc the sd
tryCatch(B4stkSD<-calc(B4stk, fun=funsd, filename ="sd_B4stk.tif", format = "GTiff", overwrite = T), error=function(e) print(errormesage), warning=function(w) print(errormesage))

#calc the Variance
tryCatch(B4stkVAR<-calc(B4stk, fun=funvar, filename ="var_B4stk.tif", format = "GTiff", overwrite = T), error=function(e) e, warning=function(w) w)


#calc the CV
tryCatch(B4stkCV<-calc(B4stk, fun=funcv, filename ="cv_B4stk.tif", format = "GTiff", overwrite = T), error=function(e) print(errormesage), warning=function(w) print(errormesage))

#############################################
###NDVI and EVI calculation
#####################

#NOTE: inputs are layer stack with all the bands in a tiff file. Adapt to the data format

stk_ls<-list.files(path=inpath, pattern=glob2rx("*_mskd_stk.tif"), recursive = F, full.names=T)
stk_lsn<-list.files(path=inpath, pattern=glob2rx("*_mskd_stk.tif"), recursive = F, full.names=F)

funEVI<- function(x){
  b1<-x[1]
  b3<-x[3]
  b4<-x[4]
  EVI<-2.5*((b4-b3)/(b4+6*b3-7.5*b1+1))
  return(EVI)
}
funNDVI<- function(x){
  b3<-x[3]
  b4<-x[4]
  NDVI<-((b4-b3)/(b4+b3))
  return(NDVI)
}

for (i in 1:length(stk_ls)){
  img<-brick(stk_ls[i]) 
  imgnam<-substr(stk_lsn[i],1,18)
  outnam1<-paste(imgnam,"_EVI.tiff",sep="")
  outname1<-paste(outpath,outnam1,sep="")
  outnam2<-paste(imgnam,"_NDVI.tiff",sep="")
  outname2<-paste(outpath,outnam2,sep="")
  cat(i,"outname1: ",outname1,"\n")
  tryCatch(vegetIndex<-calc(img, fun=funEVI, filename =outname1, format = "GTiff", overwrite = T), error=function(e) e, warning=function(w) w)
  tryCatch(vegetIndex<-calc(img, fun=funNDVI, filename =outname2, format = "GTiff", overwrite = T), error=function(e) e, warning=function(w) w)
}  

