# import csv file
tbl <- read.csv(file.choose(),stringsAsFactors = F)

# edit header
colnames(tbl) <- gsub("[A-Za-z0-9.]","",names(tbl))

# clear abnormal characters
for (i in 1:nrow(tbl)) {
for (j in 1:ncol(tbl)) {
tbl[i,j] = gsub("[=,]","",tbl[i,j])
}}

# a datasheet include column names and types
tbl_desp <- data.frame(name = names(tbl), is.num = !is.na(as.numeric(as.character(tbl[1,]))))

# create a function

# a R function to change type of R objects in batches
# as.character(), as.complex(), as.numeric(), as.integer(), as.logical(), etc...

value.format <- function(data = mtcars, format = "character", help = FALSE, ...) {

# get help
if (help == TRUE) {
sheet = data.frame("The type of R object" = c("character","numeric","logical","complex","factor","vector","matrix","data.frame","list"))
print(sheet)
return("Types above are supported.")
}

# measures for wrong inputs
if (!(format %in% c("character","numeric","logical","complex","factor","vector","matrix","data.frame","list"))) {
print("You have entered a wrong parameter.")
return(value.format(help = TRUE))
}

# text for non-datasheet
t1 = gsub("FORMAT",format,"data = as.FORMAT(data)")
# text for datasheet
t2 = gsub("FORMAT",format,"for (i in 1:ncol(data)) {data[,i] = as.FORMAT(data[,i])}")

# run
if (is.data.frame(data) == FALSE) {
eval(parse(t = t1))
} else {
eval(parse(t = t2))
}

return(data)

}

# end create function

# to convert type of columns supposed to be numeric to numeric type 
value.format(tbl[,which(names(tbl) %in% as.character(tbl_desp[which(tbl_desp[,2] == TRUE),1]))],"numeric") -> tbl[,which(names(tbl) %in% as.character(tbl_desp[which(tbl_desp[,2] == TRUE),1]))]

# adjust the parameter of scientific notation
options(scipen=200)
