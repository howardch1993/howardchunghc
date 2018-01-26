#!/usr/bin/env python3 
def qik_bind_py(f1 = '', f2 = '', source_in_raw = False, outfile = 'csv'):

    import pandas as pd
    import numpy as np

    # file_dirs
    if f1 == '' :
        print('input file1: ')
        f1 = input()
    else : pass
	if f2 == '' :
		print('input file2: ')
		f2 = input()
	else : pass
	if source_in_raw == 1:
		# ctc spec
		file = open(f2, 'r', encoding = 'UTF-8')
		raw = [x.rstrip('\n') for x in file]
		file.close()
		data = [x.split('|')[0:] for x in raw[3:]]
		data = [x[0:1] for  x in data[0:]]
		f2 = pd.DataFrame(data)
		del(data)
	else : pass
	if outfile == '':
        print('choose type of output file: ')
        outfile = input()
	else : pass
    # load data
    file1 = pd.read_table(f1, header = None)
    if source_in_raw == True:
        file2 = f2
        del(f2)
    else :
        file2 = pd.read_table(f2, header = None)
        del(f2)

    # give colnames
    file1.columns = ['mb']
    file2.columns = ['mb']

    # merge
    file = pd.concat([file1, file1.mb.isin(file2.mb)], axis = 1)
    file.columns = ['mb', 'flag']
    del(file1)
    del(file2)

    if outfile == 'csv':
        # outfile *.csv
        file.to_csv(f1 + '_marked.csv', encoding='utf-8', index = False)
    elif outfile == 'xlsx':
        # outfile *.xlsx maybe not work on windows
        file.to_excel(f1 + '_marked.xlsx', sheet_name = 'merged', index = False)
    else :
        print('unsupported type of output file. run default setting...')
        qik_bind_py(f1, f2, outfile = 'csv')

# calculate program run time
import time
start = time.clock()
qik_bind_py(source_in_raw = True, outfile = 'csv')
end = time.clock()
print('time_use: {} secs'.format('%.2f' % (end - start)))