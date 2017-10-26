pth<- '/media/DATA1/Garik/1A/katingan/temp'

#fldr <- list.dirs(pth, recursive=F)

setwd(pth)

tarfolder<- list.files(pth, pattern=glob2rx("*tar.gz"), recursive=F)

for(i in tarfolder) {
  print (i)
  untar(i, files=NULL, list = FALSE, exdir = pth, compressed = NA, extras = NULL, verbose = FALSE, restore_times = TRUE, tar = Sys.getenv("TAR"))
  
} #if you don't bracket, code only runs one of the files
print("done")