#Code for creating a list of files from a directory with a certain characteristic 
#and then either copying them to another directory or deleting them

#get list of files in question
setwd("") #where you want to get the files
p1 <- getwd()
p2 <- "" #where you want to put the files
f1 <- list.files(p1, pattern = "", recursive = FALSE)

#copy files to another location
files.copy(f1, p2)

#delete files from first directory
unlink(f1, recursive = FALSE, force = FALSE)