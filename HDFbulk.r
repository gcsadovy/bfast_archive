#This function is for bulk processing from a list of hdf files
#It calls function HDFextract, saved separately
#y is a list object of hdf files
#other inputs follow rules of HDFextract

HDFbulk <- function(y, ALL, bands){
	bands <- bands
	ALL <- ALL
	y <- as.vector(y) # list as vector object
	sapply (y, FUN=HDFextract, bands=bands, ALL=ALL) 
  
}