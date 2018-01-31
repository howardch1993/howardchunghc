# a表：'/Users/howardchung/Documents/***/e0129/d88.txt'
# b表：'/Users/howardchung/Documents/***/e0129/isBk.txt'

# 将大文件txt快速提取其中一列（有清洗非数字、去重过程）
def extract_field(file, row_start = 0, col = 0, sep = '|', encode = 'UTF-8', deleter = False, duplicated = False):
    import pandas as pd
    import numpy as np
    import re

    file = open(file, 'r', encoding = encode) # read file
    raw = [x.rstrip('\n') for x in file]
    file.close() # close file
    data = [x.split(sep)[col - 1] for x in raw[(row_start - 1):]] # split
    if deleter == True: # drop non-number data
        data = [re.sub('\D', '', x) for x in data]
    data = pd.DataFrame(data) # DataFrame
    if duplicated == True: # drop duplicate data
        data.drop_duplicates(0)
    return(data) # DataFrame

# 按整数x生成abcd字母序列. x = 3, 输出['a', 'b', 'c']
def alpha_man(x):
    ls = [chr(i) for i in range(97, 123)][0:x]
    return(ls)

# 判断f1的数据是否在f2中，并合并搜索结果
def binder(f1, f2):
    f1 = f1
    f2 = f2
    col_len = len(f1.columns)
    f1.columns = alpha_man(col_len)
    col_len = len(f2.columns)
    f2.columns = alpha_man(col_len)
    tbl = pd.concat([f1, f1.a.isin(f2.a)], axis = 1)
    col_len = len(tbl.columns)
    tbl.columns = alpha_man(col_len)
    return(tbl)
