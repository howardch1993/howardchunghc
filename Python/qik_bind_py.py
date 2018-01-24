#!/usr/bin/env python3 
def qik_bind_py(outfile = ''):

    import pandas as pd
    import numpy as np

    # file_dirs
    print('input file1: ')
    f1 = input()
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
        file.to_csv(f1 + '.csv', encoding='utf-8', index = False)
    elif outfile == 'xlsx':
        # outfile *.xlsx
        file.to_excel(f1 + '.xlsx', sheet_name = 'merged', index = False)
    else :
        print('unsupported type of output file. run default setting...')
        qik_bind_py(outfile = 'csv')

qik_bind_py()