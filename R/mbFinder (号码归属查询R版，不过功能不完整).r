mbFinder <- function(mobile, ...) {
	# desc 
	## eg. sample = mbFinder(mb)
	## you can get location infomation, if you type "sample$province"	
	
	if (missing(mobile)) {
		stop("you should enter a phone number of mainland China")
	}
	
	# calling taobao api
	api <- "https://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel="
	
	# load "RCurl"
	library(RCurl)
	# get infomation from the web page
	web <- getURL(url = paste(api, mobile, sep = ""),.encoding = "UTF8")
	
	# do some changes on "web"
	str1 <- substr(web,regexpr("=",sub("\n$","",web))[[1]]+2,nchar(sub("\n$","",web)))
	str2 <- gsub("\'","",sub(",","",sub("    |\t|,","",strsplit(str1,"\n")[[1]])[-c(1,9)]))
	m1 <- matrix(unlist(strsplit(str2,':')),ncol=2,byrow=T)
	d1 <- as.data.frame(t(m1[,2]), stringsAsFactors = F)
	colnames(d1) <- as.character(m1[,1])
	
	# end, return a datasheet
	return(d1)
}
