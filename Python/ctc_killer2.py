import pandas as pd
import numpy as np
import re

# 按整数x生成abcd字母序列. x = 3, 输出['a', 'b', 'c']
def alpha_man(x):
    ls = [chr(i) for i in range(97, 123)][0:x]
    return(ls)

# 电信CSV格式化
def csv_formatter(file, header = True, encoding = 'UTF-8', sep = ',', ctc_spec = True):
    file = open(file, 'r', encoding = encoding)
    raw = [x.rstrip('\n') for x in file]
    file.close()
    raw = [x.split(sep) for x in raw]
    data = []
    for i in range(len(raw)):
        tmp = [re.sub(r'[\=\"]', '', x) for x in raw[i]]
        data.append(tmp)
    if header == True:
        head = data.pop(0)
    data = pd.DataFrame(data)
    if ctc_spec == True: # True仅用于使用状态表格
        data.pop(16)
    if header == True:
        data.columns = head
    else: data.columns = alpha_man(len(data.columns))
    return(data)

df = csv_formatter(file = '/Users/howardchung/Downloads/B20170905101620726_0.csv', encoding = 'GBK')

# 手动一个一个输入文件地址
def file_typer_manual():
    file = []
    while True:
        print('input file name: (type "#" to end input)')
        fi = input()
        if fi == '#':
            break
        else :
            file.append(fi)
    return(file)

# 自动获取一个文件目录下所有的文件名
def file_typer_auto(urdir = ''):
    import os
    if urdir == '':
        print('intput a file diraction: ')
        urdir = input()
        dirlist = os.listdir(urdir)
    else :
        dirlist = os.listdir(urdir)
    dirlist = [urdir + '/' + x for x in dirlist]
    return(dirlist)

###### 
file = '/Users/howardchung/Documents/省移互/sample/B20171213092923908_01.csv'
urdir = '/Users/howardchung/Documents/省移互/sample'
filelist = file_typer_auto(urdir)
##### 合并文件
df0 = pd.DataFrame()
for i in range(len(filelist)):
    tmp = csv_formatter(file = filelist[i], encoding = 'GBK', ctc_spec = False)
    df0 = df0.append(tmp)
df0.to_excel(urdir + '_merge.xlsx', index = False) # 将整个文件夹的文件合并并输出为excel