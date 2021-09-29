# Stitch together IVIS files to make one master file

import os
import pandas as pd
path_IVIS = os.getenv('DATAIVIS')
IVIS_fn = os.listdir(path_IVIS)
n = 0
for file in IVIS_fn:
    print("N is " + str(n))
    try:
        if 'df' in locals():
            dfapp = pd.read_csv(path_IVIS + "/" + file)
            df = df.append(dfapp,ignore_index=True)
        else:
            df = pd.read_csv(path_IVIS + "/" + file)
    except:
        print("Error: " + file)
    n+=1

col_names = list(df.columns)
del df[col_names[0]]

df.to_csv(path_IVIS + "/" + 'Batch_fullfiles_masterIVIS.csv',index=False)

