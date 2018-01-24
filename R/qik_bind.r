# use
qik_bind(file1 = file.choose(), file2 = file.choose(), 'xlsx')

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