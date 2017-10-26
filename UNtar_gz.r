pth <- 'H:/1A_LANDSAT'
pthout <- "H:/1A_LANDSAT/UNZIPPED"


setwd(pth)

tarfolder<- list.files(pth, pattern=glob2rx("*tar.gz"), recursive=F, full.names=T)

for(i in tarfolder) {
  print (i)
  #x1 <- untar(i, files=NULL, list = T, exdir = pthout, compressed = NA)
  untar(i, files=NULL, list = F, exdir = pthout, compressed = NA, extras = NULL, verbose = FALSE, tar = Sys.getenv("TAR"))
  
} 
print("done")
