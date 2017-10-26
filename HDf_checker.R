HDFchecker <- function(x) {
  if (!"MODIS" %in% installed.packages()) {install.packages("MODIS", repos="http://R-Forge.R-project.org")}
  require(MODIS)
  dfSds<- getSds(x)
  dtnam <- as.data.frame(dfSds$SDSnames)
  colnames(dtnam) <- c("band_name")
  dtnam
}