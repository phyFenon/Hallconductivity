import numpy as np
import matplotlib.pyplot as plt




def merge(file1,file2):
    f1=open(file1,'a+',encoding='utf-8')
    with open(file2,'r',encoding='utf-8') as f2:
        f1.write('')
        for i in f2:
            f1.write(i)
file1='Bz_all.txt';
i=1
while(i<202):
    file2='B%s.txt'%(i)
    merge(file1,file2)
    i=i+1
    

