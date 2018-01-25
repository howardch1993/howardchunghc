#!/usr/bin/env python3 
def qik_bind_py(f1 = '', f2 = '', outfile = 'csv'):

    import pandas as pd
    import numpy as np

    # file_dirs
    if f1 == '':
        print('input file1: ')
        f1 = input()
    if f2 == '':
        print('input file2: ')
        f2 = input()
    if outfile == '':
        print('choose type of output file: ')
        outfile = input()

    # load data
    file1 = pd.read_table(f1, header = None)
    file2 = pd.read_table(f2, header = None)

    # give colnames
    file1.columns = ['mb']
    file2.columns = ['mb']

    # merge
    file = pd.concat([file1, file1.mb.isin(file2.mb)], axis = 1)
    file.columns = ['mb', 'flag']

    if outfile == 'csv':
        # outfile *.csv
        file.to_csv(f1 + '_marked.csv', encoding='utf-8', index = False)
    elif outfile == 'xlsx':
        # outfile *.xlsx
        file.to_excel(f1 + '_marked.xlsx', sheet_name = 'merged', index = False)
    else :
        print('unsupported type of output file. run default setting...')
        qik_bind_py(f1, f2, outfile = 'csv')

# calculate program run time
import time
start = time.clock()
qik_bind_py(outfile = 'csv')
end = time.clock()
print('time_use: {}'.format(end - start))