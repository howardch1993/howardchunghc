# func
qik_bind = function(file1, file2, output = 'csv', ...) {
    # input
    f1 = file1
    f2 = file2
    tbl1 = read.table(f1)
    tbl2 = read.table(f2)
    tbl = data.frame(mb = tbl1[,1], is.this = tbl1[,1] %in% tbl2[,1])
    # output
    supported = c('csv', 'txt', 'xlsx')
    if (output %in% supported) {
        outs = output
        if (outs == 'csv') write.csv(tbl, paste(f1, '_marked.',outs, sep = ''), quote = F, row.names = F)
        if (outs == 'txt') write.csv(tbl, paste(f1, '_marked.',outs, sep = ''), quote = F, row.names = F, col.names = F)
        if (outs == 'xlsx') {
            library(writexl)
            write_xlsx(tbl, paste(f1, '_marked.',outs, sep = ''))
        }
    } else {
        stop('unsupported output type.')
    }
}

# interactive
#cat('input file1: \n')
#f1 = readline()
#cat('input file2: \n')
#f2 = readline()
#cat('choose type of output file: \n')
#types = readline()
#if (types == '') types = 'csv'

# use
cat('start! \n')
a = Sys.time()
qik_bind('D:/workflows/e0125/tbl_a.txt', 'D:/workflows/e0125/tbl_b.txt', 'csv')
b = Sys.time()
print(b-a)
