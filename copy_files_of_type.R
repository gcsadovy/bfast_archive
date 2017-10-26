setwd("/media/DATA1/Garik")

startdir <-""
copydir <- ""


f1<-list.files(getwd(), pattern = "", all.files = FALSE,
               full.names = TRUE, recursive = TRUE,
               ignore.case = FALSE, include.dirs = TRUE, no.. = FALSE)

file.copy(f1, copydir)

    