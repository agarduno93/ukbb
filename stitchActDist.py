# Stitch together Activity Distribution files to make one master file

import os
import numpy
import pandas as pd

path_in = os.getenv('DATAACTDIST')
in_fn = os.listdir(path_in)

n = 0
for file in in_fn:
    print("N is " + str(n))
    try:
        if 'df' in locals():
            dfapp = pd.read_csv(path_in + "/" + file)
            for i in range(len(dfapp.Value)):
                if dfapp.Value[i] in df.Value:
                    idx = df[df.Value==dfapp.Value[i]].index.values
                    if len(idx) > 0:
                        new_count = [df.Count[idx] + dfapp.Count[i]]
                        df.loc[idx,'Count'] = sum(new_count)
                else:
                    df = df.append(dfapp.iloc[i],ignore_index=True)
        else:
            df = pd.read_csv(path_in + "/" + file)
    except:
        print("Error: " + file)
    n+=1
    print(df)
del df['Percent']
df.to_csv(path_in + "/" + 'masterActDist.csv',index=False)
