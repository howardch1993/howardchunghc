# for single csv

read_telcsv1 = function(file, host = 'localhost', usr, pwd, db, output = 'xlsx', appendable = FALSE, ...) {
	start = Sys.time()

	#re-load
	file = file
	host = host
	usr = usr
	pwd = pwd
	db = db

	######################################################### header
	# for header of file
	# 读取header
	tsv = iconv(readLines(file, n = 1, encoding = "UTF8"), "GBK", "UTF8") # file.choose()
	# 整理header，这时是包含“（元）”的
	str1 = gsub("=|\"", "", strsplit(tsv, ",")[[1]])
	# 创建一个新字符向量
	str2 = character(0)
	# 粘贴必要的SQL语句
	str1_0 = paste(str1, " varchar(255),", sep = "")
	for (i in 1:length(str1)) {
  		str2 = paste(str2, str1_0[i], sep = "")
	}
	# 这时去除“（元）”，避免MYSQL报错
	str2 = gsub("[\\(（]+元+[\\)）]", "", str2)
	# 把结尾是“，”的去掉，避免错误
	if (grepl(",$", str2))
  		str2 = substr(str2, 1, nchar(str2) - 1)

  	########################################################## mysql engine
  	# 链接数据库
	library(RMySQL)
	conn = dbConnect(MySQL(), host = host, user = usr, password = pwd, dbname = db)


	# 创建数据库表的语句, `tmp_tbl`
	dbSendQuery(conn, "drop table if exists tmp_tbl")
	p1 = "create table tmp_tbl (";
	p2 = ") engine = MYISAM default charset = GBK;";
	query1 = paste(p1, str2, p2, sep = "")
	dbSendQuery(conn, query1)

	# 载入数据表数据
	p3 = "load data local infile '"
	p4 = "' into table tmp_tbl fields terminated by ',' lines terminated by '\n' ignore 1 lines;"
	p5 = file # as.character(unlist(print(file.choose()))) # file.choose()
	query2 = paste(p3, p5, p4, sep = '')
	dbSendQuery(conn, query2)

	# 对数据库表`tmp_tbl`执行删除函数del()
	f1 = "drop function if exists del; "
	f2 = "create function del (name varchar(255)) returns varchar(255) begin declare temp1,temp2 varchar(255); set temp1 = replace(replace(name,'\"',''),'=',''); set temp2 = temp1; if temp1 = '' then set temp2 = null; end if; return temp2; end "
	dbSendQuery(conn, f1)
	dbSendQuery(conn, f2)

	# udpate tmp_tbl set [field_name] = del([field_name])
	f_update = "update tmp_tbl set [field_name] = del([field_name]);"
	# 获取tmp_tbl的header
	tmp_header = dbGetQuery(conn, "desc tmp_tbl")[,1]
	# 循环替换
	for (i in 1:length(tmp_header)) {
		dbSendQuery(conn, gsub("\\[+field_name+\\]", tmp_header[i], f_update))
	}

	########################################################## end
	# 获取整理好的数据表到R
	tmp_tbl = dbReadTable(conn, "tmp_tbl")

	# 输出文件
	if (output == 'xlsx') {
		write_xlsx(tmp_tbl, paste(file, ".xlsx", sep = ""))
		} else if (output == 'csv') {
			write.csv(tmp_tbl, paste(file, ".csv", sep = ""), quote = F, row.names = F, fileEncoding = "GBK")
		} else if (output == 'txt') {
			write.table(tmp_tbl, paste(file, ".txt", sep = ""), quote = F, row.names = F, col.names = T, sep = "|",fileEncoding = "GBK")
		} else {
			return(tmp_tbl)
		}

	# 收尾
	if (!appendable) {
		dbSendQuery(conn, "drop table if exists tmp_tbl")
		dbDisconnect(conn)
		rm(conn)
		rm(tmp_tbl)
	}
	
	# del all
	rm(host, usr, pwd, db, tsv, str1, str1_0, str2, f1, f2, p1, p2, p3, p4, p5, query1, query2, f_update, tmp_header)
	stop = Sys.time()
	print(stop - start)
	rm(start, stop)

}