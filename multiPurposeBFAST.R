####Script written for multipurpose use of bfast including options for linux/windows compatability and integrating some
####of the new data/metadata chanes made by NASA. This is primarily meant for the use of Landsat data.

####NASA data changes: as of 2014, NASA has changed methods for A2 product downloads, giving the options to download
####advanced products directly and to obtain metadata, including the GCP files for each scene, directly. This script is
####initially based on using an advanced product (eg EVI) downloaded from ESPA along with the metadata. There are options 
####included in the script for using A2 product. 

####This script has been annotated with references to a screencast series that will walk users through basic functions

####Identify directories

A1dir <- ""
A2dir <- ""
BRICKdir <- ""
OUTdir <- ""

