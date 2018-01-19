# A function to read and transform files of gdtel (*.csv) to *.xlsx

read_telcsv <- function(file, header = TRUE, toXLSX = FALSE, ...) {
  # read csv through function readLines instead of function read.csv
  tsv = iconv(readLines(file, encoding = "UTF8"), "GBK", "UTF8")
  # seperate fields by ","
  tsv = strsplit(tsv, ",")
  # number of rows of table
  len = length(tsv)
  
  if (!is.logical(header)) {
    stop("bool! you fool.") # when error input
  } else {
    if (header) {
      tbl = data.frame(t(gsub("=|\"","",tsv[[2]]))) # remove the original format
      for (i in 3:len) {
        tbl <- rbind(tbl, data.frame(t(gsub("=|\"","",tsv[[i]]))))
      }
      colnames(tbl) <- gsub("=|\"","",tsv[[1]]) # give the table colume names
    } else if (!header) { # when no header
      tbl = data.frame(t(gsub("=|\"","",tsv[[1]])))
      for (i in 2:len) {
        tbl <- rbind(tbl, data.frame(t(gsub("=|\"","",tsv[[i]]))))
      }
    }
  }
  
  if (!is.logical(toXLSX)) {
    stop("bool! you fool.") # when error input
  } else {
    if (!toXLSX) {
      return(tbl)
    } else if (toXLSX) { # when need for conversion
      # load writexl
      library(writexl)
      write_xlsx(tbl, paste(file, ".xlsx", sep = ""))
    }
  }
  
}
