pth<- '/media/DATA1/Garik/temp'

#fldr <- list.dirs(pth, recursive=F)

setwd(pth)

tarfolder<- list.files(pth, pattern=glob2rx("*tar.gz"), recursive=F)

for(i in tarfolder) 
  print(i)
  #setwd('/media/DATA1/Garik/reflectance/katingan/188062/188062_LE7')
  
  dirnam<-substr(i,1,40)
  
  outdir<-paste('untar/',dirnam,'/', sep='')
  
  dir.create(paste(pth,outdir,sep=''))
  
  com<-paste('tar -xvzf',i, '-C',outdir, sep=' ')
  
  system(com)
  
