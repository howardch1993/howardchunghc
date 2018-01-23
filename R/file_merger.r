# 目的: 合并同一目录下的csv, txt, xlsx

# elements:
# dir : 文件夹地址
# readLines, iconv: 读取plain文档，用到的函数
# 以下是注释部分 if (false) {...}
if (FLASE) {
# define dir
input_dir

# 获取目录下的所有文件
files = dir(input_dir)

# 读取全数据
full_data = iconv(readLines(files[1], encoding = "UTF8"), "GBK", "UTF8")
for (i in 2:length(files)) {
    full_data = c(full_data, iconv(readLines(files[i], encoding = "UTF8"), "GBK", "UTF8"))
}

# header 标记
header = T

fields = full_data[1] # 表头
datas = full_data[-1] # 数据

rm(full_data)

len = length(datas) # 获取数据行数
datas = strsplit(datas, ",")
# 对datas进行合并
tbl = data.frame(t(gsub("=|\"", "", datas[[1]])))
for (i in 2:len) {
    tbl = rbind(tbl, data.frame(t(gsub("=|\"", "", datas[[i]]))))
}

# 表头部分
colnames(tbl) = t(gsub("=|\"", "", fields[[1]]))

# header = F
header = F 

datas = full_data

len = length(datas)

# 对datas进行合并
tbl = data.frame(t(gsub("=|\"", "", datas[[1]])))
for (i in 2:len) {
    tbl = rbind(tbl, data.frame(t(gsub("=|\"", "", datas[[i]]))))
}

# output_type
output_type = "xlsx"

library(writexl)

write_xlsx(tbl, paste(input_dir,"merged.xlsx"))

output_type = "csv"

write.csv(tbl, paste(input_dir,"merged.csv"), quote = F, row.names = F, fileEncoding = "GBK")

output_type = "txt"

write.table(tbl, paste(input_dir,"merged.txt"), quote = F, row.names = F, fileEncoding = "GBK")
}

# main func

csv_merger = function(input_dir,header = T, output_type = "", ...) {
    files = dir(input_dir, full.names = T)
    full_data = iconv(readLines(files[1], encoding = "UTF8"), "GBK", "UTF8")
    for (i in 2:length(files)) {
        full_data = c(full_data, iconv(readLines(files[i], encoding = "UTF8"), "GBK", "UTF8"))
    }
    if (header) {
        fields = full_data[1]
        datas = full_data[-1]
        rm(full_data)
        len = length(datas)
        datas = strsplit(datas, ",")
        tbl = data.frame(t(gsub("=|\"", "", datas[[1]])))
        for (i in 2:len) {
            tbl = rbind(tbl, data.frame(t(gsub("=|\"", "", datas[[i]]))))
        }
        colnames(tbl) = t(gsub("=|\"", "", fields[[1]]))
    } else if (!header) {
        datas = full_data
        len = length(datas)
        tbl = data.frame(t(gsub("=|\"", "", datas[[1]])))
        for (i in 2:len) {
            tbl = rbind(tbl, data.frame(t(gsub("=|\"", "", datas[[i]]))))
        }
    } else {
        print("header will be set as FALSE. and the function will run again.")
        csv_merger(input_dir,F,output_type)
    }
    if (output_type == "") {
        print("output nothing.")
        return(tbl)
    } else if (output_type == "csv") {
        print("output *.csv file.")
        write.csv(tbl, paste(input_dir,"merged.csv"), quote = F, row.names = F, fileEncoding = "GBK")
    } else if (output_type == "txt") {
        print("output *.txt file seperated by '|'.")
        write.table(tbl, paste(input_dir,"merged.txt"), quote = F, row.names = F, fileEncoding = "GBK", sep = "|")
    } else if (output_type == "xlsx") {
        library(writexl)
        print("output *.xlsx file.")
        write_xlsx(tbl, paste(input_dir,"merged.xlsx"))
    }
}
