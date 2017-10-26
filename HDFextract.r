#This function is for extracting the bands from an HDF file
#x is one hdf file
#all is boolean, TRUE to extract all bands, and FALSE to use your own vector of band names
#bands is a vector of the individual bands you want to extract; ex bands <- c(3, 4, 5)

HDFextract <- function (x, ALL, bands){ #ALL is boolean, x is a hdf file, and bands is an optional vector supplied
	if (!"MODIS" %in% installed.packages()) {install.packages("MODIS", repos="http://R-Forge.R-project.org")} 
	require(MODIS) #need to download MODIS package
	bands <- bands
	ALL = ALL
	df <- getSds(x) #get the SDS (band designations) of MODIS data
	dt <- as.vector(df$SDS4gdal) # vectorize the longform band names with tile names
	dv <- as.vector(df$SDSnames) #vectorize the band names
	if (ALL == T) { #if you are interested in extracting all of the bands in the hdf
		for (i in 1:length(dt)){
			ds <- dt[i] #define working band within the vector of the longform tile names
			fnam <- substr(ds, 19, 49) #get vector of the tile names shortened
			dh <- dv[i] #define working band's band name
			dhx <- paste (dh, sep="") #remove spaces in names (if there are any)
			comx <- paste('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"', fnam, '":Grid:',sep="") #paste the tile from which a band is being extracted
			com <- paste(comx,dhx, " ", sep="") #show the badn name that is being extracted + what was in the previous line
			floutname <- ds #call working band again as separate object *so as not to be confused??
			flout <- substr(floutname, 19, 45) #shorten name of working band
			command <- paste (com,flout, "_", dh, ".tiff", sep="") #the overall command, printing a comment, the adjusted name of the gdal tile, the working band name, add .tiff, with no separations
			cat(command, "\n") #will print the command so you know what is executing
			system(command) #invoke the system command, deriving from the functions listed above
		}	
	} else if ( length (bands) > 0 && ALL == F){ #if a vector for specific bands has been supplied and the ALL option not on default ALL
		for (i in bands){
			ds <- dt[i]
			fnam <- substr(ds, 19, 49)
			dh <- dv[i]
			dhx <- paste(dh, sep="")
			comx <- paste('gdal_translate -of GTiff  HDF4_EOS:EOS_GRID:"',fnam, '":Grid:',sep="")
			com <- paste(comx,dhx, " ", sep="")
			floutname <- ds
			flout <- substr(floutname, 19, 45)
			command <- paste (com,flout, "_", dh, ".tiff", sep="")
			cat(command, "\n")
			system(command)
		}
	}
}	