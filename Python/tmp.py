# 用于选列，清洗，去重

def extract_field(file, row_start = 0, col = 0, sep = '|', encode = 'UTF-8', deleter = False, duplicated = False):
    import pandas as pd
    import numpy as np
    import re

    file = open(file, 'r', encoding = encode)
    raw = [x.rstrip('\n') for x in file]
    file.close()
    data = [x.split(sep)[col - 1] for x in raw[(row_start - 1):]] # list
    if deleter == True:
        data = [re.sub('\D', '', x) for x in data]
    data = pd.DataFrame(data) # DataFrame
    if duplicated == True:
        data.drop_duplicates(0)
    return(data) # DataFrame

# extract_field('/Users/howardchung/Documents/省移互/样板文件/lijian_trade.csv', 2, 7, ',', 'GBK', True, True)

def binder(f1, f2, col_f1 = 1, col_f2 = 1):
    tbl = pd.concat(f1, (f1.ix[:, (col_f1 - 1):col_f1].isin(f2.ix[:, (col_f2 - 1):col_f2])), axis = 1)
    return(tbl) # DataFrame
