#!/usr/bin/env python3

# base64 python 加密/解密
# 输入字符串，选择模式，输出字符串

def b64coding(str = '', mode = ''):
    # welcome
    import base64
    # check mode
    mode0 = mode
    if mode0 == '':
        print('sir, please enter the mode you want, encode (e) or decode (d): ')
        mode0 = input()
    else: pass

    # check str
    str0 = str
    if str0 == '':
        print('sir, please enter your words: ')
        str0 = input()
    else: pass

    # run
    if mode0 == 'e' or mode0 == 'encode':
        print('keep your key: {}'.format(base64.b64encode(str0.encode()).decode()))
    elif mode0 == 'd' or mode0 == 'decode':
        print('this is what you want: {}'.format(base64.b64decode(str0.encode()).decode()))
    else:
        print('wrong input! try again :)')
        b64coding()

# going on
b64coding()
