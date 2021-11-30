# Stitch together IVIS files to make one master file

import os
import numpy
import pandas as pd

path_in = os.getenv('DATAMDY')
in_fn = os.listdir(path_in)

n = 0
for file in in_fn:
    print("N is " + str(n))
    try:
        if 'df' in locals():
            dfapp = pd.read_csv(path_in + "/" + file)
            df = df.append(dfapp,ignore_index=True)
        else:
            df = pd.read_csv(path_in + "/" + file)
    except:
        print("Error: " + file)
    n+=1

col_names = list(df.columns)

df.to_csv(path_in + "/" + 'masterMDY.csv',index=False)

