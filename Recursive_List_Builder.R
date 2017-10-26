#build lists

p1 <- "/media/DATA1/Garik/temp/play"
u1 <- list.files(p1, pattern=glob2rx("*band?.tiff"), recursive = F, full.names = T)

bands <- c(1,2,5)
metaB <- list()

for (i in 1:length(bands)){
  listname <- paste("l", bands[i], sep="")
  bx <- paste("*", bands[i], ".tiff", sep="")
  assign(listname, list.files(path=p1, pattern=(bx), recursive = F, full.names = T))
  metaB[[length(metaB)+1]] <- assign(listname, list.files(path=p1, pattern=(bx), recursive = F, full.names = T))
}

#cat does not return the string provided, it prints it

# Initial list:
#List <- list()

# Now the new experiments
#for(i in 1:3){
  #List[[length(List)+1]] <- list(sample(1:3))
#}

#List